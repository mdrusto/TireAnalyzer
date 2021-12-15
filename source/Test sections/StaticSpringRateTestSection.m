classdef StaticSpringRateTestSection < SpringRateTestSection
    
    methods
        function obj = StaticSpringRateTestSection(name, exceptions)
            obj@SpringRateTestSection(name, exceptions);
        end
        
        function ub = getUpperBound(~, data, startIndex, ~)
            for i = (startIndex + 1):length(data.ET)
                if abs(data.V(i)) > 0.2
                    ub = i - 1;
                    return
                end
            end
            ub = 0;
        end
    end
end
