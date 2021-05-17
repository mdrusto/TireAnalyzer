classdef CamberVaryingTestSection < TestSectionRepeatedWSpec
    
    methods
        function obj = CamberVaryingTestSection(name, varName, bFinder, tests)
            obj@TestSectionRepeatedWSpec(name, varName, bFinder, tests);
        end
        
        function return_struct = doStuffWithData(obj, app, data, ~, ~, parent_indices, run_opts)
            n_times = obj.BFinder.getN();
            n_tests = length(obj.NestedTests);
            n_loads = 0;
            n_sa_sample = length(run_opts.SASampleVals);
            n_load_sample = length(run_opts.LoadSampleVals);
            ia_options = zeros(n_times, 1);
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
            
            app.LatCamberLUTData = struct( ...
                'sa_data', {cell(n_times, n_loads)}, ...
                'fz_data', {cell(n_times, n_loads)}, ...
                'nfy_data', {cell(n_times, n_loads)}, ...
                'mz_data', {cell(n_times, n_loads)}, ...
                'nfy_C', zeros(6, n_loads, n_times), ...
                'mz_C', zeros(6, n_loads, n_times), ...
                'nfy_exitflags', zeros(n_loads, n_times), ...
                'mz_exitflags', zeros(n_loads, n_times), ...
                'nfy_sample_points', zeros(n_sa_sample, n_loads, n_times), ...
                'mz_sample_points', zeros(n_sa_sample, n_loads, n_times), ...
                'nfy_load_poly_coeff', 0, ...
                'mz_load_poly_coeff', 0, ...
                'nfy_vals', zeros(n_sa_sample, n_load_sample, n_times), ...
                'mz_vals', zeros(n_sa_sample, n_load_sample, n_times), ...
                'mean_loads', zeros(n_loads, n_times), ...
                'fz_options', 0, ...
                'ia_options', 0);
            
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
                        app.LatCamberLUTData.sa_data = assign_1dcell_into_2dcell(app.LatCamberLUTData.sa_data, ret_struct.sa_data, i);
                        app.LatCamberLUTData.fz_data = assign_1dcell_into_2dcell(app.LatCamberLUTData.fz_data, ret_struct.fz_data, i);
                        app.LatCamberLUTData.nfy_data = assign_1dcell_into_2dcell(app.LatCamberLUTData.nfy_data, ret_struct.nfy_data, i);
                        app.LatCamberLUTData.mz_data = assign_1dcell_into_2dcell(app.LatCamberLUTData.mz_data, ret_struct.mz_data, i);
                        app.LatCamberLUTData.nfy_sample_points(:, :, i) = ret_struct.nfy_sample_points;
                        app.LatCamberLUTData.mz_sample_points(:, :, i) = ret_struct.mz_sample_points;
                        app.LatCamberLUTData.nfy_C(:, :, i) = ret_struct.nfy_C;
                        app.LatCamberLUTData.mz_C(:, :, i) = ret_struct.mz_C;
                        app.LatCamberLUTData.nfy_exitflags(:, i) = ret_struct.nfy_exitflags;
                        app.LatCamberLUTData.mz_exitflags(:, i) = ret_struct.mz_exitflags;
                        
                        ret_nfy_load_poly_coeff = ret_struct.nfy_load_poly_coeff;
                        n_load_coeff = size(ret_nfy_load_poly_coeff, 1);
                        if i == 1
                            app.LatCamberLUTData.nfy_load_poly_coeff = zeros(n_load_coeff, n_sa_sample, n_times);
                            app.LatCamberLUTData.mz_load_poly_coeff = zeros(n_load_coeff, n_sa_sample, n_times);
                        end
                        app.LatCamberLUTData.nfy_load_poly_coeff(:, :, i) = ret_nfy_load_poly_coeff;
                        app.LatCamberLUTData.mz_load_poly_coeff(:, :, i) = ret_struct.mz_load_poly_coeff;
                        
                        app.LatCamberLUTData.nfy_vals(:, :, i) = ret_struct.nfy_vals;
                        app.LatCamberLUTData.mz_vals(:, :, i) = ret_struct.mz_vals;
                        app.LatCamberLUTData.mean_loads(:, i) = ret_struct.mean_loads;
                        app.LatCamberLUTData.fz_options = ret_struct.fz_options;
                        
                        ia_options(i) = mean(data.IA(nested_lb:nested_ub));
                    end
                end
            end
            
            ia_options = round(ia_options);
            [ia_options, order] = sort(ia_options);
            
            app.LatCamberLUTData.ia_options = ia_options;
            
            app.LatCamberLUTData.sa_data = reorder2DCellDim2(app.LatCamberLUTData.sa_data, order);
            app.LatCamberLUTData.fz_data = reorder2DCellDim2(app.LatCamberLUTData.fz_data, order);
            app.LatCamberLUTData.nfy_data = reorder2DCellDim2(app.LatCamberLUTData.nfy_data, order);
            app.LatCamberLUTData.mz_data = reorder2DCellDim2(app.LatCamberLUTData.mz_data, order);
            app.LatCamberLUTData.nfy_C = app.LatCamberLUTData.nfy_C(:, :, order);
            app.LatCamberLUTData.mz_C = app.LatCamberLUTData.mz_C(:, :, order);
            app.LatCamberLUTData.nfy_exitflags = app.LatCamberLUTData.nfy_exitflags(:, order);
            app.LatCamberLUTData.mz_exitflags = app.LatCamberLUTData.mz_exitflags(:, order);
            app.LatCamberLUTData.nfy_sample_points = app.LatCamberLUTData.nfy_sample_points(:, :, order);
            app.LatCamberLUTData.mz_sample_points = app.LatCamberLUTData.mz_sample_points(:, :, order);
            app.LatCamberLUTData.nfy_vals = app.LatCamberLUTData.nfy_vals(:, :, order);
            app.LatCamberLUTData.mz_vals = app.LatCamberLUTData.mz_vals(:, :, order);
            
            return_struct = struct();
        end
    end
end