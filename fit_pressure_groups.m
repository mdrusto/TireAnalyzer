function [lb, ub] = fit_pressure_groups(P_vals, start_i, end_i)
    %[lb, ub] = group_data_avg(P_vals(start_i:end_i), [83.67, 69.51, 97.33], 5, start_i - 1);
    [lb, ub] = group_data_diff(P_vals(start_i:end_i), 3, 5, start_i - 1);
end