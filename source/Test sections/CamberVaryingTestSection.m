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
            obj@TestSection(name, bFinder, 'IA', children, exceptions);
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
            
            app.LatCamberLUTData.saData = cell(nLoads, nTimes);
            app.LatCamberLUTData.fzData = cell(nLoads, nTimes);
            app.LatCamberLUTData.nfyData = cell(nLoads, nTimes);
            app.LatCamberLUTData.mzData = cell(nLoads, nTimes);
            app.LatCamberLUTData.nfyC = zeros(6, nLoads, nTimes);
            app.LatCamberLUTData.mzC = zeros(6, nLoads, nTimes);
            app.LatCamberLUTData.nfyExitFlags = zeros(nLoads, nTimes);
            app.LatCamberLUTData.mzExitFlags = zeros(nLoads, nTimes);
            app.LatCamberLUTData.nfySamplePoints = zeros(nSASample, nLoads, nTimes);
            app.LatCamberLUTData.mzSamplePoints = zeros(nSASample, nLoads, nTimes);
            app.LatCamberLUTData.nfyLoadPolyCoeff = 0;
            app.LatCamberLUTData.mzLoadPolyCoeff = 0;
            app.LatCamberLUTData.nfyVals = zeros(nSASample, nLoadSample, nTimes);
            app.LatCamberLUTData.mzVals = zeros(nSASample, nLoadSample, nTimes);
            app.LatCamberLUTData.meanLoads = zeros(nLoads, nTimes);
            app.LatCamberLUTData.fzOptions = 0;
            app.LatCamberLUTData.iaOptions = 0;
            
            for i = 1:nTimes
                for j = 1:nTests
                    test = obj.Children(j);
                    childResults = childrenResults{j}(i);
                    
                    if isa(test, 'LoadsTestSection')
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
                        
                        retNfyLoadPolyCoeff = childResults.nfyLoadPolyCoeff;
                        nLoadCoeff = size(retNfyLoadPolyCoeff, 1);
                        if i == 1
                            app.LatCamberLUTData.nfyLoadPolyCoeff = zeros(nLoadCoeff, nSASample, nTimes);
                            app.LatCamberLUTData.mzLoadPolyCoeff = zeros(nLoadCoeff, nSASample, nTimes);
                        end
                        app.LatCamberLUTData.nfyLoadPolyCoeff(:, :, i) = retNfyLoadPolyCoeff;
                        app.LatCamberLUTData.mzLoadPolyCoeff(:, :, i) = childResults.mzLoadPolyCoeff;
                        
                        app.LatCamberLUTData.nfyVals(:, :, i) = childResults.nfyVals;
                        app.LatCamberLUTData.mzVals(:, :, i) = childResults.mzVals;
                        app.LatCamberLUTData.meanLoads(:, i) = childResults.meanLoads;
                        app.LatCamberLUTData.fzOptions = childResults.fzOptions;
                        
                        iaOptions(i) = mean(vertcat(childResults.iaData{:}));
                    end
                end
            end
            
            iaOptions = round(iaOptions);
            [iaOptions, order] = sort(iaOptions);
            
            app.LatCamberLUTData.iaOptions = iaOptions;
            
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
            
            processingResults = struct();
        end
    end
end