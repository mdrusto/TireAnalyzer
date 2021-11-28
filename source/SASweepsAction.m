classdef SASweepsAction < TestSectionAction
    
    methods
        
        function obj = SASweepsAction
            obj@TestSectionAction({'SA', 'NFY', 'FZ'});
        end
        
        function whenRun(obj, data)
            
        end
    end
end
    