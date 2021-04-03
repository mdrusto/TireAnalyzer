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
        
        function ub = getUpperBound(obj, data, start_index, ~)
            [~, ub_array] = group_data_avg(data.FZ, obj.Vals, obj.Threshold, start_index);
            ub = ub_array(end);
        end
    end
end