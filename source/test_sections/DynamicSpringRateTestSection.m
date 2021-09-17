classdef DynamicSpringRateTestSection < SpringRateTestSection
    
    methods
        function obj = DynamicSpringRateTestSection(name)
            obj@SpringRateTestSection(name);
        end
        
        function ub = getUpperBound(~, data, startIndex, ~)
            [~, ubArray] = groupDataDiff(data.FZ, 4, 200, startIndex);
            ub = ubArray(4);
        end
    end
end
