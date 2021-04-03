% Algorithm for finding the bounds of each group of data
function [lb, ub] = group_data_avg(data, avg, range, start)
    n = length(avg);
    n_data = length(data);
    lb = zeros(n, 1);
    ub = zeros(n, 1);
    x = start + 1;
    started_range = false;
    data_range = zeros(1, length(data));

    % Loop over the data groups
    for i = 1:n

        % Loop over the remaining data
        % Stop when it exits the range
        while true
            data_range(x) = avg(i);
            % If data is in the right range, set the lower bound
            if ~started_range && abs(data(x) - avg(i)) < range
                started_range = true;
                lb(i) = x;
            elseif x == n_data || (started_range && (x > lb(i) + 10) && abs(data(x) - avg(i)) > range)
                % Set the upper bound if no longer in the right range
                ub(i) = x;
                started_range = false;
                break;
            end
            
            x = x + 1; % Increment x
        end
        % If end of data and ranges are still remaining
        if x == n_data && i < n
            error('Matt error: more ranges given than found in data')
        end
    end
%     figure
%     scatter(1:length(data), data, 5);
%     hold on
%     for i = 1:n
%        plot([lb(i), ub(i)], [avg(i), avg(i)], 'red');
%     end

    % Set the bounds to the indices of the overall array
end