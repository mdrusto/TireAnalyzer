classdef (Abstract) BoundsFinder < matlab.mixin.Heterogeneous
    
    methods (Abstract)
        [lb, ub] = getBounds(obj, data, start_index)
        
        n = getN(obj)
    end
end
