classdef (Abstract) TestSectionAction
    
    properties
        DataVars
    end
    
    methods
        function obj = TestSectionAction(dataVars)
            obj.DataVars = dataVars;
        end
    end
    
    methods (Abstract)
        whenRun(~, ~)
    end
end