classdef ColdToHotTestSection < TestSection
    
    methods
        function obj = ColdToHotTestSection(name, exceptions)
            if nargin < 2
                exceptions = TestSectionException.empty;
            end
            obj@TestSection(name, BoundsFinderN(1, 0), '', TestSection.empty, exceptions);
        end
        
        function [lb, ub] = getBounds(~, data, startIndex)
            lb = startIndex + 1;
            for i = (startIndex + 1):length(data.ET)
                if abs(data.FZ(i) - -1100) > 250
                    ub = i - 1;
                    return
                end
            end
        end
    end
end

