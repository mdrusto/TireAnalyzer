classdef SASweepTestSection < TestSection
    
    methods
        function obj = SASweepTestSection(name)
            obj@TestSection(name);
        end
        
        function ub = getUpperBound(~, data, start_index, ~)
            [~, ub] = group_data_diff(data.SA, 1, 1, start_index);
        end
        
        function return_struct = doStuffWithData(~, ~, data, lb, ub, ~, run_opts)
            % Get all the relevant data
            sa_data = data.SA(lb:ub);
            nfy_data = data.NFY(lb:ub);
            mz_data = data.MZ(lb:ub);
            fz_data = data.FZ(lb:ub);
            
            % Fit the data and get the coeffients and exit flags
            [nfy_C, nfy_exitflag] = fit_pacejka(sa_data, nfy_data, run_opts.algorithm, run_opts.max_iterations);
            [mz_C, mz_exitflag] = fit_pacejka(sa_data, mz_data, run_opts.algorithm, run_opts.max_iterations);
            
            % Take sample points
            sa_vals = run_opts.sa_bounds(1):run_opts.delta_sa:run_opts.sa_bounds(2);
            nfy_sample_points = pacejka(nfy_C, sa_vals);
            mz_sample_points = pacejka(mz_C, sa_vals);
            
            % Include all the relevant info in the return array
            return_struct.sa_data = sa_data;
            return_struct.nfy_data = nfy_data;
            return_struct.mz_data = mz_data;
            return_struct.fz_data = fz_data;
            return_struct.nfy_C = nfy_C;
            return_struct.nfy_exitflag = nfy_exitflag;
            return_struct.mz_C = mz_C;
            return_struct.mz_exitflag = mz_exitflag;
            return_struct.sa_vals = sa_vals;
            return_struct.nfy_sample_points = nfy_sample_points;
            return_struct.mz_sample_points = mz_sample_points;
        end
    end
end
