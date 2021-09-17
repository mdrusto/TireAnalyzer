classdef ColdToHotTestSection < TestSection
    
    methods
        function obj = ColdToHotTestSection(name)
            obj@TestSection(name);
        end
        
        function ub = getUpperBound(~, data, startIndex, ~)
            for i = (startIndex + 1):length(data.ET)
                if abs(data.FZ(i) - -1100) > 250
                    ub = i - 1;
                    return
                end
            end
        end
    end
end

