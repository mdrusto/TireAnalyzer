function [lb, ub] = groupDataDiffMin(data, n, range, start, minPoints)
    
    if length(data) < 10
        error(['Matt error: not enough data supplied. Number of values: ' num2str(length(data))])
    end

    lb = zeros(n, 1);
    ub = zeros(n, 1);
    lb(1) = start + 1;
    x = start;
    for i = 1:n
        if i > 1
            lb(i) = ub(i - 1) + 1;
        end
        while 1
            x = x + 1;
            if x + 1 == length(data)
                ub(i) = x;
                if i ~= n
                    error('Matt error: more ranges given than found in data')
                end
                return
            elseif abs(data(x) - data(x + 1)) > range && i >= minPoints
                ub(i) = x;
                break
            end
        end
    end
end
