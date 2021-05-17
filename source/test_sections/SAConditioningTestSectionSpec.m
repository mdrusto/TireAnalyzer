classdef SAConditioningTestSectionSpec < SAConditioningTestSection
    
    properties
        Val
        Threshold
    end
    
    methods
        function obj = SAConditioningTestSectionSpec(name, val, threshold)
            obj@SAConditioningTestSection(name);
            obj.Val = val;
            obj.Threshold = threshold;
        end
        
        function ub = getUpperBound(obj, data, start_index, ~)
            [~, ub] = group_data_avg(data.FZ, obj.Val, obj.Threshold, start_index + 200);
        end
    end
end