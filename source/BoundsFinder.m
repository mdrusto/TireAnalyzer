classdef (Abstract) BoundsFinder < matlab.mixin.Heterogeneous
    
    methods (Abstract)
        [lb, ub] = getBounds(obj, data, startIndex)
        
        n = getN(obj)
    end
end
