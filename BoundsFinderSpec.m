classdef BoundsFinderSpec < BoundsFinder
    
    properties
        ExpectedVals
        Threshold
    end
    
    methods
        function obj = BoundsFinderSpec(expecVals, threshold)
            obj.ExpectedVals = expecVals;
            obj.Threshold = threshold;
        end
        
        function [lb, ub] = getBounds(obj, data, start_index)
            [lb, ub] = group_data_avg(data, obj.ExpectedVals, obj.Threshold, start_index);
        end
        
        function n = getN(obj)
            n = length(obj.ExpectedVals);
        end
    end
end