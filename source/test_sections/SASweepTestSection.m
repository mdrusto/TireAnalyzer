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
            
            % Apply scaling factors
            sa_data_scaled = sa_data*run_opts.XScalingFactor;
            nfy_data_scaled = nfy_data*run_opts.YScalingFactor;
            mz_data_scaled = mz_data*run_opts.YScalingFactor;
            
            % Convert to radians
            sa_data_scaled_rad = deg2rad(sa_data_scaled);
            
            % Fit the data and get the coeffients and exit flags
            [nfy_C, nfy_exitflag] = fit_pacejka(sa_data_scaled_rad, nfy_data_scaled, run_opts.PacejkaAlgorithm, run_opts.PacejkaMaxIterations);
            [mz_C, mz_exitflag] = fit_pacejka(sa_data_scaled_rad, mz_data_scaled, run_opts.PacejkaAlgorithm, run_opts.PacejkaMaxIterations);
            
            % Take sample points
            sa_sample_vals = run_opts.SASampleVals;
            sa_sample_vals_rad = deg2rad(sa_sample_vals);
            nfy_sample_points = pacejka(nfy_C, sa_sample_vals_rad);
            mz_sample_points = pacejka(mz_C, sa_sample_vals_rad);
            
            % Include all the relevant info in the return array
            return_struct.sa_data = sa_data_scaled;
            return_struct.nfy_data = nfy_data_scaled;
            return_struct.mz_data = mz_data_scaled;
            return_struct.fz_data = fz_data;
            return_struct.nfy_C = nfy_C;
            return_struct.nfy_exitflag = nfy_exitflag;
            return_struct.mz_C = mz_C;
            return_struct.mz_exitflag = mz_exitflag;
            return_struct.sa_sample_vals = sa_sample_vals;
            return_struct.nfy_sample_points = nfy_sample_points;
            return_struct.mz_sample_points = mz_sample_points;
        end
    end
end
