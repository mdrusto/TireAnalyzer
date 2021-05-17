classdef CamberAndPressureVaryingTestSection < TestSectionRepeatedWSpec
    
    methods
        function obj = CamberAndPressureVaryingTestSection(name, varName, bFinder, tests)
            obj@TestSectionRepeatedWSpec(name, varName, bFinder, tests);
        end
        
        function return_struct = doStuffWithData(obj, app, data, ~, ~, parent_indices, run_opts)
            n_times = obj.BFinder.getN();
            n_tests = length(obj.NestedTests);
            p_options = zeros(n_times);
            app.LatLUTData = struct( ...
                'nfy_vals', 0, ...
                'mz_vals', 0, ...
                'sa_data', cell(1), ...
                'fz_data', cell(1), ...
                'nfy_data', cell(1), ...
                'mz_data', cell(1), ...
                'p_options', 0, ...
                'ia_options', 0);
            
            for i = 1:n_times
                found_cambers = false;
                for j = 1:n_tests
                    ret_struct = obj.NestedTests(j).doStuffWithData( ...
                        app, ...
                        data, ...
                        obj.NestedLowerBounds(parent_indices, i, j), ...
                        obj.NestedUpperBounds(parent_indices, i, j), ...
                        [parent_indices, i, j], ...
                        run_opts);
                    if isa(obj.NestedTests(j), 'IntermediateLevelCamberTestSection')
                        found_cambers = true;
                        app.LatLUTData.nfy_vals(i, :, :, :) = ret_struct.nfy_vals;
                        app.LatLUTData.mz_vals(i, :, :, :) = ret_struct.mz_vals;
                        app.LatLUTData.sa_data{i, :, :} = ret_struct.sa_data;
                        app.LatLUTData.fz_data{i, :, :} = ret_struct.fz_data;
                        app.LatLUTData.nfy_data{i, :, :} = ret_struct.nfy_data;
                        app.LatLUTData.mz_data{i, :, :} = ret_struct.mz_data;
                        
                        p_options(i) = avg(data.P(obj.NestedLowerBounds(parent_indices, i, j):obj.NestedUpperBounds(parent_indices, i, j)));
                    end
                end
                if ~found_cambers
                    error('Matt error: no loads found in intermediate test section');
                end
            end
            p_options = round(p_options);
            [p_options, order] = sort(p_options);
            app.LatLUTData.p_options = p_options;
            
            app.LatLUTData.nfy_vals(:, :, :, :) = app.LatLUTData.nfy_vals(order, :, :, :);
            app.LatLUTData.mz_vals(:, :, :, :) = app.LatLUTData.mz_vals(order, :, :, :);
            app.LatLUTData.sa_data{:, :, :} = app.LatLUTData.sa_data{order, :, :};
            app.LatLUTData.fz_data{:, :, :} = app.LatLUTData.fz_data{order, :, :};
            app.LatLUTData.nfy_data{:, :, :} = app.LatLUTData.nfy_data{order, :, :};
            app.LatLUTData.mz_data{:, :, :} = app.LatLUTData.mz_data{order, :, :};
            
            return_struct = struct();
        end
    end
end