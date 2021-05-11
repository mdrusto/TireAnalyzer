function result = assign_1dcell_into_2dcell(assign_to, assign_from, n)
    if ~isvector(assign_from)
        error('Matt error: assign_from is not a vector');
    elseif size(assign_to, 1) ~= length(assign_from)
        error(['Matt error: "from" cell [' num2str(size(assign_from)) '] does not fit in "to" cell [' num2str(size(assign_to)) ']'])
    end
    n_rows = size(assign_to, 1);
    for i = 1:n_rows
        assign_to{i, n} = assign_from{i};
        %disp(['Set column n=' num2str(n) ', row i=' num2str(i) ' to:'])
        %disp(assign_from{i}(1:4))
        %disp(assign_to)
    end
    result = assign_to;
end