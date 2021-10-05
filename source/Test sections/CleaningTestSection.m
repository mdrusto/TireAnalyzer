classdef CleaningTestSection < TestSection
    
    methods
        function obj = CleaningTestSection(name, exceptions)
            if nargin < 2
                exceptions = TestSectionException.empty;
            end
            obj@TestSection(name, BoundsFinderN(1, 0), '', TestSection.empty, exceptions);
        end
        
        function [lb, ub] = getBounds(~, data, startIndex)
            lb = startIndex + 1;
            ub = length(data.ET);
        end
    end
end

