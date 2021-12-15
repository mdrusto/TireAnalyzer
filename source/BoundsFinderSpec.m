classdef BoundsFinderSpec < BoundsFinder
    
    properties
        ExpectedVals
        ExistingValueThreshold
        NewValueThreshold
    end
    
    methods
        function obj = BoundsFinderSpec(expecVals, existingValueThreshold, newValueThreshold)
            obj.ExpectedVals = expecVals;
            obj.ExistingValueThreshold = existingValueThreshold;
            obj.NewValueThreshold = newValueThreshold;
        end
        
        function [lb, ub] = getBounds(obj, data, startIndex)
            [lb, ub] = groupDataAvg(data, obj.ExpectedVals, obj.ExistingValueThreshold, obj.NewValueThreshold, startIndex);
        end
        
        function n = getN(obj)
            n = length(obj.ExpectedVals);
        end
    end
end