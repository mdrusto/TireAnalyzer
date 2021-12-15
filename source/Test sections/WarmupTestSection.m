classdef WarmupTestSection < TestSection
    
    methods
        function obj = WarmupTestSection(name, exceptions)
            if nargin < 2
                exceptions = TestSectionException.empty;
            end
            obj@TestSection(name, BoundsFinderN(1, 0), "", TestSection.empty, exceptions);
        end
        
        function [lb, ub] = getBounds(~, data, startIndex)
            lb = startIndex + 1;
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
