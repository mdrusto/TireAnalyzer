classdef CamberVaryingTestSection < TestSection
    
    methods
        function obj = CamberVaryingTestSection(name, bFinder, children, exceptions)
            if nargin < 2
                bFinder = BoundsFinderN(1, 0);
            end
            if nargin < 3
                children = TestSection.empty;
            end
            if nargin < 4
                exceptions = TestSectionException.empty;
            end
            obj@TestSection(name, bFinder, "IA", children, exceptions);
        end
        
        function processingResults = processData(obj, app, ~, childrenResults, runOpts)
            nTimes = obj.BFinder.getN();
            nTests = length(obj.Children);
            nLoads = 0;
            nSASample = length(runOpts.SASampleVals);
            nLoadSample = length(runOpts.LoadSampleVals);
            iaOptions = zeros(nTimes, 1);
            foundLoads = false;
            for j = 1:nTests
                test = obj.Children(j);
                if isa(test, 'LoadsTestSection')
                    foundLoads = true;
                    nLoads = test.BFinder.getN();
                    break;
                end
            end
            
            if ~foundLoads
                error('Matt error: no loads found in intermediate test section');
            end
            
            % Create each global array in the LatCamberLUTData struct in the app class
            app.LatCamberLUTData = struct( ...
                'saData', {cell(nLoads, nTimes)}, ...
                'fzData', {cell(nLoads, nTimes)}, ...
                'nfyData', {cell(nLoads, nTimes)}, ...
                'mzData', {cell(nLoads, nTimes)}, ...
                'nfyC', {zeros(6, nLoads, nTimes)}, ...
                'mzC', {zeros(6, nLoads, nTimes)}, ...
                'nfyExitFlags', {zeros(nLoads, nTimes)}, ...
                'mzExitFlags', {zeros(nLoads, nTimes)}, ...
                'nfyLoadPolyCoeff', {0}, ...
                'mzLoadPolyCoeff', {0}, ...
                'nfyVals', {zeros(nSASample, nLoadSample, nTimes)}, ...
                'mzVals', {zeros(nSASample, nLoadSample, nTimes)}, ...
                'meanLoads', {zeros(nLoads, nTimes)}, ...
                'fzOptions', {zeros(nLoads, 1)}, ...
                'iaOptions', {zeros(nTimes, 1)}, ...
                'alpha_adj', {cell(nTimes, 1)}, ...
                'FY_adj', {cell(nTimes, 1)}, ...
                'MZ_adj', {cell(nTimes, 1)}); % If you don't make all the arguments single cells, it tries to make it a struct array
            
            for i = 1:nTimes
                for j = 1:nTests
                    test = obj.Children(j);
                    childResults = childrenResults{j}(i);
                    
                    if isa(test, 'LoadsTestSection')
                        
                        % Insert each row into global array
                        app.LatCamberLUTData.saData(:, i) = childResults.saData;
                        app.LatCamberLUTData.fzData(:, i) = childResults.fzData;
                        app.LatCamberLUTData.nfyData(:, i) = childResults.nfyData;
                        app.LatCamberLUTData.mzData(:, i) = childResults.mzData;
                        app.LatCamberLUTData.nfySamplePoints(:, :, i) = childResults.nfySamplePoints;
                        app.LatCamberLUTData.mzSamplePoints(:, :, i) = childResults.mzSamplePoints;
                        app.LatCamberLUTData.nfyC(:, :, i) = childResults.nfyC;
                        app.LatCamberLUTData.mzC(:, :, i) = childResults.mzC;
                        app.LatCamberLUTData.nfyExitFlags(:, i) = childResults.nfyExitFlags;
                        app.LatCamberLUTData.mzExitFlags(:, i) = childResults.mzExitFlags;
                        app.LatCamberLUTData.nfyVals(:, :, i) = childResults.nfyVals;
                        app.LatCamberLUTData.mzVals(:, :, i) = childResults.mzVals;
                        app.LatCamberLUTData.meanLoads(:, i) = childResults.meanLoads;
                        app.LatCamberLUTData.fzOptions = childResults.fzOptions;
                        app.LatCamberLUTData.alpha_adj{i} = childResults.alpha_adj;
                        app.LatCamberLUTData.FY_adj{i} = childResults.FY_adj;
                        app.LatCamberLUTData.MZ_adj{i} = childResults.MZ_adj;
                        
                        iaOptions(i) = mean(vertcat(childResults.iaData{:}));
                        
                        retNfyLoadPolyCoeff = childResults.nfyLoadPolyCoeff;
                        nLoadCoeff = size(retNfyLoadPolyCoeff, 1);
                        if i == 1
                            app.LatCamberLUTData.nfyLoadPolyCoeff = zeros(nLoadCoeff, nSASample, nTimes);
                            app.LatCamberLUTData.mzLoadPolyCoeff = zeros(nLoadCoeff, nSASample, nTimes);
                        end
                        app.LatCamberLUTData.nfyLoadPolyCoeff(:, :, i) = retNfyLoadPolyCoeff;
                        app.LatCamberLUTData.mzLoadPolyCoeff(:, :, i) = childResults.mzLoadPolyCoeff;
                    end
                end
            end
            
            % Round camber values to whole numbers
            iaOptions = round(iaOptions);
            % Sort camber values and retrieve order for sorting the results
            [iaOptions, order] = sort(iaOptions);
            
            app.LatCamberLUTData.iaOptions = iaOptions;
            
            % Reorder each array based on order of camber values (reorder2DCellDim2 is a custom function)
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
            app.LatCamberLUTData.alpha_adj = app.LatCamberLUTData.alpha_adj(order);
            app.LatCamberLUTData.FY_adj = app.LatCamberLUTData.FY_adj(order);
            app.LatCamberLUTData.MZ_adj = app.LatCamberLUTData.MZ_adj(order);
            
            processingResults = struct();
        end
    end
end