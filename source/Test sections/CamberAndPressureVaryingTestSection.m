classdef CamberAndPressureVaryingTestSection < TestSection
    
    methods
        function obj = CamberAndPressureVaryingTestSection(name, bFinder, children, exceptions)
            obj@TestSection(name, bFinder, "P", children, exceptions);
        end
        
        function processingResults = processData(obj, app, ~, childrenResults, ~)
            nTimes = obj.BFinder.getN();
            nTests = length(obj.Children);
            pOptions = zeros(nTimes);
            app.LatLUTData = struct( ...
                'nfyVals', 0, ...
                'mzVals', 0, ...
                'saData', cell(1), ...
                'fzData', cell(1), ...
                'nfyData', cell(1), ...
                'mzData', cell(1), ...
                'pOptions', 0, ...
                'iaOptions', 0);
            
            for i = 1:nTimes
                foundCambers = false;
                for j = 1:nTests
                    test = obj.Children(j);
                    childResults = childrenResults{j}(i);
                    
                    if isa(test, 'IntermediateLevelCamberTestSection')
                        foundCambers = true;
                        
                        app.LatLUTData.nfyVals(:, :, :, i) = childResults.nfyVals;
                        app.LatLUTData.mzVals(:, :, :, i) = childResults.mzVals;
                        app.LatLUTData.saData(:, :, :, i) = childResults.saData;
                        app.LatLUTData.fzData(:, :, :, i) = childResults.fzData;
                        app.LatLUTData.nfyData(:, :, :, i) = childResults.nfyData;
                        app.LatLUTData.mzData(:, :, :, i) = childResults.mzData;
                        
                        pOptions(i) = mean(vertcat(childResults.pData{:}));
                    end
                end
                if ~foundCambers
                    error('Matt error: no loads found in intermediate test section');
                end
            end
            
            pOptions = round(pOptions);
            [pOptions, order] = sort(pOptions);
            app.LatLUTData.pOptions = pOptions;
            
            app.LatLUTData.saData = app.LatLUTData.saData{:, :, order};
            app.LatLUTData.fzData = app.LatLUTData.fzData{:, :, order};
            app.LatLUTData.nfyData = app.LatLUTData.nfyData{:, :, order};
            app.LatLUTData.mzData = app.LatLUTData.mzData{:, :, order};
            app.LatLUTData.nfyVals = app.LatLUTData.nfyVals(:, :, :, order);
            app.LatLUTData.mzVals = app.LatLUTData.mzVals(:, :, :, order);
            
            processingResults = struct();
        end
    end
end