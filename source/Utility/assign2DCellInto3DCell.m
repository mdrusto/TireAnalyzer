function result = assign2DCellInto3DCell(assignTo, assignFrom, page)
    if ~ismatrix(assignFrom)
        error('Matt error: assign_from is not a matrix');
    elseif size(assignTo, 1) ~= size(assignFrom, 1) || size(assignTo, 2) ~= size(assignFrom, 2)
        error(['Matt error: "from" cell [' num2str(size(assignFrom)) '] does not fit in "to" cell [' num2str(size(assignTo)) ']'])
    end
    nRows = size(assignTo, 1);
    nColumns = size(assignTo, 2);
    for i = 1:nRows
        for j = 1:nColumns
            assignTo{i, j, page} = assignFrom{i, j};
            %disp(['Set column n=' num2str(n) ', row i=' num2str(i) ' to:'])
            %disp(assign_from{i}(1:4))
            %disp(assign_to)
        end
    end
    result = assignTo;
end