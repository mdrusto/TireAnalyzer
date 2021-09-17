classdef LoadsTestSection < TestSectionRepeatedWSpec
    
    methods
        function obj = LoadsTestSection(name, bFinder, nestedTests)
            obj@TestSectionRepeatedWSpec(name, 'FZ', bFinder, nestedTests);
        end
        
        function returnStruct = doStuffWithData(obj, app, data, ~, ~, parentIndices, runOpts)
            nTimes = obj.BFinder.getN();
            nTests = length(obj.NestedTests);
            
            saSampleVals = runOpts.SASampleVals;
            nSA = length(saSampleVals);
            loadSampleVals = -runOpts.LoadSampleVals;
            nLoadSample = length(loadSampleVals);
            nfySamplePoints = zeros(nSA, nLoadSample);
            mzSamplePoints = zeros(nSA, nLoadSample);
            meanLoads = zeros(nTimes, 1);
            
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
            nfyC = zeros(6, nTimes);
            mzC = zeros(6, nTimes);
            nfyExitFlags = zeros(nTimes, 1);
            mzExitFlags = zeros(nTimes, 1);
            
            for i = 1:nTimes
                foundSweep = false;
                for j = 1:nTests
                    newIndices = [parentIndices, i, j];
                    test = obj.NestedTests(j);
                    nestedLB = getNestedLB(obj, newIndices);
                    nestedUB = getNestedUB(obj, newIndices);
                    if any(size(nestedLB) > 1) || any(size(nestedUB) > 1)
                        error('Matt error: nested bound is array, should return scalar')
                    end
                    
                    retStruct = test.doStuffWithData( ...
                        app, ...
                        data, ...
                        nestedLB, ...
                        nestedUB, ...
                        newIndices, ...
                        runOpts);
                    if isa(test, 'SASweepTestSection') || isa(test, 'SASweepTestSectionSpec')
                        foundSweep = true;
                        nfySamplePoints(:, i) = retStruct.nfySamplePoints;
                        mzSamplePoints(:, i) = retStruct.mzSamplePoints;
                        saData{i} = retStruct.saData;
                        fzData{i} = retStruct.fzData;
                        nfyData{i} = retStruct.nfyData;
                        mzData{i} = retStruct.mzData;
                        nfyC(:, i) = retStruct.nfyC;
                        mzC(:, i) = retStruct.mzC;
                        nfyExitFlags(i) = retStruct.nfyExitFlag;
                        mzExitFlags(i) = retStruct.mzExitFlag;
                        
                        meanLoads(i) = mean(retStruct.fzData);
                    end
                end
                if ~foundSweep
                    error('Matt error: no SA sweeps found inside loads section');
                end
            end
            
            meanLoads = -meanLoads;
            [meanLoads, order] = sort(meanLoads);
            fzOptions = round(meanLoads);
            saData = saData(order);
            fzData = saData(order);
            nfyData = nfyData(order);
            mzData = mzData(order);
            nfyC(:, :) = nfyC(:, order);
            mzC(:, :) = mzC(:, order);
            nfyExitFlags = nfyExitFlags(order);
            mzExitFlags = mzExitFlags(order);
            nfySamplePoints = nfySamplePoints(:, order);
            mzSamplePoints = mzSamplePoints(:, order);
            
            for k = 1:nSA
                nfyLoadPolyCoeff(:, k) = polyfit(meanLoads, nfySamplePoints(k, :)', fitOrder);
                mzLoadPolyCoeff(:, k) = polyfit(meanLoads, mzSamplePoints(k, :)', fitOrder);
                % Generate values from these polynomials
                nfyVals(k, :) = polyval(nfyLoadPolyCoeff(:, k), loadSampleVals);
                mzVals(k, :) = polyval(mzLoadPolyCoeff(:, k), loadSampleVals);
            end
            
            returnStruct.saData = saData;
            returnStruct.fzData = fzData;
            returnStruct.nfyData = nfyData;
            returnStruct.mzData = mzData;
            returnStruct.nfyC = nfyC;
            returnStruct.mzC = mzC;
            returnStruct.nfyExitFlags = nfyExitFlags;
            returnStruct.mzExitFlags = mzExitFlags;
            returnStruct.nfySamplePoints = nfySamplePoints;
            returnStruct.mzSamplePoints = mzSamplePoints;
            returnStruct.nfyLoadPolyCoeff = nfyLoadPolyCoeff;
            returnStruct.mzLoadPolyCoeff = mzLoadPolyCoeff;
            returnStruct.nfyVals = nfyVals;
            returnStruct.mzVals = mzVals;
            returnStruct.meanLoads = meanLoads;
            returnStruct.fzOptions = fzOptions;
        end
    end
end