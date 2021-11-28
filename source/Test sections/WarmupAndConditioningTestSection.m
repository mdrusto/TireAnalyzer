classdef WarmupAndConditioningTestSection < TestSection
    
    methods
        function obj = WarmupAndConditioningTestSection(name, exceptions)
            if nargin < 2
                exceptions = TestSectionException.empty;
            end
            obj@TestSection(name, BoundsFinderN(1, 0), "", TestSection.empty, exceptions);
        end
        
        function [lb, ub] = getBounds(~, data, startIndex)
            lb = startIndex + 1;
            [~, ub] = groupDataDiff(data.FZ, 1, 250, startIndex);
        end
    end
end