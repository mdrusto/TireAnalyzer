function [lb, ub] = fit_camber_groups(IA_vals, start_i, end_i)
    %disp("Pressure group  #" + p_counter + ":")
    %[lb, ub] = group_data_avg(IA_vals(start_i:end_i), [0 2 4], 0.1, start_i - 1);
    [lb, ub] = group_data_diff(IA_vals(start_i:end_i), 3, 0.1, start_i - 1);
    %title("Camber grouping for P=" + p_counter)
    %disp('Grouping FZ data...')
end