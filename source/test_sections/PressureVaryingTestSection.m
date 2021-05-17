classdef PressureVaryingTestSection < TestSectionRepeatedWSpec
    
    methods
        function obj = PressureVaryingTestSection(name, varName, bFinder, tests)
            obj@TestSectionRepeatedWSpec(name, varName, bFinder, tests);
        end
        
        function return_struct = doStuffWithData(obj, app, data, ~, ~, parent_indices, run_opts)
            n_times = obj.BFinder.getN();
            n_tests = length(obj.NestedTests);
            n_loads = 0;
            n_sa_sample = length(run_opts.SASampleVals);
            n_load_sample = length(run_opts.LoadSampleVals);
            p_options = zeros(n_times, 1);
            found_loads = false;
            for j = 1:n_tests
                test = obj.NestedTests(j);
                if isa(test, 'LoadsTestSection')
                    found_loads = true;
                    n_loads = test.BFinder.getN();
                    break;
                end
            end
            
            if ~found_loads
                error('Matt error: no loads found in intermediate test section');
            end
            
            app.LatPressureLUTData = struct( ...
                'sa_data', {cell(n_loads, n_times)}, ...
                'fz_data', {cell(n_loads, n_times)}, ...
                'nfy_data', {cell(n_loads, n_times)}, ...
                'mz_data', {cell(n_loads, n_times)}, ...
                'nfy_C', zeros(6, n_loads, n_times), ...
                'mz_C', zeros(6, n_loads, n_times), ...
                'nfy_exitflags', zeros(n_loads, n_times), ...
                'mz_exitflags', zeros(n_loads, n_times), ...
                'nfy_load_poly_coeff', 0, ...
                'mz_load_poly_coeff', 0, ...
                'nfy_vals', zeros(n_sa_sample, n_load_sample, n_times), ...
                'mz_vals', zeros(n_sa_sample, n_load_sample, n_times), ...
                'mean_loads', zeros(n_loads, n_times), ...
                'fz_options', 0, ...
                'p_options', 0);
            
            for i = 1:n_times
                for j = 1:n_tests
                    new_indices = [parent_indices, i, j];
                    test = obj.NestedTests(j);
                    
                    nested_lb = getNestedLB(obj, new_indices);
                    nested_ub = getNestedUB(obj, new_indices);
                    
                    ret_struct = test.doStuffWithData( ...
                        app, ...
                        data, ...
                        nested_lb, ...
                        nested_ub, ...
                        new_indices, ...
                        run_opts);
                    if isa(test, 'LoadsTestSection')
                        app.LatPressureLUTData.sa_data = assign_1dcell_into_2dcell(app.LatPressureLUTData.sa_data, ret_struct.sa_data, i);
                        app.LatPressureLUTData.fz_data = assign_1dcell_into_2dcell(app.LatPressureLUTData.fz_data, ret_struct.fz_data, i);
                        app.LatPressureLUTData.nfy_data = assign_1dcell_into_2dcell(app.LatPressureLUTData.nfy_data, ret_struct.nfy_data, i);
                        app.LatPressureLUTData.mz_data = assign_1dcell_into_2dcell(app.LatPressureLUTData.mz_data, ret_struct.mz_data, i);
                        app.LatPressureLUTData.nfy_sample_points(:, :, i) = ret_struct.nfy_sample_points;
                        app.LatPressureLUTData.mz_sample_points(:, :, i) = ret_struct.mz_sample_points;
                        app.LatPressureLUTData.nfy_C(:, :, i) = ret_struct.nfy_C;
                        app.LatPressureLUTData.mz_C(:, :, i) = ret_struct.mz_C;
                        app.LatPressureLUTData.nfy_exitflags(:, i) = ret_struct.nfy_exitflags;
                        app.LatPressureLUTData.mz_exitflags(:, i) = ret_struct.mz_exitflags;
                        
                        ret_nfy_load_poly_coeff = ret_struct.nfy_load_poly_coeff;
                        n_load_coeff = size(ret_nfy_load_poly_coeff, 1);
                        if i == 1
                            app.LatPressureLUTData.nfy_load_poly_coeff = zeros(n_load_coeff, n_sa_sample, n_times);
                            app.LatPressureLUTData.mz_load_poly_coeff = zeros(n_load_coeff, n_sa_sample, n_times);
                        end
                        app.LatPressureLUTData.nfy_load_poly_coeff(:, :, i) = ret_nfy_load_poly_coeff;
                        app.LatPressureLUTData.mz_load_poly_coeff(:, :, i) = ret_struct.mz_load_poly_coeff;
                        
                        app.LatPressureLUTData.nfy_vals(:, :, i) = ret_struct.nfy_vals;
                        app.LatPressureLUTData.mz_vals(:, :, i) = ret_struct.mz_vals;
                        app.LatPressureLUTData.mean_loads(:, i) = ret_struct.mean_loads;
                        app.LatPressureLUTData.fz_options = ret_struct.fz_options;
                        
                        p_options(i) = mean(data.P(nested_lb:nested_ub));
                    end
                end
            end
            
            % Display pressure in psi not kPa
            p_options = p_options * 0.145038;
            p_options = round(p_options);
            [p_options, order] = sort(p_options);
            
            app.LatPressureLUTData.p_options = p_options;
            
            app.LatPressureLUTData.nfy_vals(:, :, :) = app.LatPressureLUTData.nfy_vals(:, :, order);
            app.LatPressureLUTData.mz_vals(:, :, :) = app.LatPressureLUTData.mz_vals(:, :, order);
            app.LatPressureLUTData.sa_data = reorder2DCellDim2(app.LatPressureLUTData.sa_data, order);
            app.LatPressureLUTData.fz_data = reorder2DCellDim2(app.LatPressureLUTData.fz_data, order);
            app.LatPressureLUTData.nfy_data = reorder2DCellDim2(app.LatPressureLUTData.nfy_data, order);
            app.LatPressureLUTData.mz_data = reorder2DCellDim2(app.LatPressureLUTData.mz_data, order);
            app.LatPressureLUTData.nfy_sample_points(:, :, :) = app.LatPressureLUTData.nfy_sample_points(:, :, order);
            app.LatPressureLUTData.mz_sample_points(:, :, :) = app.LatPressureLUTData.mz_sample_points(:, :, order);
            app.LatPressureLUTData.nfy_C(:, :, :) = app.LatPressureLUTData.nfy_C(:, :, order);
            app.LatPressureLUTData.mz_C(:, :, :) = app.LatPressureLUTData.mz_C(:, :, order);
            app.LatPressureLUTData.nfy_exitflags(:, :) = app.LatPressureLUTData.nfy_exitflags(:, order);
            app.LatPressureLUTData.mz_exitflags(:, :) = app.LatPressureLUTData.mz_exitflags(:, order);
            
            return_struct = struct();
        end
    end
end