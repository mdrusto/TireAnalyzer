classdef CamberVaryingTestSection < TestSectionRepeatedWSpec
    
    methods
        function obj = CamberVaryingTestSection(name, varName, bFinder, tests)
            obj@TestSectionRepeatedWSpec(name, varName, bFinder, tests);
        end
        
        function returnStruct = doStuffWithData(obj, app, data, ~, ~, parentIndices, runOpts)
            nTimes = obj.BFinder.getN();
            nTests = length(obj.NestedTests);
            nLoads = 0;
            nSASample = length(runOpts.SASampleVals);
            nLoadSample = length(runOpts.LoadSampleVals);
            iaOptions = zeros(nTimes, 1);
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
            
            app.LatCamberLUTData = struct( ...
                'saData', {cell(nTimes, nLoads)}, ...
                'fzData', {cell(nTimes, nLoads)}, ...
                'nfyData', {cell(nTimes, nLoads)}, ...
                'mzData', {cell(nTimes, nLoads)}, ...
                'nfyC', zeros(6, nLoads, nTimes), ...
                'mzC', zeros(6, nLoads, nTimes), ...
                'nfyExitFlags', zeros(nLoads, nTimes), ...
                'mzExitFlags', zeros(nLoads, nTimes), ...
                'nfySamplePoints', zeros(nSASample, nLoads, nTimes), ...
                'mzSamplePoints', zeros(nSASample, nLoads, nTimes), ...
                'nfyLoadPolyCoeff', 0, ...
                'mzLoadPolyCoeff', 0, ...
                'nfyVals', zeros(nSASample, nLoadSample, nTimes), ...
                'mzVals', zeros(nSASample, nLoadSample, nTimes), ...
                'meanLoads', zeros(nLoads, nTimes), ...
                'fzOptions', 0, ...
                'iaOptions', 0);
            
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
                        app.LatCamberLUTData.saData = assign1DCellInto2DCell(app.LatCamberLUTData.saData, retStruct.saData, i);
                        app.LatCamberLUTData.fzData = assign1DCellInto2DCell(app.LatCamberLUTData.fzData, retStruct.fzData, i);
                        app.LatCamberLUTData.nfyData = assign1DCellInto2DCell(app.LatCamberLUTData.nfyData, retStruct.nfyData, i);
                        app.LatCamberLUTData.mzData = assign1DCellInto2DCell(app.LatCamberLUTData.mzData, retStruct.mzData, i);
                        app.LatCamberLUTData.nfySamplePoints(:, :, i) = retStruct.nfySamplePoints;
                        app.LatCamberLUTData.mzSamplePoints(:, :, i) = retStruct.mzSamplePoints;
                        app.LatCamberLUTData.nfyC(:, :, i) = retStruct.nfyC;
                        app.LatCamberLUTData.mzC(:, :, i) = retStruct.mzC;
                        app.LatCamberLUTData.nfyExitFlags(:, i) = retStruct.nfyExitFlags;
                        app.LatCamberLUTData.mzExitFlags(:, i) = retStruct.mzExitFlags;
                        
                        retNfyLoadPolyCoeff = retStruct.nfyLoadPolyCoeff;
                        nLoadCoeff = size(retNfyLoadPolyCoeff, 1);
                        if i == 1
                            app.LatCamberLUTData.nfyLoadPolyCoeff = zeros(nLoadCoeff, nSASample, nTimes);
                            app.LatCamberLUTData.mzLoadPolyCoeff = zeros(nLoadCoeff, nSASample, nTimes);
                        end
                        app.LatCamberLUTData.nfyLoadPolyCoeff(:, :, i) = retNfyLoadPolyCoeff;
                        app.LatCamberLUTData.mzLoadPolyCoeff(:, :, i) = retStruct.mzLoadPolyCoeff;
                        
                        app.LatCamberLUTData.nfyVals(:, :, i) = retStruct.nfyVals;
                        app.LatCamberLUTData.mzVals(:, :, i) = retStruct.mzVals;
                        app.LatCamberLUTData.meanLoads(:, i) = retStruct.meanLoads;
                        app.LatCamberLUTData.fzOptions = retStruct.fzOptions;
                        
                        iaOptions(i) = mean(data.IA(nestedLB:nestedUB));
                    end
                end
            end
            
            iaOptions = round(iaOptions);
            [iaOptions, order] = sort(iaOptions);
            
            app.LatCamberLUTData.ia_options = iaOptions;
            
            app.LatCamberLUTData.saData = reorder2DCellDim2(app.LatCamberLUTData.saData, order);
            app.LatCamberLUTData.fzData = reorder2DCellDim2(app.LatCamberLUTData.fzData, order);
            app.LatCamberLUTData.nfyData = reorder2DCellDim2(app.LatCamberLUTData.nfyData, order);
            app.LatCamberLUTData.mzData = reorder2DCellDim2(app.LatCamberLUTData.mzData, order);
            app.LatCamberLUTData.nfyC = app.LatCamberLUTData.nfyC(:, :, order);
            app.LatCamberLUTData.mzC = app.LatCamberLUTData.mzC(:, :, order);
            app.LatCamberLUTData.nfyExitFlags = app.LatCamberLUTData.nfyExitFlags(:, order);
            app.LatCamberLUTData.mzExitFlags = app.LatCamberLUTData.mzExitFlags(:, order);
            app.LatCamberLUTData.nfySamplePoints = app.LatCamberLUTData.nfySamplePoints(:, :, order);
            app.LatCamberLUTData.mzSamplePoints = app.LatCamberLUTData.mzSamplePoints(:, :, order);
            app.LatCamberLUTData.nfyVals = app.LatCamberLUTData.nfyVals(:, :, order);
            app.LatCamberLUTData.mzVals = app.LatCamberLUTData.mzVals(:, :, order);
            
            returnStruct = struct();
        end
    end
end