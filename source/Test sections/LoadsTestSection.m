classdef LoadsTestSection < TestSection
    
    methods
        function obj = LoadsTestSection(name, bFinder, children, exceptions)
            if nargin < 2
                bFinder = BoundsFinderN(1, 0);
            end
            if nargin < 3
                children = TestSection.empty;
            end
            if nargin < 4
                exceptions = TestSectionException.empty;
            end
            obj@TestSection(name, bFinder, "FZ", children, exceptions);
        end
        
        function processingResults = processData(obj, ~, ~, childrenResults, runOpts)
            % Get size of this section
            nTimes = obj.BFinder.getN();
            nTests = length(obj.Children);
            
            % Create empty arrays to hold values of each quantity
            saSampleVals = runOpts.SASampleVals;
            nSASample = length(saSampleVals);
            loadSampleVals = -runOpts.LoadSampleVals;
            nLoadSample = length(loadSampleVals);
            nfySamplePoints = zeros(nSASample, nLoadSample);
            mzSamplePoints = zeros(nSASample, nLoadSample);
            meanLoads = zeros(nTimes, 1);
            foundIndex = 0;
            
            % Choose polynomial fit order
            fitOrder = runOpts.LoadSensOrder;
            if (nTimes <= fitOrder)
                fitOrder = nTimes - 1;
            end
            if fitOrder < 1
                error(['Matt error: order (' num2str(fitOrder) ') must be >= 1'])
            end
            
            nfyLoadPolyCoeff = zeros(fitOrder + 1, nSASample);
            mzLoadPolyCoeff = zeros(fitOrder + 1, nSASample);
            nfyVals = zeros(nSASample, nLoadSample);
            mzVals = zeros(nSASample, nLoadSample);
            saData = cell(nTimes, 1);
            fzData = cell(nTimes, 1);
            nfyData = cell(nTimes, 1);
            fyData = cell(nTimes, 1);
            mzData = cell(nTimes, 1);
            iaData = cell(nTimes, 1);
            pData = cell(nTimes, 1);
            nfyC = zeros(6, nTimes);
            mzC = zeros(6, nTimes);
            nfyExitFlags = zeros(nTimes, 1);
            mzExitFlags = zeros(nTimes, 1);
            
            % We have to save these now, because they are needed in the camber file
            cornerStiff_FY_adj = zeros(nTimes, 1);
            cornerStiff_MZ_adj = zeros(nTimes, 1);
            fz_bar = zeros(nTimes, 1);
            maxNFY = zeros(nTimes, 1);
            % These will be arrays, but we only set them once we know the size, which we need to know the # of data points for
            alpha_adj = 0;
            FY_adj = 0;
            MZ_adj = 0;

            camberShiftFY = zeros(nTimes, 1);
            camberShiftMZ = zeros(nTimes, 1);
            
            for i = 1:nTimes
                foundSweep = false;
                for j = 1:nTests
                    
                    test = obj.Children(j);
                    
                    childResults = childrenResults{j}(i);
                    
                    if isa(test, 'SASweepTestSection') || isa(test, 'SASweepTestSectionSpec')
                        foundSweep = true;
                        foundIndex = j;
                        nfySamplePoints(:, i) = childResults.nfySamplePoints;
                        mzSamplePoints(:, i) = childResults.mzSamplePoints;
                        saData{i} = childResults.saData;
                        fzData{i} = childResults.fzData;
                        fyData{i} = childResults.nfyData .* childResults.fzData;
                        nfyData{i} = childResults.nfyData;
                        mzData{i} = childResults.mzData;
                        iaData{i} = childResults.iaData;
                        pData{i} = childResults.pData;
                        nfyC(:, i) = childResults.nfyC;
                        mzC(:, i) = childResults.mzC;
                        nfyExitFlags(i) = childResults.nfyExitFlag;
                        mzExitFlags(i) = childResults.mzExitFlag;
                                
                        meanLoads(i) = mean(childResults.fzData);
                        assert(isscalar(mean(childResults.fzData)), 'size of mean is not singular')

                    end
                end
                % Throw an error if no SASweepTestSection was found inside this section
                if ~foundSweep
                    error('Matt error: no SA sweeps found inside loads section');
                end
            end
            
            meanLoads = -meanLoads;
            [meanLoads, order] = sort(meanLoads);
            minDiff = min(diff(sort(meanLoads)));
            if minDiff < 50
                disp('----- Error info: ------')
                disp('Mean loads:')
                disp(meanLoads)
                error('Matt error: not enough error between mean loads. See above info')
            end
            
            % For the load options, round to nearest hundred
            fzOptions = round(meanLoads, -2);
            
            % Reorder each array according to the test order of loads
            saData = saData(order);
            fzData = fzData(order);
            nfyData = nfyData(order);
            fyData = fyData(order);
            mzData = mzData(order);
            iaData = iaData(order);
            pData = pData(order);
            nfyC(:, order) = [childrenResults{foundIndex}.nfyC];
            mzC(:, order) = [childrenResults{foundIndex}.mzC];
            nfyExitFlags = childrenResults{foundIndex}(order).nfyExitFlag;
            mzExitFlags = childrenResults{foundIndex}(order).mzExitFlag;
            nfySamplePoints = vertcat(childrenResults{foundIndex}(order).nfySamplePoints)'; % I dont even know what these lines are doing
            mzSamplePoints = vertcat(childrenResults{foundIndex}(order).mzSamplePoints)';
            
            % Do load polynomial fits
            for k = 1:nSASample
                nfyLoadPolyCoeff(:, k) = polyfit(meanLoads, nfySamplePoints(k, :), fitOrder);
                mzLoadPolyCoeff(:, k) = polyfit(meanLoads, mzSamplePoints(k, :), fitOrder);
                % Generate values from these polynomials
                nfyVals(k, :) = polyval(nfyLoadPolyCoeff(:, k), loadSampleVals);
                mzVals(k, :) = polyval(mzLoadPolyCoeff(:, k), loadSampleVals);
            end

            % Similarity method
            % Do this after everything has been sorted according to load order instead of inside the main loop

            for i = 1:nTimes

                fz_bar(i) = mean(fzData{i});
                maxNFY(i) = max(abs(nfyData{i}));

                %Cornering Stiffness of FY_adj
                linearRegionIndices = abs(saData{i}) < 1;
                linearRegionSA = saData{i}(linearRegionIndices);
                linearRegionFY = fyData{i}(linearRegionIndices);
                linearRegionMZ = mzData{i}(linearRegionIndices);
                
                coeff_FY_adj = polyfit(linearRegionSA, linearRegionFY, 1);
                cornerStiff_FY_adj(i) = coeff_FY_adj(1); % C_Fa(Fz)
                
                coeff_MZ_adj = polyfit(linearRegionSA, linearRegionMZ, 1);
                cornerStiff_MZ_adj(i) = coeff_MZ_adj(1); % C_Ma(Fz)

                camberShiftFY(i) = coeff_FY_adj(2); %shift for side force
                camberShiftMZ(i) = coeff_MZ_adj(2); %shift for aligning torque

            end
            
            processingResults.saData = saData;
            processingResults.fzData = fzData;
            processingResults.nfyData = nfyData;
            processingResults.fyData = fyData;
            processingResults.mzData = mzData;
            processingResults.iaData = iaData;
            processingResults.pData = pData;
            processingResults.nfyC = nfyC;
            processingResults.mzC = mzC;
            processingResults.nfyExitFlags = nfyExitFlags;
            processingResults.mzExitFlags = mzExitFlags;
            processingResults.nfySamplePoints = nfySamplePoints;
            processingResults.mzSamplePoints = mzSamplePoints;
            processingResults.nfyLoadPolyCoeff = nfyLoadPolyCoeff;
            processingResults.mzLoadPolyCoeff = mzLoadPolyCoeff;
            processingResults.nfyVals = nfyVals;
            processingResults.mzVals = mzVals;
            processingResults.meanLoads = meanLoads;
            processingResults.fzOptions = fzOptions;
            
            processingResults.alpha_adj = alpha_adj;
            processingResults.FY_adj = FY_adj;
            processingResults.MZ_adj = MZ_adj;
            processingResults.cornerStiff_FY_adj = cornerStiff_FY_adj;
            processingResults.cornerStiff_MZ_adj = cornerStiff_MZ_adj;
            processingResults.fz_bar = fz_bar;
            processingResults.maxNFY = maxNFY;
            processingResults.camberShiftFY = camberShiftFY;
            processingResults.camberShiftMZ = camberShiftMZ;
        end
    end
end