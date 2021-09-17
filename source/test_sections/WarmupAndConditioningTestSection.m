classdef WarmupAndConditioningTestSection < TestSection
    
    methods
        function obj = WarmupAndConditioningTestSection(name)
            obj@TestSection(name);
        end
        
        function ub = getUpperBound(~, data, startIndex, ~)
            [~, ub] = groupDataDiff(data.FZ, 1, 250, startIndex);
        end
    end
end