classdef WarmupAndConditioningTestSection < TestSection
    
    methods
        function obj = WarmupAndConditioningTestSection(name)
            obj@TestSection(name);
        end
        
        function ub = getUpperBound(~, data, start_index, ~)
            [~, ub] = group_data_diff(data.FZ, 1, 250, start_index);
        end
    end
end