classdef PressureVaryingTestSection < TestSectionRepeatedWSpec
    
    methods
        function obj = PressureVaryingTestSection(name, varName, bFinder, tests)
            obj@TestSectionRepeatedWSpec(name, varName, bFinder, tests);
        end
        
        function returnStruct = doStuffWithData(obj, app, data, ~, ~, parentIndices, runOpts)
            nTimes = obj.BFinder.getN();
            nTests = length(obj.NestedTests);
            nLoads = 0;
            nSASample = length(runOpts.SASampleVals);
            nLoadSample = length(runOpts.LoadSampleVals);
            pOptions = zeros(nTimes, 1);
            foundLoads = false;
            for j = 1:nTests
                test = obj.NestedTests(j);
                if isa(test, 'LoadsTestSection')
                    foundLoads = true;
                    nLoads = test.BFinder.getN();
                    break;
                end
            end
            
            if ~foundLoads
                error('Matt error: no loads found in intermediate test section');
            end
            
            app.LatPressureLUTData = struct( ...
                'saData', {cell(nLoads, nTimes)}, ...
                'fzData', {cell(nLoads, nTimes)}, ...
                'nfyData', {cell(nLoads, nTimes)}, ...
                'mzData', {cell(nLoads, nTimes)}, ...
                'nfyC', zeros(6, nLoads, nTimes), ...
                'mzC', zeros(6, nLoads, nTimes), ...
                'nfyExitFlags', zeros(nLoads, nTimes), ...
                'mzExitFlags', zeros(nLoads, nTimes), ...
                'nfyLoadPolyCoeff', 0, ...
                'mzLoadPolyCoeff', 0, ...
                'nfyVals', zeros(nSASample, nLoadSample, nTimes), ...
                'mzVals', zeros(nSASample, nLoadSample, nTimes), ...
                'meanLoads', zeros(nLoads, nTimes), ...
                'fzOptions', 0, ...
                'pOptions', 0);
            
            for i = 1:nTimes
                for j = 1:nTests
                    newIndices = [parentIndices, i, j];
                    test = obj.NestedTests(j);
                    
                    nestedLB = getNestedLB(obj, newIndices);
                    nestedUB = getNestedUB(obj, newIndices);
                    
                    retStruct = test.doStuffWithData( ...
                        app, ...
                        data, ...
                        nestedLB, ...
                        nestedUB, ...
                        newIndices, ...
                        runOpts);
                    if isa(test, 'LoadsTestSection')
                        app.LatPressureLUTData.saData = assign1DCellInto2DCell(app.LatPressureLUTData.saData, retStruct.saData, i);
                        app.LatPressureLUTData.fzData = assign1DCellInto2DCell(app.LatPressureLUTData.fzData, retStruct.fzData, i);
                        app.LatPressureLUTData.nfyData = assign1DCellInto2DCell(app.LatPressureLUTData.nfyData, retStruct.nfyData, i);
                        app.LatPressureLUTData.mzData = assign1DCellInto2DCell(app.LatPressureLUTData.mzData, retStruct.mzData, i);
                        app.LatPressureLUTData.nfySamplePoints(:, :, i) = retStruct.nfySamplePoints;
                        app.LatPressureLUTData.mzSamplePoints(:, :, i) = retStruct.mzSamplePoints;
                        app.LatPressureLUTData.nfyC(:, :, i) = retStruct.nfyC;
                        app.LatPressureLUTData.mzC(:, :, i) = retStruct.mzC;
                        app.LatPressureLUTData.nfyExitFlags(:, i) = retStruct.nfyExitFlags;
                        app.LatPressureLUTData.mzExitFlags(:, i) = retStruct.mzExitFlags;
                        
                        retNfyLoadPolyCoeff = retStruct.nfyLoadPolyCoeff;
                        nLoadCoeff = size(retNfyLoadPolyCoeff, 1);
                        if i == 1
                            app.LatPressureLUTData.nfyLoadPolyCoeff = zeros(nLoadCoeff, nSASample, nTimes);
                            app.LatPressureLUTData.mzLoadPolyCoeff = zeros(nLoadCoeff, nSASample, nTimes);
                        end
                        app.LatPressureLUTData.nfyLoadPolyCoeff(:, :, i) = retNfyLoadPolyCoeff;
                        app.LatPressureLUTData.mzLoadPolyCoeff(:, :, i) = retStruct.mzLoadPolyCoeff;
                        
                        app.LatPressureLUTData.nfyVals(:, :, i) = retStruct.nfyVals;
                        app.LatPressureLUTData.mzVals(:, :, i) = retStruct.mzVals;
                        app.LatPressureLUTData.meanLoads(:, i) = retStruct.meanLoads;
                        app.LatPressureLUTData.fzOptions = retStruct.fzOptions;
                        
                        pOptions(i) = mean(data.P(nestedLB:nestedUB));
                    end
                end
            end
            
            % Display pressure in psi not kPa
            pOptions = pOptions * 0.145038;
            pOptions = round(pOptions);
            [pOptions, order] = sort(pOptions);
            
            app.LatPressureLUTData.pOptions = pOptions;
            
            app.LatPressureLUTData.nfyVals(:, :, :) = app.LatPressureLUTData.nfyVals(:, :, order);
            app.LatPressureLUTData.mzVals(:, :, :) = app.LatPressureLUTData.mzVals(:, :, order);
            app.LatPressureLUTData.saData = reorder2DCellDim2(app.LatPressureLUTData.saData, order);
            app.LatPressureLUTData.fzData = reorder2DCellDim2(app.LatPressureLUTData.fzData, order);
            app.LatPressureLUTData.nfyData = reorder2DCellDim2(app.LatPressureLUTData.nfyData, order);
            app.LatPressureLUTData.mzData = reorder2DCellDim2(app.LatPressureLUTData.mzData, order);
            app.LatPressureLUTData.nfySamplePoints(:, :, :) = app.LatPressureLUTData.nfySamplePoints(:, :, order);
            app.LatPressureLUTData.mzSamplePoints(:, :, :) = app.LatPressureLUTData.mzSamplePoints(:, :, order);
            app.LatPressureLUTData.nfyC(:, :, :) = app.LatPressureLUTData.nfyC(:, :, order);
            app.LatPressureLUTData.mzC(:, :, :) = app.LatPressureLUTData.mzC(:, :, order);
            app.LatPressureLUTData.nfyExitFlags(:, :) = app.LatPressureLUTData.nfyExitFlags(:, order);
            app.LatPressureLUTData.mzExitFlags(:, :) = app.LatPressureLUTData.mzExitFlags(:, order);
            
            returnStruct = struct();
        end
    end
end