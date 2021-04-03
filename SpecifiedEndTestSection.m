classdef SpecifiedEndTestSection < TestSection
    
    methods
        function obj = SpecifiedEndTestSection(name)
            obj@TestSection(name);
        end
        
        function ub = getUpperBound(~, data, ~, ~)
            ub = length(data.ET);
        end
    end
    
end