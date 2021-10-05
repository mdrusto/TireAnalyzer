classdef SAConditioningTestSection < TestSection
    
    methods
        function obj = SAConditioningTestSection(name, bFinder, exceptions)
            if nargin < 2
                bFinder = BoundsFinderN(1, 0);
            end
            if nargin < 3
                exceptions = TestSectionException.empty;
            end
            obj@TestSection(name, bFinder, '', TestSection.empty, exceptions);
        end
        
        function [lb, ub] = getBounds(~, data, startIndex)
            lb = startIndex + 1;
            ub = groupDataDiff(data.FZ, 1, 200, startIndex);
        end
    end
end
