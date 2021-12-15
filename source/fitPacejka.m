% Fit a pacejka curve to the data
function [C, exitflag] = fitPacejka(xdata, ydata, algorithm, maxIterations, C0)

    % Fit options
    % Lower bound, upper bound, initial value
    lb = -inf*ones(1, 6);
    ub = inf*ones(1, 6);

    % Create options variable
    options = optimoptions('lsqcurvefit', ...
        'Display', 'off', ...
        'MaxFunctionEvaluations', maxIterations, ...
        'Algorithm', algorithm);

    % Run the fit function
    [C, ~, ~, exitflag, ~] = lsqcurvefit(@pacejka, C0, xdata, ydata, lb, ub, options);
end
