% Test section that waits until the data is within a threshold range of a specified value
classdef TestSectionGap < TestSection
    
    properties
        Value
        Threshold
    end
    
    methods
        function obj = TestSectionGap(name, varName, value, threshold, exceptions)
            if nargin < 5
                exceptions = TestSectionException.empty;
            end
            obj@TestSection(name, BoundsFinderN(1, 0), varName, TestSection.empty, exceptions);
            obj.Value = value;
            obj.Threshold = threshold;
        end
        
        function [lb, ub] = getBounds(obj, data, startIndex)
            lb = startIndex + 1;
            dataSel = data.(obj.VarName);
            for i = (startIndex + 1):length(dataSel)
                if abs(dataSel(i) - obj.Value) < obj.Threshold
                    ub = i - 1;
                    %disp(['Test: ' obj.Name ', UB: ' num2str(ub)]);
                    return
                end
            end
            error(['Matt error: no upper bound found. Value: ' num2str(obj.Value) ', threshold: ' num2str(obj.Threshold)])
        end
    end
end