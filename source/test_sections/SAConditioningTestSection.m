classdef SAConditioningTestSection < TestSection
    
    methods
        function obj = SAConditioningTestSection(name)
            obj@TestSection(name);
        end
        
        function ub = getUpperBound(~, data, startIndex, ~)
            ub = groupDataDiff(data.FZ, 1, 200, startIndex);
        end
    end
end
