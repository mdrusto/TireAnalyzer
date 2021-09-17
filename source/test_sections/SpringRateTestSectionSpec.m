classdef SpringRateTestSectionSpec < SpringRateTestSection
    
    properties
        Vals
        Threshold
    end
    
    methods
        function obj = SpringRateTestSectionSpec(name, vals, threshold)
            obj@SpringRateTestSection(name);
            obj.Vals = vals;
            obj.Threshold = threshold;
        end
        
        function ub = getUpperBound(obj, data, startIndex, ~)
            [~, ubArray] = groupDataAvg(data.FZ, obj.Vals, obj.Threshold, startIndex);
            ub = ubArray(end);
        end
    end
end