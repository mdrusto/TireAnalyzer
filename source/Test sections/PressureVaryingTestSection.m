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
            nPressures = obj.BFinder.getN();
            nTests = length(obj.Children);
            nLoads = 0;
            nSASample = length(runOpts.SASampleVals);
            nLoadSample = length(runOpts.LoadSampleVals);
            pOptions = zeros(nPressures, 1);
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
                error('Matt error: no loads found in pressure test section');
            end

            % Create all array variables
            saData = cell(nLoads, nPressures);
            fzData = cell(nLoads, nPressures);
            nfyData = cell(nLoads, nPressures);
            mzData = cell(nLoads, nPressures);
            nfyC = zeros(6, nLoads, nPressures);
            mzC = zeros(6, nLoads, nPressures);
            nfyExitFlags = zeros(nLoads, nPressures);
            mzExitFlags = zeros(nLoads, nPressures);
            nfyLoadPolyCoeff = 0;
            mzLoadPolyCoeff = 0;
            nfyVals = zeros(nSASample, nLoadSample, nPressures);
            mzVals = zeros(nSASample, nLoadSample, nPressures);
            meanLoads = zeros(nLoads, nPressures);
            fzOptions = zeros(nLoads, 1);
            alpha_adj = cell(nPressures, 1);
            FY_adj = cell(nPressures, 1);
            MZ_adj = cell(nPressures, 1);
            
            for i = 1:nPressures
                for j = 1:nTests
                    test = obj.Children(j);
                    childResults = childrenResults{j}(i);
                    
                    if isa(test, 'LoadsTestSection')
                        
                        % Insert each row into global array
                        saData(:, i) = childResults.saData;
                        fzData(:, i) = childResults.fzData;
                        nfyData(:, i) = childResults.nfyData;
                        mzData(:, i) = childResults.mzData;
                        nfySamplePoints(:, :, i) = childResults.nfySamplePoints;
                        mzSamplePoints(:, :, i) = childResults.mzSamplePoints;
                        nfyC(:, :, i) = childResults.nfyC;
                        mzC(:, :, i) = childResults.mzC;
                        nfyExitFlags(:, i) = childResults.nfyExitFlags;
                        mzExitFlags(:, i) = childResults.mzExitFlags;
                        nfyVals(:, :, i) = childResults.nfyVals;
                        mzVals(:, :, i) = childResults.mzVals;
                        meanLoads(:, i) = childResults.meanLoads;
                        fzOptions = childResults.fzOptions;
                        alpha_adj{i} = childResults.alpha_adj;
                        FY_adj{i} = childResults.FY_adj;
                        MZ_adj{i} = childResults.MZ_adj;
                        
                        pOptions(i) = mean(vertcat(childResults.pData{:}));
                        
                        retNfyLoadPolyCoeff = childResults.nfyLoadPolyCoeff;
                        nLoadCoeff = size(retNfyLoadPolyCoeff, 1);
                        if i == 1
                            nfyLoadPolyCoeff = zeros(nLoadCoeff, nSASample, nPressures);
                            mzLoadPolyCoeff = zeros(nLoadCoeff, nSASample, nPressures);
                        end
                        nfyLoadPolyCoeff(:, :, i) = retNfyLoadPolyCoeff;
                        mzLoadPolyCoeff(:, :, i) = childResults.mzLoadPolyCoeff;
                        
                    end
                end
            end
            
            pOptions

            % Display pressure in psi not kPa
            pOptions = pOptions * 0.145038;
            pOptions = round(pOptions);
            [pOptions, order] = sort(pOptions);
            
            %pOptions = pOptions;
            
            % Reorder arrays
            saData = saData(:, order);
            fzData = fzData(:, order);
            nfyData = nfyData(:, order);
            mzData = mzData(:, order);
            nfyC = nfyC(:, :, order);
            mzC = mzC(:, :, order);
            nfyExitFlags = nfyExitFlags(:, order);
            mzExitFlags = mzExitFlags(:, order);
            nfySamplePoints = nfySamplePoints(:, :, order);
            mzSamplePoints = mzSamplePoints(:, :, order);
            nfyVals = nfyVals(:, :, order);
            mzVals = mzVals(:, :, order);
            alpha_adj = alpha_adj(order);
            FY_adj = FY_adj(order);
            MZ_adj = MZ_adj(order);
            
            % Save all relevant variables to return struct
            app.LatPressureLUTData.saData = saData;
            app.LatPressureLUTData.fzData = fzData;
            app.LatPressureLUTData.nfyData = nfyData;
            app.LatPressureLUTData.mzData = mzData;
            app.LatPressureLUTData.nfyC = nfyC;
            app.LatPressureLUTData.mzC = mzC;
            app.LatPressureLUTData.nfyExitFlags = nfyExitFlags;
            app.LatPressureLUTData.mzExitFlags = mzExitFlags;
            app.LatPressureLUTData.nfySamplePoints = nfySamplePoints;
            app.LatPressureLUTData.mzSamplePoints = mzSamplePoints;
            app.LatPressureLUTData.nfyLoadPolyCoeff = nfyLoadPolyCoeff;
            app.LatPressureLUTData.mzLoadPolyCoeff = mzLoadPolyCoeff;
            app.LatPressureLUTData.nfyVals = nfyVals;
            app.LatPressureLUTData.mzVals = mzVals;
            app.LatPressureLUTData.meanLoads = meanLoads;
            app.LatPressureLUTData.fzOptions = fzOptions;
            app.LatPressureLUTData.pOptions = pOptions;
            app.LatPressureLUTData.alpha_adj = alpha_adj;
            app.LatPressureLUTData.FY_adj = FY_adj;
            app.LatPressureLUTData.MZ_adj = MZ_adj;
            
            % Create empty return struct since it won't be used (top level in app class discards it)
            processingResults = struct();
        end
    end
end