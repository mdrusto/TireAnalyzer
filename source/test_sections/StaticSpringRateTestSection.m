classdef StaticSpringRateTestSection < SpringRateTestSection
    
    methods
        function obj = StaticSpringRateTestSection(name)
            obj@SpringRateTestSection(name);
        end
        
        function ub = getUpperBound(~, data, start_index, ~)
            for i = (start_index + 1):length(data.ET)
                if abs(data.V(i)) > 0.2
                    ub = i - 1;
                    return
                end
            end
            ub = 0;
        end
    end
end
