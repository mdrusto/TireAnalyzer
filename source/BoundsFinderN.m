classdef BoundsFinderN < BoundsFinder
    
    properties
        NumGroups
        Threshold
    end
    
    methods
        function obj = BoundsFinderN(numGroups, threshold)
            obj.NumGroups = numGroups;
            obj.Threshold = threshold;
        end
        
        function [lb, ub] = getBounds(obj, data, startIndex)
            [lb, ub] = groupDataDiff(data, obj.NumGroups, obj.Threshold, startIndex);
        end
        
        function n = getN(obj)
            n = obj.NumGroups;
        end
    end
    
end