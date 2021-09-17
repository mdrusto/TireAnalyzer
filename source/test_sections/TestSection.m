classdef (Abstract) TestSection < handle & matlab.mixin.Heterogeneous % Inheriting from this lets me use property validation
    
    properties
        Name char
    end
    
    methods
        function obj = TestSection(name)
            obj.Name = name;
        end
        
        function returnStruct = doStuffWithData(obj, app, data, lb, ub, parentIndices, runOptions) % Need to pass lb and ub in in case this test is repeated...
            returnStruct = struct();
        end
    end
    
    methods (Abstract)
        ub = getUpperBound(obj, data, startIndex, parentIndices)
    end
end
