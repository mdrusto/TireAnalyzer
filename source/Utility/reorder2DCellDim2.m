function outputCell = reorder2DCellDim2(inputCell, order)
    outputCell = inputCell;
    [n_rows, n_columns] = size(outputCell);
    for i = 1:n_rows
        for j = 1:n_columns
            outputCell{i, j} = inputCell{i, order(j)};
        end
    end
end