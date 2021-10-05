classdef DynamicSpringRateTestSection < SpringRateTestSection
    
    methods
        function obj = DynamicSpringRateTestSection(name, bFinder, children, exceptions)
            obj@SpringRateTestSection(name, bFinder, 'FZ', children, exceptions);
        end
        
        function [lb, ub] = getBounds(~, data, startIndex, ~)
            lb = startIndex + 1;
            [~, ubArray] = groupDataDiff(data.FZ, 4, 200, startIndex);
            ub = ubArray(4);
        end
    end
end
