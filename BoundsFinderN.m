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
        
        function [lb, ub] = getBounds(obj, data, start_index)
            [lb, ub] = group_data_diff(data, obj.NumGroups, obj.Threshold, start_index);
        end
        
        function n = getN(obj)
            n = obj.NumGroups;
        end
    end
    
end