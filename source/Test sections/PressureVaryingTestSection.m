classdef PressureVaryingTestSection < TestSection
    
    methods
        function obj = PressureVaryingTestSection(name, bFinder, children, exceptions)
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
            nLoads = 0;
            nSASample = length(runOpts.SASampleVals);
            nLoadSample = length(runOpts.LoadSampleVals);
            pOptions = zeros(nTimes, 1);
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
            app.LatPressureLUTData = struct( ...
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
                        app.LatPressureLUTData.saData(:, i) = childResults.saData;
                        app.LatPressureLUTData.fzData(:, i) = childResults.fzData;
                        app.LatPressureLUTData.nfyData(:, i) = childResults.nfyData;
                        app.LatPressureLUTData.mzData(:, i) = childResults.mzData;
                        app.LatPressureLUTData.nfySamplePoints(:, :, i) = childResults.nfySamplePoints;
                        app.LatPressureLUTData.mzSamplePoints(:, :, i) = childResults.mzSamplePoints;
                        app.LatPressureLUTData.nfyC(:, :, i) = childResults.nfyC;
                        app.LatPressureLUTData.mzC(:, :, i) = childResults.mzC;
                        app.LatPressureLUTData.nfyExitFlags(:, i) = childResults.nfyExitFlags;
                        app.LatPressureLUTData.mzExitFlags(:, i) = childResults.mzExitFlags;
                        app.LatPressureLUTData.nfyVals(:, :, i) = childResults.nfyVals;
                        app.LatPressureLUTData.mzVals(:, :, i) = childResults.mzVals;
                        app.LatPressureLUTData.meanLoads(:, i) = childResults.meanLoads;
                        app.LatPressureLUTData.fzOptions = childResults.fzOptions;
                        app.LatPressureLUTData.alpha_adj{i} = childResults.alpha_adj;
                        app.LatPressureLUTData.FY_adj{i} = childResults.FY_adj;
                        app.LatPressureLUTData.MZ_adj{i} = childResults.MZ_adj;
                        
                        pOptions(i) = mean(vertcat(childResults.pData{:}));
                        
                        retNfyLoadPolyCoeff = childResults.nfyLoadPolyCoeff;
                        nLoadCoeff = size(retNfyLoadPolyCoeff, 1);
                        if i == 1
                            app.LatPressureLUTData.nfyLoadPolyCoeff = zeros(nLoadCoeff, nSASample, nTimes);
                            app.LatPressureLUTData.mzLoadPolyCoeff = zeros(nLoadCoeff, nSASample, nTimes);
                        end
                        app.LatPressureLUTData.nfyLoadPolyCoeff(:, :, i) = retNfyLoadPolyCoeff;
                        app.LatPressureLUTData.mzLoadPolyCoeff(:, :, i) = childResults.mzLoadPolyCoeff;
                        
                    end
                end
            end
            
            % Display pressure in psi not kPa
            pOptions = pOptions * 0.145038;
            pOptions = round(pOptions);
            [pOptions, order] = sort(pOptions);
            
            app.LatPressureLUTData.pOptions = pOptions;
            
            % Reorder arrays
            app.LatPressureLUTData.saData = reorder2DCellDim2(app.LatPressureLUTData.saData, order);
            app.LatPressureLUTData.fzData = reorder2DCellDim2(app.LatPressureLUTData.fzData, order);
            app.LatPressureLUTData.nfyData = reorder2DCellDim2(app.LatPressureLUTData.nfyData, order);
            app.LatPressureLUTData.mzData = reorder2DCellDim2(app.LatPressureLUTData.mzData, order);
            app.LatPressureLUTData.nfyC = app.LatPressureLUTData.nfyC(:, :, order);
            app.LatPressureLUTData.mzC = app.LatPressureLUTData.mzC(:, :, order);
            app.LatPressureLUTData.nfyExitFlags = app.LatPressureLUTData.nfyExitFlags(:, order);
            app.LatPressureLUTData.mzExitFlags = app.LatPressureLUTData.mzExitFlags(:, order);
            app.LatPressureLUTData.nfySamplePoints = app.LatPressureLUTData.nfySamplePoints(:, :, order);
            app.LatPressureLUTData.mzSamplePoints = app.LatPressureLUTData.mzSamplePoints(:, :, order);
            app.LatPressureLUTData.nfyVals = app.LatPressureLUTData.nfyVals(:, :, order);
            app.LatPressureLUTData.mzVals = app.LatPressureLUTData.mzVals(:, :, order);
            app.LatPressureLUTData.alpha_adj = app.LatPressureLUTData.alpha_adj(order);
            app.LatPressureLUTData.FY_adj = app.LatPressureLUTData.FY_adj(order);
            app.LatPressureLUTData.MZ_adj = app.LatPressureLUTData.MZ_adj(order);
            
            % Create empty return struct since it won't be used (top level in app class discards it)
            processingResults = struct();
        end
    end
end