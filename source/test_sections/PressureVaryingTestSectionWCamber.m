classdef PressureVaryingTestSectionWCamber < TestSectionRepeatedWSpec
    
    methods
        function obj = PressureVaryingTestSectionWCamber(name, varName, bFinder, tests)
            obj@TestSectionRepeatedWSpec(name, varName, bFinder, tests);
        end
        
        function returnStruct = doStuffWithData(obj, app, data, ~, ~, parentIndices, runOpts)
            nTimes = obj.BFinder.getN();
            nTests = length(obj.NestedTests);
            nCamber = 0;
            nLoads = 0;
            nSASample = length(runOpts.SASampleVals);
            nLoadSample = length(runOpts.LoadSampleVals);
            pOptions = zeros(nTimes, 1);
            foundCamber = false;
            for j = 1:nTests
                test = obj.NestedTests(j);
                if isa(test, 'IntermediateLevelCamberTestSection')
                    foundCamber = true;
                    nCamber = test.BFinder.getN();
                    for k = 1:length(test.NestedTests)
                        nestedTest = test.NestedTests(k);
                        if isa(nestedTest, 'LoadsTestSection')
                            nLoads = nestedTest.BFinder.getN();
                            break;
                        end
                    end
                    break;
                end
            end
            
            if ~foundCamber
                error('Matt error: no loads found in intermediate test section');
            end
            
            app.LatLUTData = struct( ...
                'saData', {cell(nLoads, nCamber, nTimes)}, ...
                'fzData', {cell(nLoads, nCamber, nTimes)}, ...
                'nfyData', {cell(nLoads, nCamber, nTimes)}, ...
                'mzData', {cell(nLoads, nCamber, nTimes)}, ...
                'nfyC', zeros(6, nLoads, nCamber, nTimes), ...
                'mzC', zeros(6, nLoads, nCamber, nTimes), ...
                'nfyExitFlags', zeros(nLoads, nCamber, nTimes), ...
                'mzExitFlags', zeros(nLoads, nCamber, nTimes), ...
                'nfyLoadPolyCoeff', 0, ...
                'mzLoadPolyCoeff', 0, ...
                'nfyVals', zeros(nSASample, nLoadSample, nCamber, nTimes), ...
                'mzVals', zeros(nSASample, nLoadSample, nCamber, nTimes), ...
                'meanLoads', zeros(nLoads, nCamber, nTimes), ...
                'fzOptions', zeros(nLoads, 1), ...
                'iaOptions', zeros(nCamber, 1), ...
                'pOptions', zeros(nTimes, 1));
            
            for i = 1:nTimes
                %disp(['Pressure #' num2str(i)])
                for j = 1:nTests
                    newIndices = [parentIndices, i, j];
                    test = obj.NestedTests(j);
                    
                    nestedLB = getNestedLB(obj, newIndices);
                    nestedUB = getNestedUB(obj, newIndices);
                    
                    ret_struct = test.doStuffWithData( ...
                        app, ...
                        data, ...
                        nestedLB, ...
                        nestedUB, ...
                        newIndices, ...
                        runOpts);
                    if isa(test, 'IntermediateLevelCamberTestSection')
                        app.LatLUTData.saData = assign_2dcell_into_3dcell(app.LatLUTData.saData, ret_struct.saData, i);
                        app.LatLUTData.fzData = assign_2dcell_into_3dcell(app.LatLUTData.fzData, ret_struct.fzData, i);
                        app.LatLUTData.nfyData = assign_2dcell_into_3dcell(app.LatLUTData.nfyData, ret_struct.nfyData, i);
                        app.LatLUTData.mzData = assign_2dcell_into_3dcell(app.LatLUTData.mzData, ret_struct.mzData, i);
                        app.LatLUTData.nfySamplePoints(:, :, :, i) = ret_struct.nfySamplePoints;
                        app.LatLUTData.mzSamplePoints(:, :, :, i) = ret_struct.mzSamplePoints;
                        app.LatLUTData.nfyC(:, :, :, i) = ret_struct.nfyC;
                        app.LatLUTData.mzC(:, :, :, i) = ret_struct.mzC;
                        app.LatLUTData.nfyExitFlags(:, :, i) = ret_struct.nfyExitFlags;
                        app.LatLUTData.mzExitFlags(:, :, i) = ret_struct.mzExitFlags;
                        
                        retNfyLoadPolyCoeff = ret_struct.nfyLoadPolyCoeff;
                        nLoadCoeff = size(retNfyLoadPolyCoeff, 1);
                        if i == 1
                            app.LatLUTData.nfyLoadPolyCoeff = zeros(nLoadCoeff, nSASample, nCamber, nTimes);
                            app.LatLUTData.mzLoadPolyCoeff = zeros(nLoadCoeff, nSASample, nCamber, nTimes);
                        end
                        app.LatLUTData.nfyLoadPolyCoeff(:, :, :, i) = retNfyLoadPolyCoeff;
                        app.LatLUTData.mzLoadPolyCoeff(:, :, :, i) = ret_struct.mzLoadPolyCoeff;
                        
                        app.LatLUTData.nfyVals(:, :, :, i) = ret_struct.nfyVals;
                        app.LatLUTData.mzVals(:, :, :, i) = ret_struct.mzVals;
                        app.LatLUTData.meanLoads(:, :, i) = ret_struct.meanLoads;
                        app.LatLUTData.fzOptions = ret_struct.fzOptions;
                        app.LatLUTData.iaOptions = ret_struct.iaOptions;
                        
                        pOptions(i) = mean(data.P(nestedLB:nestedUB));
                        
                    end
                end
            end
            
            % Display pressure in psi not kPa
            pOptions = pOptions * 0.145038;
            pOptions = round(pOptions);
            [pOptions, order] = sort(pOptions);
            
            app.LatLUTData.pOptions = pOptions;
            
            app.LatLUTData.nfyVals = app.LatLUTData.nfyVals(:, :, :, order);
            app.LatLUTData.mzVals = app.LatLUTData.mzVals(:, :, :, order);
            app.LatLUTData.saData = reorder3DCellDim3(app.LatLUTData.saData, order);
            app.LatLUTData.fzData = reorder3DCellDim3(app.LatLUTData.fzData, order);
            app.LatLUTData.nfyData = reorder3DCellDim3(app.LatLUTData.nfyData, order);
            app.LatLUTData.mzData = reorder3DCellDim3(app.LatLUTData.mzData, order);
            app.LatLUTData.nfySamplePoints = app.LatLUTData.nfySamplePoints(:, :, :, order);
            app.LatLUTData.mzSamplePoints = app.LatLUTData.mzSamplePoints(:, :, :, order);
            app.LatLUTData.nfyC = app.LatLUTData.nfyC(:, :, :, order);
            app.LatLUTData.mzC = app.LatLUTData.mzC(:, :, :, order);
            app.LatLUTData.nfyExitFlags = app.LatLUTData.nfyExitFlags(:, :, order);
            app.LatLUTData.mzExitFlags = app.LatLUTData.mzExitFlags(:, :, order);
            
            returnStruct = struct();
        end
    end
end