classdef SpringRateTestSection < TestSection
    
    methods
        function obj = SpringRateTestSection(name, bFinder, exceptions)
            if nargin < 2
                bFinder = BoundsFinderN(5, 200);
            end
            if nargin < 3
                exceptions = TestSectionException.empty;
            end
            obj@TestSection(name, bFinder, "FZ", TestSection.empty, exceptions);
        end
        
%         function ub = getUpperBound(~, data, startIndex, ~)
%             [~, ubArray] = groupDataDiff(data.FZ, 5, 200, startIndex);
%             ub = ubArray(5);
%         end
    end
end