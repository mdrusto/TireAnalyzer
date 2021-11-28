function outputCell = reorder3DCellDim3(inputCell, order)
    n_dims = ndims(inputCell);
    if n_dims ~= 3
        error(['Matt error: inputCell does not have 3 dims. n_dims: ' num2str(n_dims)])
    end
    outputCell = inputCell;
    [n_rows, n_columns, n_pages] = size(outputCell);
    for i = 1:n_rows
        for j = 1:n_columns
            for k = n_pages
                outputCell{i, j, k} = inputCell{i, j, order(k)};
            end
        end
    end
end