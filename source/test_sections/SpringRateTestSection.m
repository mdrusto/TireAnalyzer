classdef SpringRateTestSection < TestSection
    
    methods
        function obj = SpringRateTestSection(name)
            obj@TestSection(name);
        end
        
        function ub = getUpperBound(~, data, start_index, ~)
            [~, ub_array] = group_data_diff(data.FZ, 5, 200, start_index);
            ub = ub_array(5);
        end
    end
end