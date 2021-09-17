classdef CamberAndPressureVaryingTestSection < TestSectionRepeatedWSpec
    
    methods
        function obj = CamberAndPressureVaryingTestSection(name, varName, bFinder, tests)
            obj@TestSectionRepeatedWSpec(name, varName, bFinder, tests);
        end
        
        function returnStruct = doStuffWithData(obj, app, data, ~, ~, parentIndices, runOpts)
            nTimes = obj.BFinder.getN();
            nTests = length(obj.NestedTests);
            pOptions = zeros(nTimes);
            app.LatLUTData = struct( ...
                'nfy_vals', 0, ...
                'mz_vals', 0, ...
                'saData', cell(1), ...
                'fzData', cell(1), ...
                'nfyData', cell(1), ...
                'mzData', cell(1), ...
                'p_options', 0, ...
                'ia_options', 0);
            
            for i = 1:nTimes
                foundCambers = false;
                for j = 1:nTests
                    retStruct = obj.NestedTests(j).doStuffWithData( ...
                        app, ...
                        data, ...
                        obj.NestedLowerBounds(parentIndices, i, j), ...
                        obj.NestedUpperBounds(parentIndices, i, j), ...
                        [parentIndices, i, j], ...
                        runOpts);
                    if isa(obj.NestedTests(j), 'IntermediateLevelCamberTestSection')
                        foundCambers = true;
                        app.LatLUTData.nfy_vals(i, :, :, :) = retStruct.nfy_vals;
                        app.LatLUTData.mz_vals(i, :, :, :) = retStruct.mz_vals;
                        app.LatLUTData.saData{i, :, :} = retStruct.saData;
                        app.LatLUTData.fzData{i, :, :} = retStruct.fzData;
                        app.LatLUTData.nfyData{i, :, :} = retStruct.nfyData;
                        app.LatLUTData.mzData{i, :, :} = retStruct.mzData;
                        
                        pOptions(i) = avg(data.P(obj.NestedLowerBounds(parentIndices, i, j):obj.NestedUpperBounds(parentIndices, i, j)));
                    end
                end
                if ~foundCambers
                    error('Matt error: no loads found in intermediate test section');
                end
            end
            pOptions = round(pOptions);
            [pOptions, order] = sort(pOptions);
            app.LatLUTData.pOptions = pOptions;
            
            app.LatLUTData.nfyVals(:, :, :, :) = app.LatLUTData.nfyVals(order, :, :, :);
            app.LatLUTData.mzVals(:, :, :, :) = app.LatLUTData.mzVals(order, :, :, :);
            app.LatLUTData.saData{:, :, :} = app.LatLUTData.saData{order, :, :};
            app.LatLUTData.fzData{:, :, :} = app.LatLUTData.fzData{order, :, :};
            app.LatLUTData.nfyData{:, :, :} = app.LatLUTData.nfyData{order, :, :};
            app.LatLUTData.mzData{:, :, :} = app.LatLUTData.mzData{order, :, :};
            
            returnStruct = struct();
        end
    end
end