classdef SpecifiedEndTestSection < TestSection
    
    methods
        function obj = SpecifiedEndTestSection(name, exceptions)
            if nargin < 2
                exceptions = TestSectionException.empty;
            end
            obj@TestSection(name, BoundsFinderN(1, 0), "", TestSection.empty, exceptions, false);
        end
        
        function [lb, ub] = getBounds(~, data, startIndex)
            lb = startIndex + 1;
            ub = length(data.ET);
        end
    end
    
end