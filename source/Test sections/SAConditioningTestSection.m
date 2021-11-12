classdef SAConditioningTestSection < TestSection
    
    methods
        function obj = SAConditioningTestSection(name, bFinder, exceptions)
            if nargin < 2
                bFinder = BoundsFinderN(1, 200);
            end
            if nargin < 3
                exceptions = TestSectionException.empty;
            end
            obj@TestSection(name, bFinder, "FZ", TestSection.empty, exceptions);
        end
    end
end
