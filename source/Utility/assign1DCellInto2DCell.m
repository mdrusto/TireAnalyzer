function result = assign1DCellInto2DCell(assignTo, assignFrom, column)
    if ~isvector(assignFrom)
        error('Matt error: assign_from is not a vector');
    elseif size(assignTo, 1) ~= length(assignFrom)
        error(['Matt error: "from" cell [' num2str(size(assignFrom)) '] does not fit in "to" cell [' num2str(size(assignTo)) ']'])
    end
    nRows = size(assignTo, 1);
    for i = 1:nRows
        assignTo{i, column} = assignFrom{i};
        %disp(['Set column n=' num2str(n) ', row i=' num2str(i) ' to:'])
        %disp(assign_from{i}(1:4))
        %disp(assign_to)
    end
    result = assignTo;
end