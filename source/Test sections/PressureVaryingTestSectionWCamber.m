classdef PressureVaryingTestSectionWCamber < TestSection
    
    methods
        function obj = PressureVaryingTestSectionWCamber(name, bFinder, children, exceptions)
            if nargin < 2
                bFinder = BoundsFinderN(1, 0);
            end
            if nargin < 3
                children = TestSection.empty;
            end
            if nargin < 4
                exceptions = TestSectionException.empty;
            end
            obj@TestSection(name, bFinder, "P", children, exceptions);
        end
        
        function processingResults = processData(obj, app, ~, childrenResults, runOpts)
            nTimes = obj.BFinder.getN();
            nTests = length(obj.Children);
            nCamber = 0;
            nLoads = 0;
            nSASample = length(runOpts.SASampleVals);
            nLoadSample = length(runOpts.LoadSampleVals);
            pOptions = zeros(nTimes, 1);
            foundCamber = false;
            for j = 1:nTests
                test = obj.Children(j);
                if isa(test, 'IntermediateLevelCamberTestSection')
                    foundCamber = true;
                    nCamber = test.BFinder.getN();
                    for k = 1:length(test.Children)
                        nestedTest = test.Children(k);
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
                    test = obj.Children(j);
                    childResults = childrenResults{j}(i);
                
                    if isa(test, 'IntermediateLevelCamberTestSection')
                        app.LatLUTData.saData(:, :, i) = childResults.saData;
                        app.LatLUTData.fzData(:, :, i) = childResults.fzData;
                        app.LatLUTData.nfyData(:, :, i) = childResults.nfyData;
                        app.LatLUTData.mzData(:, :, i) = childResults.mzData;
                        app.LatLUTData.nfySamplePoints(:, :, :, i) = childResults.nfySamplePoints;
                        app.LatLUTData.mzSamplePoints(:, :, :, i) = childResults.mzSamplePoints;
                        app.LatLUTData.nfyC(:, :, :, i) = childResults.nfyC;
                        app.LatLUTData.mzC(:, :, :, i) = childResults.mzC;
                        app.LatLUTData.nfyExitFlags(:, :, i) = childResults.nfyExitFlags;
                        app.LatLUTData.mzExitFlags(:, :, i) = childResults.mzExitFlags;
                        
                        retNfyLoadPolyCoeff = childResults.nfyLoadPolyCoeff;
                        nLoadCoeff = size(retNfyLoadPolyCoeff, 1);
                        if i == 1
                            app.LatLUTData.nfyLoadPolyCoeff = zeros(nLoadCoeff, nSASample, nCamber, nTimes);
                            app.LatLUTData.mzLoadPolyCoeff = zeros(nLoadCoeff, nSASample, nCamber, nTimes);
                        end
                        app.LatLUTData.nfyLoadPolyCoeff(:, :, :, i) = retNfyLoadPolyCoeff;
                        app.LatLUTData.mzLoadPolyCoeff(:, :, :, i) = childResults.mzLoadPolyCoeff;
                        
                        app.LatLUTData.nfyVals(:, :, :, i) = childResults.nfyVals;
                        app.LatLUTData.mzVals(:, :, :, i) = childResults.mzVals;
                        app.LatLUTData.meanLoads(:, :, i) = childResults.meanLoads;
                        app.LatLUTData.fzOptions = childResults.fzOptions;
                        app.LatLUTData.iaOptions = childResults.iaOptions;
                        
                        pOptions(i) = mean(vertcat(childResults.pData{:}));
                        
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
            
            processingResults = struct();
        end
    end
end