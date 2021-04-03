classdef SAConditioningTestSection < TestSection
    
    methods
        function obj = SAConditioningTestSection(name)
            obj@TestSection(name);
        end
        
        function ub = getUpperBound(~, data, start_index, ~)
            ub = group_data_diff(data.FZ, 1, 200, start_index);
        end
    end
end

