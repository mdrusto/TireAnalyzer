classdef SpringRateTestSection < TestSection
    
    methods
        function obj = SpringRateTestSection(name)
            obj@TestSection(name);
        end
        
        function ub = getUpperBound(~, data, startIndex, ~)
            [~, ubArray] = groupDataDiff(data.FZ, 5, 200, startIndex);
            ub = ubArray(5);
        end
    end
end