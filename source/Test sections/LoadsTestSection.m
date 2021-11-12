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
            nTimes = obj.BFinder.getN();
            nTests = length(obj.Children);
            
            saSampleVals = runOpts.SASampleVals;
            nSA = length(saSampleVals);
            loadSampleVals = -runOpts.LoadSampleVals;
            nLoadSample = length(loadSampleVals);
            nfySamplePoints = zeros(nSA, nLoadSample);
            mzSamplePoints = zeros(nSA, nLoadSample);
            meanLoads = zeros(nTimes, 1);
            foundIndex = 0;
            
            fitOrder = runOpts.LoadSensOrder;
            if (nTimes <= fitOrder)
                fitOrder = nTimes - 1;
            end
            if fitOrder < 1
                error(['Matt error: order (' num2str(fitOrder) ') must be >= 1'])
            end
            
            nfyLoadPolyCoeff = zeros(fitOrder + 1, nSA);
            mzLoadPolyCoeff = zeros(fitOrder + 1, nSA);
            nfyVals = zeros(nSA, nLoadSample);
            mzVals = zeros(nSA, nLoadSample);
            saData = cell(nTimes, 1);
            fzData = cell(nTimes, 1);
            nfyData = cell(nTimes, 1);
            mzData = cell(nTimes, 1);
            iaData = cell(nTimes, 1);
            pData = cell(nTimes, 1);
            nfyC = zeros(6, nTimes);
            mzC = zeros(6, nTimes);
            nfyExitFlags = zeros(nTimes, 1);
            mzExitFlags = zeros(nTimes, 1);
            
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
            fzOptions = round(meanLoads);
            saData = saData(order);
            fzData = fzData(order);
            nfyData = nfyData(order);
            mzData = mzData(order);
            iaData = iaData(order);
            pData = pData(order);
            nfyC(:, order) = [childrenResults{foundIndex}.nfyC];
            mzC(:, order) = [childrenResults{foundIndex}.mzC];
            nfyExitFlags = childrenResults{foundIndex}(order).nfyExitFlag;
            mzExitFlags = childrenResults{foundIndex}(order).mzExitFlag;
            nfySamplePoints = vertcat(childrenResults{foundIndex}(order).nfySamplePoints)';
            mzSamplePoints = vertcat(childrenResults{foundIndex}(order).mzSamplePoints)';
            
            for k = 1:nSA
                nfyLoadPolyCoeff(:, k) = polyfit(meanLoads, nfySamplePoints(k, :), fitOrder);
                mzLoadPolyCoeff(:, k) = polyfit(meanLoads, mzSamplePoints(k, :), fitOrder);
                % Generate values from these polynomials
                nfyVals(k, :) = polyval(nfyLoadPolyCoeff(:, k), loadSampleVals);
                mzVals(k, :) = polyval(mzLoadPolyCoeff(:, k), loadSampleVals);
            end
            
            processingResults.saData = saData;
            processingResults.fzData = fzData;
            processingResults.nfyData = nfyData;
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
        end
    end
end