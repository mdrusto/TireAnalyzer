classdef TestSection < handle & matlab.mixin.Heterogeneous % Inheriting from this lets me use property validation
    
    properties
        Name char
        BFinder BoundsFinder
        VarName char
        Children TestSection
        FormatExceptions TestSectionException
    end
    
    methods
        function obj = TestSection(name, bFinder, varName, children, exceptions)
            obj.Name = name;
            obj.BFinder = bFinder;
            obj.VarName = varName;
            if nargin >= 4
                obj.Children = children;
            else
                obj.Children = TestSection.empty;
            end
            if nargin >= 5
                obj.FormatExceptions = exceptions;
            else
                obj.FormatExceptions = TestSectionException.empty;
            end
        end
        
        function [lb, ub] = getBounds(obj, data, startIndex)
            [lb, ub] = obj.BFinder.getBounds(data.(obj.VarName), startIndex);
        end
        
        % Process data for one group
        function processingResults = processData(obj, app, data, childrenResults, runOptions) %#ok<INUSD>
            processingResults = struct();
        end
    end
end
