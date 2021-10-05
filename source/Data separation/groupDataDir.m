function [lb, ub] = groupDataDir(~, data, n, start)

    lb = zeros(n, 1);
    ub = zeros(n, 1);
    lb(1) = 1;
    x = 0;
    dirPos = true;
    foundDirChangeOnce = false;
    for i = 1:n
        if i > 1
            lb(i) = ub(i - 1) + 1;
        end
        while 1
            x = x + 1;
            if (x == length(data)) || xor(data(x) - data(x + 1) > 0, dirPos)
                if ~foundDirChangeOnce
                    foundDirChangeOnce = true;
                else
                    ub(i) = x;
                    foundDirChangeOnce = false;
                    break
                end
            end
        end
    end
    lb = lb + start*ones(n, 1);
    ub = ub + start*ones(n, 1);

end