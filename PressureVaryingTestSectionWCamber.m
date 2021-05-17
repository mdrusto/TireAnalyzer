classdef PressureVaryingTestSectionWCamber < TestSectionRepeatedWSpec
    
    methods
        function obj = PressureVaryingTestSectionWCamber(name, varName, bFinder, tests)
            obj@TestSectionRepeatedWSpec(name, varName, bFinder, tests);
        end
        
        function return_struct = doStuffWithData(obj, app, data, ~, ~, parent_indices, run_opts)
            n_times = obj.BFinder.getN();
            n_tests = length(obj.NestedTests);
            n_camber = 0;
            n_loads = 0;
            n_sa_sample = length(run_opts.SASampleVals);
            n_load_sample = length(run_opts.LoadSampleVals);
            p_options = zeros(n_times, 1);
            found_camber = false;
            for j = 1:n_tests
                test = obj.NestedTests(j);
                if isa(test, 'IntermediateLevelCamberTestSection')
                    found_camber = true;
                    n_camber = test.BFinder.getN();
                    for k = 1:length(test.NestedTests)
                        nested_test = test.NestedTests(k);
                        if isa(nested_test, 'LoadsTestSection')
                            n_loads = nested_test.BFinder.getN();
                            break;
                        end
                    end
                    break;
                end
            end
            
            if ~found_camber
                error('Matt error: no loads found in intermediate test section');
            end
            
            app.LatLUTData = struct( ...
                'sa_data', {cell(n_loads, n_camber, n_times)}, ...
                'fz_data', {cell(n_loads, n_camber, n_times)}, ...
                'nfy_data', {cell(n_loads, n_camber, n_times)}, ...
                'mz_data', {cell(n_loads, n_camber, n_times)}, ...
                'nfy_C', zeros(6, n_loads, n_camber, n_times), ...
                'mz_C', zeros(6, n_loads, n_camber, n_times), ...
                'nfy_exitflags', zeros(n_loads, n_camber, n_times), ...
                'mz_exitflags', zeros(n_loads, n_camber, n_times), ...
                'nfy_load_poly_coeff', 0, ...
                'mz_load_poly_coeff', 0, ...
                'nfy_vals', zeros(n_sa_sample, n_load_sample, n_camber, n_times), ...
                'mz_vals', zeros(n_sa_sample, n_load_sample, n_camber, n_times), ...
                'mean_loads', zeros(n_loads, n_camber, n_times), ...
                'fz_options', zeros(n_loads, 1), ...
                'ia_options', zeros(n_camber, 1), ...
                'p_options', zeros(n_times, 1));
            
            for i = 1:n_times
                disp(['Pressure #' num2str(i)])
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
                    if isa(test, 'IntermediateLevelCamberTestSection')
                        app.LatLUTData.sa_data = assign_2dcell_into_3dcell(app.LatLUTData.sa_data, ret_struct.sa_data, i);
                        app.LatLUTData.fz_data = assign_2dcell_into_3dcell(app.LatLUTData.fz_data, ret_struct.fz_data, i);
                        app.LatLUTData.nfy_data = assign_2dcell_into_3dcell(app.LatLUTData.nfy_data, ret_struct.nfy_data, i);
                        app.LatLUTData.mz_data = assign_2dcell_into_3dcell(app.LatLUTData.mz_data, ret_struct.mz_data, i);
                        app.LatLUTData.nfy_sample_points(:, :, :, i) = ret_struct.nfy_sample_points;
                        app.LatLUTData.mz_sample_points(:, :, :, i) = ret_struct.mz_sample_points;
                        app.LatLUTData.nfy_C(:, :, :, i) = ret_struct.nfy_C;
                        app.LatLUTData.mz_C(:, :, :, i) = ret_struct.mz_C;
                        app.LatLUTData.nfy_exitflags(:, :, i) = ret_struct.nfy_exitflags;
                        app.LatLUTData.mz_exitflags(:, :, i) = ret_struct.mz_exitflags;
                        
                        ret_nfy_load_poly_coeff = ret_struct.nfy_load_poly_coeff;
                        n_load_coeff = size(ret_nfy_load_poly_coeff, 1);
                        if i == 1
                            app.LatLUTData.nfy_load_poly_coeff = zeros(n_load_coeff, n_sa_sample, n_camber, n_times);
                            app.LatLUTData.mz_load_poly_coeff = zeros(n_load_coeff, n_sa_sample, n_camber, n_times);
                        end
                        app.LatLUTData.nfy_load_poly_coeff(:, :, :, i) = ret_nfy_load_poly_coeff;
                        app.LatLUTData.mz_load_poly_coeff(:, :, :, i) = ret_struct.mz_load_poly_coeff;
                        
                        app.LatLUTData.nfy_vals(:, :, :, i) = ret_struct.nfy_vals;
                        app.LatLUTData.mz_vals(:, :, :, i) = ret_struct.mz_vals;
                        app.LatLUTData.mean_loads(:, :, i) = ret_struct.mean_loads;
                        app.LatLUTData.fz_options = ret_struct.fz_options;
                        app.LatLUTData.ia_options = ret_struct.ia_options;
                        
                        p_options(i) = mean(data.P(nested_lb:nested_ub));
                        
                    end
                end
            end
            
            % Display pressure in psi not kPa
            p_options = p_options * 0.145038;
            p_options = round(p_options);
            [p_options, order] = sort(p_options);
            
            app.LatLUTData.p_options = p_options;
            
            app.LatLUTData.nfy_vals = app.LatLUTData.nfy_vals(:, :, :, order);
            app.LatLUTData.mz_vals = app.LatLUTData.mz_vals(:, :, :, order);
            app.LatLUTData.sa_data = reorder3DCellDim3(app.LatLUTData.sa_data, order);
            app.LatLUTData.fz_data = reorder3DCellDim3(app.LatLUTData.fz_data, order);
            app.LatLUTData.nfy_data = reorder3DCellDim3(app.LatLUTData.nfy_data, order);
            app.LatLUTData.mz_data = reorder3DCellDim3(app.LatLUTData.mz_data, order);
            app.LatLUTData.nfy_sample_points = app.LatLUTData.nfy_sample_points(:, :, :, order);
            app.LatLUTData.mz_sample_points = app.LatLUTData.mz_sample_points(:, :, :, order);
            app.LatLUTData.nfy_C = app.LatLUTData.nfy_C(:, :, :, order);
            app.LatLUTData.mz_C = app.LatLUTData.mz_C(:, :, :, order);
            app.LatLUTData.nfy_exitflags = app.LatLUTData.nfy_exitflags(:, :, order);
            app.LatLUTData.mz_exitflags = app.LatLUTData.mz_exitflags(:, :, order);
            
            return_struct = struct();
        end
    end
end