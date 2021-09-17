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
        
        function [lb, ub] = getBounds(obj, data, startIndex)
            [lb, ub] = groupDataAvg(data, obj.ExpectedVals, obj.Threshold, startIndex);
        end
        
        function n = getN(obj)
            n = length(obj.ExpectedVals);
        end
    end
end