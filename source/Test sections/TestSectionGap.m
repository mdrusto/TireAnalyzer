classdef TestSectionGap < TestSection
    
    properties
        NDataPoints
    end
    
    methods
        function obj = TestSectionGap(name, nDataPoints, exceptions)
            if nargin < 3
                exceptions = TestSectionException.empty;
            end
            obj@TestSection(name, BoundsFinderN(1, 0), '', TestSection.empty, exceptions);
            obj.NDataPoints = nDataPoints;
        end
        
        function [lb, ub] = getBounds(obj, ~, startIndex)
            lb = startIndex + 1;
            ub = lb + obj.NDataPoints;
        end
    end
end

