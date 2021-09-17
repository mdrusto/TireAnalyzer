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
        
        function ub = getUpperBound(obj, data, startIndex, ~)
            [~, ub] = groupDataAvg(data.FZ, obj.Val, obj.Threshold, startIndex + 200);
        end
    end
end