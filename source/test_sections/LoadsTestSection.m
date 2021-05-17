classdef LoadsTestSection < TestSectionRepeatedWSpec
    
    methods
        function obj = LoadsTestSection(name, bFinder, nestedTests)
            obj@TestSectionRepeatedWSpec(name, 'FZ', bFinder, nestedTests);
        end
        
        function return_struct = doStuffWithData(obj, app, data, ~, ~, parent_indices, run_opts)
            n_times = obj.BFinder.getN();
            n_tests = length(obj.NestedTests);
            
            sa_sample_vals = run_opts.SASampleVals;
            n_sa = length(sa_sample_vals);
            load_sample_vals = -run_opts.LoadSampleVals;
            n_load_sample = length(load_sample_vals);
            nfy_sample_points = zeros(n_sa, n_load_sample);
            mz_sample_points = zeros(n_sa, n_load_sample);
            mean_loads = zeros(n_times, 1);
            
            fit_order = run_opts.LoadSensOrder;
            if (n_times <= fit_order)
                fit_order = n_times - 1;
            end
            if fit_order < 1
                error(['Matt error: order (' num2str(fit_order) ') must be >= 1'])
            end
            
            nfy_load_poly_coeff = zeros(fit_order + 1, n_sa);
            mz_load_poly_coeff = zeros(fit_order + 1, n_sa);
            nfy_vals = zeros(n_sa, n_load_sample);
            mz_vals = zeros(n_sa, n_load_sample);
            sa_data = cell(n_times, 1);
            fz_data = cell(n_times, 1);
            nfy_data = cell(n_times, 1);
            mz_data = cell(n_times, 1);
            nfy_C = zeros(6, n_times);
            mz_C = zeros(6, n_times);
            nfy_exitflags = zeros(n_times, 1);
            mz_exitflags = zeros(n_times, 1);
            
            for i = 1:n_times
                found_sweep = false;
                for j = 1:n_tests
                    new_indices = [parent_indices, i, j];
                    test = obj.NestedTests(j);
                    nested_lb = getNestedLB(obj, new_indices);
                    nested_ub = getNestedUB(obj, new_indices);
                    if any(size(nested_lb) > 1) || any(size(nested_ub) > 1)
                        error('Matt error: nested bound is array, should return scalar')
                    end
                    
                    ret_struct = test.doStuffWithData( ...
                        app, ...
                        data, ...
                        nested_lb, ...
                        nested_ub, ...
                        new_indices, ...
                        run_opts);
                    if isa(test, 'SASweepTestSection') || isa(test, 'SASweepTestSectionSpec')
                        found_sweep = true;
                        nfy_sample_points(:, i) = ret_struct.nfy_sample_points;
                        mz_sample_points(:, i) = ret_struct.mz_sample_points;
                        sa_data{i} = ret_struct.sa_data;
                        fz_data{i} = ret_struct.fz_data;
                        nfy_data{i} = ret_struct.nfy_data;
                        mz_data{i} = ret_struct.mz_data;
                        nfy_C(:, i) = ret_struct.nfy_C;
                        mz_C(:, i) = ret_struct.mz_C;
                        nfy_exitflags(i) = ret_struct.nfy_exitflag;
                        mz_exitflags(i) = ret_struct.mz_exitflag;
                        
                        mean_loads(i) = mean(ret_struct.fz_data);
                        %disp(['SA data set at i = ' num2str(i)])
                        %disp(['Size of sa_data{i}: [' num2str(size(sa_data{i})) ']'])
                        %disp(['LB: ' num2str(nested_lb) ', UB: ' num2str(nested_ub)])
                        %nested_lb
                        %nested_ub
                        %size(ret_struct.fz_data)
                        %size(obj.NestedLowerBounds)
                        %disp(['Mean loads at i=' num2str(i) ':'])
                        %disp(mean_loads(i))
                    end
                end
                if ~found_sweep
                    error('Matt error: no SA sweeps found inside loads section');
                end
            end
            
            mean_loads = -mean_loads;
            [mean_loads, order] = sort(mean_loads);
            fz_options = round(mean_loads);
            disp('Mean loads:')
            disp(mean_loads)
            % Re-order based on load order
            sa_data = sa_data(order);
            fz_data = sa_data(order);
            nfy_data = nfy_data(order);
            mz_data = mz_data(order);
            nfy_C(:, :) = nfy_C(:, order);
            mz_C(:, :) = mz_C(:, order);
            nfy_exitflags = nfy_exitflags(order);
            mz_exitflags = mz_exitflags(order);
            nfy_sample_points = nfy_sample_points(:, order);
            mz_sample_points = mz_sample_points(:, order);
            
            for k = 1:n_sa
                % Fit polynomials to the load data
                %disp('Mean loads:')
                %disp(mean_loads)
                %disp('Sample points:')
                %disp(nfy_sample_points(k, :)')
                %disp(fit_order)
                nfy_load_poly_coeff(:, k) = polyfit(mean_loads, nfy_sample_points(k, :)', fit_order);
                %disp('Mean loads:')
                %disp(mean_loads)
                mz_load_poly_coeff(:, k) = polyfit(mean_loads, mz_sample_points(k, :)', fit_order);
                % Generate values from these polynomials
                nfy_vals(k, :) = polyval(nfy_load_poly_coeff(:, k), load_sample_vals);
                mz_vals(k, :) = polyval(mz_load_poly_coeff(:, k), load_sample_vals);
            end
            
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
        end
    end
end