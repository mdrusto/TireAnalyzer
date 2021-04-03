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
        
        function ub = getUpperBound(obj, data, start_index, parent_indices)
            n_tests = length(obj.NestedTests);
            
            [lb, ub] = obj.BFinder.getBounds(data.(obj.VarName), start_index);
            
            for i = 1:length(lb) % Iterate over the number of repeated test groups
                start_index = lb(i); % Force this iteration to start at the start of the group
                
                for j = 1:n_tests % Iterate inside each repeated group, for each individual test
                    
                    % Get the upper bound for this test
                    %disp(['Iteration #' num2str(i) ', Test #' num2str(j)]);
                    ub_ij = obj.NestedTests(j).getUpperBound(data, start_index, [parent_indices i]);
                    
                    % Record the bounds for later
                    obj.NestedLowerBounds(parent_indices, i, j) = start_index + 1;
                    obj.NestedUpperBounds(parent_indices, i, j) = ub_ij;
                    
                    start_index = ub_ij; % Start index for next nested test
                    disp(['Test: ' obj.Name ' #' num2str(i) ', nested test #' num2str(j) ', UB: ' num2str(ub_ij) ', lb(i): ' num2str(lb(i)) ', ub(i): ' num2str(ub(i))]);
                end
                if ub_ij >= ub(i)
                    ub_ij = ub(i);
                    obj.NestedUpperBounds(parent_indices, i, j) = ub_ij;
                elseif ub_ij <= ub(i)
                    error(['Matt error: UB of nested test (' num2str(ub_ij) ') is less than UB of parent test (' num2str(ub(i)) ')'])
                end
            end
            ub = ub_ij; % Return the last upper bound
        end
        
        function doStuffWithData(obj, app, data, ~, ~, parent_indices, runOptions)
            n_prev_ind = length(parent_indices);
            [n_times, n_tests] = size(obj.NestedLowerBounds, n_prev_ind + 1, n_prev_ind + 2);
            for i = 1:n_times
                for j = 1:n_tests
                    obj.NestedTests(j).doStuffWithData( ...
                        app, ...
                        data, ...
                        obj.NestedLowerBounds(parent_indices, i, j), ...
                        obj.NestedUpperBounds(parent_indices, i, j), ...
                        [parent_indices i], ...
                        runOptions);
                end
            end
        end
    end
end
