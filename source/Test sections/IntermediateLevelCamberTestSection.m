classdef IntermediateLevelCamberTestSection < TestSection
    
    methods
        function obj = IntermediateLevelCamberTestSection(name, bFinder, children, exceptions)
            if nargin < 2
                bFinder = BoundsFinderN(1, 0);
            end
            if nargin < 3
                children = TestSection.empty;
            end
            if nargin < 4
                exceptions = TestSectionException.empty;
            end
            obj@TestSection(name, bFinder, 'IA', children, exceptions);
        end
        
        function processingResults = processData(obj, ~, ~, childrenResults, runOpts)
            nTimes = obj.BFinder.getN();
            nTests = length(obj.Children);
            nLoads = 0;
            nSASample = length(runOpts.SASampleVals);
            nLoadSample = length(runOpts.LoadSampleVals);
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
            
            saData = cell(nLoads, nTimes);
            fzData = cell(nLoads, nTimes);
            nfyData = cell(nLoads, nTimes);
            mzData = cell(nLoads, nTimes);
            pData = cell(nLoads, nTimes);
            
            nfyC = zeros(6, nLoads, nTimes);
            mzC = zeros(6, nLoads, nTimes);
            nfyExitFlags = zeros(nLoads, nTimes);
            mzExitFlags = zeros(nLoads, nTimes);
            nfySamplePoints = zeros(nSASample, nLoads, nTimes);
            mzSamplePoints = zeros(nSASample, nLoads, nTimes);
            nfyLoadPolyCoeff = 0;
            mzLoadPolyCoeff = 0;
            nfyVals = zeros(nSASample, nLoadSample, nTimes);
            mzVals = zeros(nSASample, nLoadSample, nTimes);
            meanLoads = zeros(nLoads, nTimes);
            fzOptions = 0;
            iaOptions = zeros(nTimes, 1);
            
            for i = 1:nTimes
                for j = 1:nTests
                    test = obj.Children(j);
                    childResults = childrenResults{j}(i);
                    
                    if isa(test, 'LoadsTestSection')
                        saData(:, i) = childResults.saData;
                        fzData(:, i) = childResults.fzData;
                        nfyData(:, i) = childResults.nfyData;
                        mzData(:, i) = childResults.mzData;
                        pData(:, i) = childResults.pData;
                        nfySamplePoints(:, :, i) = childResults.nfySamplePoints;
                        mzSamplePoints(:, :, i) = childResults.mzSamplePoints;
                        nfyC(:, :, i) = childResults.nfyC;
                        mzC(:, :, i) = childResults.mzC;
                        nfyExitFlags(:, i) = childResults.nfyExitFlags;
                        mzExitFlags(:, i) = childResults.mzExitFlags;
                        
                        retNfyLoadPolyCoeff = childResults.nfyLoadPolyCoeff;
                        nLoadCoeff = size(retNfyLoadPolyCoeff, 1);
                        if i == 1
                            nfyLoadPolyCoeff = zeros(nLoadCoeff, nSASample, nTimes);
                            mzLoadPolyCoeff = zeros(nLoadCoeff, nSASample, nTimes);
                        end
                        nfyLoadPolyCoeff(:, :, i) = retNfyLoadPolyCoeff; %#ok<AGROW>
                        mzLoadPolyCoeff(:, :, i) = childResults.mzLoadPolyCoeff; %#ok<AGROW>
                        
                        nfyVals(:, :, i) = childResults.nfyVals;
                        mzVals(:, :, i) = childResults.mzVals;
                        meanLoads(:, i) = childResults.meanLoads;
                        fzOptions = childResults.fzOptions;
                        
                        iaOptions(i) = mean(vertcat(childResults.iaData{:}));
                    end
                end
            end
            
            iaOptions = round(iaOptions);
            [iaOptions, order] = sort(iaOptions);
            processingResults.iaOptions = iaOptions;

            saData = reorder2DCellDim2(saData, order);
            fzData = reorder2DCellDim2(fzData, order);
            nfyData = reorder2DCellDim2(nfyData, order);
            mzData = reorder2DCellDim2(mzData, order);
            pData = pData(:, order);
            nfySamplePoints = nfySamplePoints(:, :, order);
            mzSamplePoints = mzSamplePoints(:, :, order);
            nfyC = nfyC(:, :, order);
            mzC = mzC(:, :, order);
            nfyExitFlags = nfyExitFlags(:, order);
            mzExitFlags = mzExitFlags(:, order);
            nfyVals = nfyVals(:, :, order);
            mzVals = mzVals(:, :, order);
            
            processingResults.saData = saData;
            processingResults.fzData = fzData;
            processingResults.nfyData = nfyData;
            processingResults.mzData = mzData;
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
            processingResults.iaOptions = iaOptions;
        end
    end
end