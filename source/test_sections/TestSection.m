classdef (Abstract) TestSection < handle & matlab.mixin.Heterogeneous % Inheriting from this lets me use property validation
    
    properties
        Name char
    end
    
    methods
        function obj = TestSection(name)
            obj.Name = name;
        end
        
        function return_struct = doStuffWithData(obj, app, data, lb, ub, parent_indices, runOptions) % Need to pass lb and ub in in case this test is repeated...
            return_struct = struct();
        end
    end
    
    methods (Abstract)
        ub = getUpperBound(obj, data, start_index, parent_indices)
    end
end
