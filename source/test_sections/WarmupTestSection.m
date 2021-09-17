classdef WarmupTestSection < TestSection
    
    methods
        function obj = WarmupTestSection(name)
            obj@TestSection(name);
        end
        
        function ub = getUpperBound(~, data, startIndex, ~)
            for i = (startIndex + 1):length(data.ET)
                if abs(data.SA(i)) > 9
                    ub = i - 1;
                    return
                end
            end
            noUBFoundError();
        end
    end
end
