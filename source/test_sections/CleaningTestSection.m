classdef CleaningTestSection < TestSection
    
    methods
        function obj = CleaningTestSection(name)
            obj@TestSection(name);
        end
        
        function ub = getUpperBound(obj, data, start_index, ~)
            ub = 0;
        end
    end
end

