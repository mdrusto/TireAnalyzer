classdef (Abstract) BoundsFinder < matlab.mixin.Heterogeneous
    
    methods
        function [lb, ub] = getBounds(obj, data, startIndex)
            lb = 0;
            ub = 0;
        end
        
        function n = getN(obj)
            n = 0;
        end
    end
    
    methods (Abstract)
        % Get bounds of each group in this test section
        
        
        
    end
end
