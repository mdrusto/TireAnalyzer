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
            
            app.LatPressureLUTData.saData = cell(nLoads, nTimes);
            app.LatPressureLUTData.fzData = cell(nLoads, nTimes);
            app.LatPressureLUTData.nfyData = cell(nLoads, nTimes);
            app.LatPressureLUTData.mzData = cell(nLoads, nTimes);
            app.LatPressureLUTData.nfyC = zeros(6, nLoads, nTimes);
            app.LatPressureLUTData.mzC = zeros(6, nLoads, nTimes);
            app.LatPressureLUTData.nfyExitFlags = zeros(nLoads, nTimes);
            app.LatPressureLUTData.mzExitFlags = zeros(nLoads, nTimes);
            app.LatPressureLUTData.nfySamplePoints = zeros(nSASample, nLoads, nTimes);
            app.LatPressureLUTData.mzSamplePoints = zeros(nSASample, nLoads, nTimes);
            app.LatPressureLUTData.nfyLoadPolyCoeff = 0;
            app.LatPressureLUTData.mzLoadPolyCoeff = 0;
            app.LatPressureLUTData.nfyVals = zeros(nSASample, nLoadSample, nTimes);
            app.LatPressureLUTData.mzVals = zeros(nSASample, nLoadSample, nTimes);
            app.LatPressureLUTData.meanLoads = zeros(nLoads, nTimes);
            app.LatPressureLUTData.fzOptions = 0;
            app.LatPressureLUTData.iaOptions = 0;
            
            for i = 1:nTimes
                for j = 1:nTests
                    test = obj.Children(j);
                    childResults = childrenResults{j}(i);
                    
                    if isa(test, 'LoadsTestSection')
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
                        
                        retNfyLoadPolyCoeff = childResults.nfyLoadPolyCoeff;
                        nLoadCoeff = size(retNfyLoadPolyCoeff, 1);
                        if i == 1
                            app.LatPressureLUTData.nfyLoadPolyCoeff = zeros(nLoadCoeff, nSASample, nTimes);
                            app.LatPressureLUTData.mzLoadPolyCoeff = zeros(nLoadCoeff, nSASample, nTimes);
                        end
                        app.LatPressureLUTData.nfyLoadPolyCoeff(:, :, i) = retNfyLoadPolyCoeff;
                        app.LatPressureLUTData.mzLoadPolyCoeff(:, :, i) = childResults.mzLoadPolyCoeff;
                        
                        app.LatPressureLUTData.nfyVals(:, :, i) = childResults.nfyVals;
                        app.LatPressureLUTData.mzVals(:, :, i) = childResults.mzVals;
                        app.LatPressureLUTData.meanLoads(:, i) = childResults.meanLoads;
                        app.LatPressureLUTData.fzOptions = childResults.fzOptions;
                        
                        pOptions(i) = mean(vertcat(childResults.pData{:}));
                    end
                end
            end
            
            % Display pressure in psi not kPa
            pOptions = pOptions * 0.145038;
            pOptions = round(pOptions);
            [pOptions, order] = sort(pOptions);
            
            app.LatPressureLUTData.pOptions = pOptions;
            
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
            
            processingResults = struct();
        end
    end
end