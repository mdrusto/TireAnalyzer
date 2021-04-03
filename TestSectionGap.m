classdef TestSectionGap < TestSection
    
    properties
        VarName
        Value
        Threshold
    end
    
    methods
        function obj = TestSectionGap(name, varName, value, threshold)
            obj@TestSection(name);
            obj.VarName = varName;
            obj.Value = value;
            obj.Threshold = threshold;
        end
        
        function ub = getUpperBound(obj, data, start_index, ~)
            data_sel = data.(obj.VarName);
            for i = (start_index + 1):length(data_sel)
                if abs(data_sel(i) - obj.Value) < obj.Threshold
                    ub = i - 1;
                    disp(['Test: ' obj.Name ', UB: ' num2str(ub)]);
                    return
                end
            end
            error(['Matt error: no upper bound found. Value: ' num2str(obj.Value) ', threshold: ' num2str(obj.Threshold)])
        end
    end
end