classdef TestSectionRepeatedWSpec < TestSectionNested
    % Test section with repeated nested tests inside it
    
    properties
        VarName char % Char array
        BFinder BoundsFinder
    end
    
    methods
        function obj = TestSectionRepeatedWSpec(name, varName, bFinder, nestedTests)
            obj@TestSectionNested(name, nestedTests);
            obj.VarName = varName;
            obj.BFinder = bFinder;
        end
        
        function ub = getUpperBound(obj, data, startIndex, parent_indices)
            nTests = length(obj.NestedTests);
            
            [lb, ub] = obj.BFinder.getBounds(data.(obj.VarName), startIndex);
            
            for i = 1:length(lb) % Iterate over the number of repeated test groups
                startIndex = lb(i); % Force this iteration to start at the start of the group
                
                for j = 1:nTests % Iterate inside each repeated group, for each individual test
                    newIndices = [parent_indices, i, j];
                    test = obj.NestedTests(j);
                    % Get the upper bound for this test
                    ub_ij = test.getUpperBound(data, startIndex, newIndices);
                    
                    % Record the bounds for later
                    setNestedLB(obj, newIndices, startIndex + 1);
                    setNestedUB(obj, newIndices, ub_ij);
                    
                    obj.NestedTests(j) = test;
                    
                    startIndex = ub_ij; % Start index for next nested test
                    %disp(['Test: ' obj.Name ' #' num2str(i) ', nested test #' num2str(j) ', UB: ' num2str(ub_ij) ', lb(i): ' num2str(lb(i)) ', ub(i): ' num2str(ub(i))]);
                end
                if ub_ij >= ub(i)
                    ub_ij = ub(i);
                    setNestedUB(obj, newIndices, ub_ij);
                elseif ub_ij <= ub(i)
                    error(['Matt error: UB of nested test (' num2str(ub_ij) ') is less than UB of parent test (' num2str(ub(i)) ')'])
                end
            end
            ub = ub_ij; % Return the last upper bound
        end
        
        function returnStruct = doStuffWithData(obj, app, data, ~, ~, parentIndices, runOptions)
            nTimes = obj.BFinder.getN();
            nTests = length(obj.NestedTests);
            for i = 1:nTimes
                for j = 1:nTests
                    newIndices = [parentIndices, i, j];
                    obj.NestedTests(j).doStuffWithData( ...
                        app, ...
                        data, ...
                        getNestedLB(obj, newIndices), ...
                        getNestedUB(obj, newIndices), ...
                        newIndices, ...
                        runOptions);
                end
            end
            returnStruct = struct();
        end
    end
end
