classdef LoadsTestSection < TestSectionRepeatedWSpec
    
    methods
        function obj = LoadsTestSection(name, bFinder, nestedTests)
            obj@TestSectionRepeatedWSpec(name, 'FZ', bFinder, nestedTests);
        end
        
        function return_struct = doStuffWithData(obj, app, data, ~, ~, ~, run_opts)
            sa_vals = run_opts.sa_bounds(1):run_opts.sa_delta:run_opts.sa_bounds(2);           
            n_sa = length(sa_vals);
            load_vals = -run_opts.load_ub:load_delta:0;
            n_load_sample = length(load_vals);
            n_load_data = obj.bFinder.getN();
            nfy_sample_points = zeros(n_sa, n_load_data);
            mz_sample_points = zeros(n_sa, n_load_data);
            mean_loads = zeros(n_load_data);
            nfy_load_poly_coeff = zeros(run_opts.load_fit_order, n_sa);
            mz_load_poly_coeff = zeros(run_opts.load_fit_order, n_sa);
            nfy_vals = zeros(n_sa, n_load_sample);
            mz_vals = zeros(n_sa, n_load_sample);
            
            for i = 1:n_times
                found_sweep = false;
                for j = 1:n_tests
                    test = obj.NestedTests(j);
                    ret_struct = test.doStuffWithData(app, data, obj.NestedLowerBounds(i, j), obj.NestedUpperBounds(i, j), [], run_opts);
                    if isa(test, 'SASweepTestSection') || isa(test, 'SASweepTestSectionSpec')
                        found_sweep = true;
                        nfy_sample_points(:, i) = ret_struct.nfy_sample_points;
                        mz_sample_points(:, i) = ret_struct.mz_sample_points;
                        mean_loads(i) = avg(ret_struct.fz_data);
                    end
                end
                if ~found_sweep
                    error('Matt error: no SA sweeps found inside loads section');
                end
            end
            
            for k = 1:n_sa
                % Fit polynomials to the load data
                nfy_load_poly_coeff(:, i) = polyfit(mean_loads, nfy_sample_points(i, :));
                mz_load_poly_coeff(:, i) = polyfit(mean_loads, mz_sample_points(i, :));
                % Generate values from these polynomials
                nfy_vals(i, :) = polyval(nfy_load_poly_coeff(:, i), load_vals);
                mz_vals(i, :) = polyval(mz_load_poly_coeff(:, i), load_vals);
            end
            
            return_struct.nfy_vals = nfy_vals;
            return_struct.mz_vals = mz_vals;
        end
    end
end