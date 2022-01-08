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
            
            % If you don't make all the arguments single cells, it tries to make it a struct array
            app.LatLUTData = struct( ...
                'saData', {cell(nLoads, nCamber, nTimes)}, ...
                'fzData', {cell(nLoads, nCamber, nTimes)}, ...
                'nfyData', {cell(nLoads, nCamber, nTimes)}, ...
                'mzData', {cell(nLoads, nCamber, nTimes)}, ...
                'nfyC', {zeros(6, nLoads, nCamber, nTimes)}, ...
                'mzC', {zeros(6, nLoads, nCamber, nTimes)}, ...
                'nfyExitFlags', {zeros(nLoads, nCamber, nTimes)}, ...
                'mzExitFlags', {zeros(nLoads, nCamber, nTimes)}, ...
                'nfyLoadPolyCoeff', {0}, ...
                'mzLoadPolyCoeff', {0}, ...
                'nfyVals', {zeros(nSASample, nLoadSample, nCamber, nTimes)}, ...
                'mzVals', {zeros(nSASample, nLoadSample, nCamber, nTimes)}, ...
                'meanLoads', {zeros(nLoads, nCamber, nTimes)}, ...
                'fzOptions', {zeros(nLoads, 1)}, ...
                'iaOptions', {zeros(nCamber, 1)}, ...
                'pOptions', {zeros(nTimes, 1)}, ...
                'alpha_adj', {cell(nCamber, nTimes)}, ...
                'FY_adj', {cell(nCamber, nTimes)}, ...
                'MZ_adj', {cell(nCamber, nTimes)});
            
            for i = 1:nTimes
                for j = 1:nTests
                    test = obj.Children(j);
                    childResults = childrenResults{j}(i);
                
                    if isa(test, 'IntermediateLevelCamberTestSection')
                        %size(childResults.saData)
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
                        app.LatLUTData.nfyVals(:, :, :, i) = childResults.nfyVals;
                        app.LatLUTData.mzVals(:, :, :, i) = childResults.mzVals;
                        app.LatLUTData.meanLoads(:, :, i) = childResults.meanLoads;
                        app.LatLUTData.fzOptions = childResults.fzOptions;
                        app.LatLUTData.iaOptions = childResults.iaOptions;
                        app.LatLUTData.alpha_adj(:, i) = childResults.alpha_adj;
                        app.LatLUTData.FY_adj(:, i) = childResults.FY_adj;
                        app.LatLUTData.MZ_adj(:, i) = childResults.MZ_adj;
                        
                        pOptions(i) = mean(vertcat(childResults.pData{:}));
                        
                        retNfyLoadPolyCoeff = childResults.nfyLoadPolyCoeff;
                        nLoadCoeff = size(retNfyLoadPolyCoeff, 1);
                        if i == 1
                            app.LatLUTData.nfyLoadPolyCoeff = zeros(nLoadCoeff, nSASample, nCamber, nTimes);
                            app.LatLUTData.mzLoadPolyCoeff = zeros(nLoadCoeff, nSASample, nCamber, nTimes);
                        end
                        app.LatLUTData.nfyLoadPolyCoeff(:, :, :, i) = retNfyLoadPolyCoeff;
                        app.LatLUTData.mzLoadPolyCoeff(:, :, :, i) = childResults.mzLoadPolyCoeff;
                        
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
            app.LatLUTData.saData = app.LatLUTData.saData(:, :, order);
            app.LatLUTData.fzData = app.LatLUTData.fzData(:, :, order);
            app.LatLUTData.nfyData = app.LatLUTData.nfyData(:, :, order);
            app.LatLUTData.mzData = app.LatLUTData.mzData(:, :, order);
            app.LatLUTData.nfySamplePoints = app.LatLUTData.nfySamplePoints(:, :, :, order);
            app.LatLUTData.mzSamplePoints = app.LatLUTData.mzSamplePoints(:, :, :, order);
            app.LatLUTData.nfyC = app.LatLUTData.nfyC(:, :, :, order);
            app.LatLUTData.mzC = app.LatLUTData.mzC(:, :, :, order);
            app.LatLUTData.nfyExitFlags = app.LatLUTData.nfyExitFlags(:, :, order);
            app.LatLUTData.mzExitFlags = app.LatLUTData.mzExitFlags(:, :, order);
            app.LatLUTData.meanLoads = app.LatLUTData.meanLoads(:, :, order);

            app.LatLUTData.alpha_adj = reorder2DCellDim2(app.LatLUTData.alpha_adj, order);
            app.LatLUTData.FY_adj = reorder2DCellDim2(app.LatLUTData.FY_adj, order);
            app.LatLUTData.MZ_adj = reorder2DCellDim2(app.LatLUTData.MZ_adj, order);
            
            processingResults = struct();
        end
    end
end