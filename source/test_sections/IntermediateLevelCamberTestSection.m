classdef IntermediateLevelCamberTestSection < TestSectionRepeatedWSpec
    
    methods
        function obj = IntermediateLevelCamberTestSection(name, varName, bFinder, tests)
            obj@TestSectionRepeatedWSpec(name, varName, bFinder, tests);
        end
        
        function return_struct = doStuffWithData(obj, app, data, ~, ~, parent_indices, run_opts)
            n_times = obj.BFinder.getN();
            n_tests = length(obj.NestedTests);
            n_loads = 0;
            n_sa_sample = length(run_opts.SASampleVals);
            n_load_sample = length(run_opts.LoadSampleVals);
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
            
            sa_data = cell(n_loads, n_times);
            fz_data = cell(n_loads, n_times);
            nfy_data = cell(n_loads, n_times);
            mz_data = cell(n_loads, n_times);
            
            nfy_C = zeros(6, n_loads, n_times);
            mz_C = zeros(6, n_loads, n_times);
            nfy_exitflags = zeros(n_loads, n_times);
            mz_exitflags = zeros(n_loads, n_times);
            nfy_sample_points = zeros(n_sa_sample, n_loads, n_times);
            mz_sample_points = zeros(n_sa_sample, n_loads, n_times);
            nfy_load_poly_coeff = 0;
            mz_load_poly_coeff = 0;
            nfy_vals = zeros(n_sa_sample, n_load_sample, n_times);
            mz_vals = zeros(n_sa_sample, n_load_sample, n_times);
            mean_loads = zeros(n_loads, n_times);
            fz_options = 0;
            ia_options = zeros(n_times, 1);
            
            for i = 1:n_times
                %disp(['Camber #' num2str(i)])
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
                    if isa(obj.NestedTests(j), 'LoadsTestSection')
                        sa_data = assign_1dcell_into_2dcell(sa_data, ret_struct.sa_data, i);
                        fz_data = assign_1dcell_into_2dcell(fz_data, ret_struct.fz_data, i);
                        nfy_data = assign_1dcell_into_2dcell(nfy_data, ret_struct.nfy_data, i);
                        mz_data = assign_1dcell_into_2dcell(mz_data, ret_struct.mz_data, i);
                        nfy_sample_points(:, :, i) = ret_struct.nfy_sample_points;
                        mz_sample_points(:, :, i) = ret_struct.mz_sample_points;
                        nfy_C(:, :, i) = ret_struct.nfy_C;
                        mz_C(:, :, i) = ret_struct.mz_C;
                        nfy_exitflags(:, i) = ret_struct.nfy_exitflags;
                        mz_exitflags(:, i) = ret_struct.mz_exitflags;
                        
                        ret_nfy_load_poly_coeff = ret_struct.nfy_load_poly_coeff;
                        n_load_coeff = size(ret_nfy_load_poly_coeff, 1);
                        if i == 1
                            nfy_load_poly_coeff = zeros(n_load_coeff, n_sa_sample, n_times);
                            mz_load_poly_coeff = zeros(n_load_coeff, n_sa_sample, n_times);
                        end
                        nfy_load_poly_coeff(:, :, i) = ret_nfy_load_poly_coeff; %#ok<AGROW>
                        mz_load_poly_coeff(:, :, i) = ret_struct.mz_load_poly_coeff; %#ok<AGROW>
                        
                        nfy_vals(:, :, i) = ret_struct.nfy_vals;
                        mz_vals(:, :, i) = ret_struct.mz_vals;
                        mean_loads(:, i) = ret_struct.mean_loads;
                        fz_options = ret_struct.fz_options;
                        
                        ia_options(i) = mean(data.IA(nested_lb:nested_ub));
                    end
                end
            end
            
            ia_options = round(ia_options);
            [ia_options, order] = sort(ia_options);
            return_struct.ia_options = ia_options;

            sa_data = reorder2DCellDim2(sa_data, order);
            fz_data = reorder2DCellDim2(fz_data, order);
            nfy_data = reorder2DCellDim2(nfy_data, order);
            mz_data = reorder2DCellDim2(mz_data, order);
            nfy_sample_points = nfy_sample_points(:, :, order);
            mz_sample_points = mz_sample_points(:, :, order);
            nfy_C = nfy_C(:, :, order);
            mz_C = mz_C(:, :, order);
            nfy_exitflags = nfy_exitflags(:, order);
            mz_exitflags = mz_exitflags(:, order);
            nfy_vals = nfy_vals(:, :, order);
            mz_vals = mz_vals(:, :, order);
            
            return_struct.sa_data = sa_data;
            return_struct.fz_data = fz_data;
            return_struct.nfy_data = nfy_data;
            return_struct.mz_data = mz_data;
            return_struct.nfy_C = nfy_C;
            return_struct.mz_C = mz_C;
            return_struct.nfy_exitflags = nfy_exitflags;
            return_struct.mz_exitflags = mz_exitflags;
            return_struct.nfy_sample_points = nfy_sample_points;
            return_struct.mz_sample_points = mz_sample_points;
            return_struct.nfy_load_poly_coeff = nfy_load_poly_coeff;
            return_struct.mz_load_poly_coeff = mz_load_poly_coeff;
            return_struct.nfy_vals = nfy_vals;
            return_struct.mz_vals = mz_vals;
            return_struct.mean_loads = mean_loads;
            return_struct.fz_options = fz_options;
            return_struct.ia_options = ia_options;
        end
    end
end