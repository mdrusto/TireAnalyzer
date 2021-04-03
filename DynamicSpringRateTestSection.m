classdef DynamicSpringRateTestSection < SpringRateTestSection
    
    methods
        function obj = DynamicSpringRateTestSection(name)
            obj@SpringRateTestSection(name);
        end
        
        function ub = getUpperBound(~, data, start_index, ~)
            [~, ub_array] = group_data_diff(data.FZ, 4, 200, start_index);
            ub = ub_array(4);
        end
    end
end
