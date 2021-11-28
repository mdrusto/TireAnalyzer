% Algorithm for finding the bounds of each group of data
function [lb, ub] = groupDataAvg(data, avg, existingValueThreshold, newValueThreshold, start)
    n = length(avg);
    nData = length(data);
    lb = zeros(n, 1);
    ub = zeros(n, 1);
    x = start + 1;
    startedRange = false;
    dataRange = zeros(1, length(data));

    % Loop over the data groups
    for i = 1:n

        % Loop over the remaining data
        % Stop when it exits the range
        while true
            dataRange(x) = avg(i);
            % If data is in the right range, set the lower bound
            if ~startedRange && abs(data(x) - avg(i)) < newValueThreshold
                startedRange = true;
                lb(i) = x;
            elseif x == nData || (startedRange && (x > lb(i) + 10) && abs(data(x) - avg(i)) > existingValueThreshold)
                % Set the upper bound if no longer in the right range
                ub(i) = x;
                startedRange = false;
                x = x + 1;
                break; % Break the while-loop and move to the next group
            end
            
            x = x + 1; % Increment x
        end
        % If end of data and ranges are still remaining
        if x == nData && i < n
            error('Matt error: more ranges given than found in data')
        end
    end
%     figure
%     scatter(1:length(data), data, 5);
%     hold on
%     for i = 1:n
%        plot([lb(i), ub(i)], [avg(i), avg(i)], 'red');
%     end
end