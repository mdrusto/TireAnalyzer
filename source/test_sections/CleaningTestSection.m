classdef CleaningTestSection < TestSection
    
    methods
        function obj = CleaningTestSection(name)
            obj@TestSection(name);
        end
        
        function ub = getUpperBound(~, ~, ~, ~)
            ub = 0;
        end
    end
end

