% Fit a pacejka curve to the data
function [C, exitflag] = fit_pacejka(xdata, ydata, algorithm, max_iterations, C0)

    % Fit options
    % Lower bound, upper bound, initial value
    lb = -inf*ones(1, 6);
    ub = inf*ones(1, 6);

    % Create options variable
    options = optimoptions('lsqcurvefit', ...
        'Display', 'off', ...
        'MaxFunctionEvaluations', max_iterations, ...
        'Algorithm', algorithm);

    % Run the fit function
    [C, ~, ~, exitflag, ~] = lsqcurvefit(@pacejka, C0, xdata, ydata, lb, ub, options);
end
