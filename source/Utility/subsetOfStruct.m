function subsetStruct = subsetOfStruct(totalStruct, bounds)
    
    fields = fieldnames(totalStruct);
    
    for i = 1:length(fields)
        field = fields{i};
        subsetStruct.(field) = totalStruct.(field)(bounds(1):bounds(2));
    end
    
end

