classdef IntermediateLevelCamberTestSection < TestSectionRepeatedWSpec
    
    methods
        function obj = IntermediateLevelCamberTestSection(name, varName, bFinder, tests)
            obj@TestSectionRepeatedWSpec(name, varName, bFinder, tests);
        end
        
        function return_struct = doStuffWithData(obj, app, data, ~, ~, parent_indices, run_opts)
            n_times = obj.BFinder.getN();
            n_tests = length(obj.NestedTests);
            ia_options = zeros(n_times);
            
            for i = 1:n_times
                found_loads = false;
                for j = 1:n_tests
                    ret_struct = obj.NestedTests(j).doStuffWithData( ...
                        app, ...
                        data, ...
                        obj.NestedLowerBounds(parent_indices, i, j), ...
                        obj.NestedUpperBounds(parent_indices, i, j), ...
                        [parent_indices i], ...
                        run_opts);
                    if isa(obj.NestedTests(j), 'LoadsTestSection')
                        found_loads = true;
                        return_struct.nfy_vals(i, :, :) = ret_struct.nfy_vals;
                        return_struct.mz_vals(i, :, :) = ret_struct.mz_vals;
                        return_struct.sa_data{i, :} = ret_struct.sa_data;
                        return_struct.fz_data{i, :} = ret_struct.fz_data;
                        return_struct.nfy_data{i, :} = ret_struct.nfy_data;
                        return_struct.mz_data{i, :} = ret_struct.mz_data;
                        
                        ia_options(i) = avg(data.IA(obj.NestedLowerBounds(parent_indices, i, j):obj.NestedUpperBounds(parent_indices, i, j)));
                    end
                end
                if ~found_loads
                    error('Matt error: no loads found in intermediate test section');
                end
                
                ia_options = round(ia_options);
                [ia_options, order] = sort(ia_options);
                app.LatLUTData.ia_options = ia_options;
                
                return_struct.nfy_vals(:, :, :) = return_struct.nfy_vals(order, :, :);
                return_struct.mz_vals(:, :, :) = return_struct.mz_vals(order, :, :);
                return_struct.sa_data{:, :} = return_struct.sa_data{order, :};
                return_struct.fz_data{:, :} = return_struct.fz_data{order, :};
                return_struct.nfy_data{:, :} = return_struct.nfy_data{order, :};
                return_struct.mz_data{:, :} = return_struct.mz_data{order, :};
            end
        end
    end
end