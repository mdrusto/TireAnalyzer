function result = assign_2dcell_into_3dcell(assign_to, assign_from, page)
    if ~ismatrix(assign_from)
        error('Matt error: assign_from is not a matrix');
    elseif size(assign_to, 1) ~= size(assign_from, 1) || size(assign_to, 2) ~= size(assign_from, 2)
        error(['Matt error: "from" cell [' num2str(size(assign_from)) '] does not fit in "to" cell [' num2str(size(assign_to)) ']'])
    end
    n_rows = size(assign_to, 1);
    n_columns = size(assign_to, 2);
    for i = 1:n_rows
        for j = 1:n_columns
            assign_to{i, j, page} = assign_from{i, j};
            %disp(['Set column n=' num2str(n) ', row i=' num2str(i) ' to:'])
            %disp(assign_from{i}(1:4))
            %disp(assign_to)
        end
    end
    result = assign_to;
end