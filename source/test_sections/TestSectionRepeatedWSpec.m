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
                    new_indices = [parent_indices, i, j];
                    test = obj.NestedTests(j);
                    % Get the upper bound for this test
                    %disp(['Iteration #' num2str(i) ', Test #' num2str(j)]);
%                     disp(obj.NestedLowerBounds)
%                     disp(['obj: ' obj.Name ', test: ' test.Name])
                    ub_ij = test.getUpperBound(data, start_index, new_indices);
                    %disp(obj.NestedLowerBounds)
                    %disp(['[BEFORE] Test: ' obj.Name ' #' num2str(i) ' [' num2str(new_indices) '], nested test #' num2str(j) ', UB: ' num2str(ub_ij) ', lb(i): ' num2str(lb(i)) ', ub(i): ' num2str(ub(i))]);
                    
                    % Record the bounds for later
                    setNestedLB(obj, new_indices, start_index + 1);
                    setNestedUB(obj, new_indices, ub_ij);
                    
                    %disp(['Found where its set, lb is: ' num2str(start_index + 1)]);
                    
                    if isa(obj, 'CamberVaryingTestSection') && i == 1 && j == 1
                        %disp(['Set bound at 1, 1: ' num2str(start_index + 1)])
                        %disp('Getting bound:')
                        %disp(getNestedLB(obj, new_indices))
                    end
                    
                    if isa(obj, 'PressureVaryingTestSection')
                        %disp(['Indices::::: [' num2str(new_indices) ']'])
                    end
                    
                    obj.NestedTests(j) = test;
                    
                    start_index = ub_ij; % Start index for next nested test
                    disp(['Test: ' obj.Name ' #' num2str(i) ', nested test #' num2str(j) ', UB: ' num2str(ub_ij) ', lb(i): ' num2str(lb(i)) ', ub(i): ' num2str(ub(i))]);
                end
                if ub_ij >= ub(i)
                    ub_ij = ub(i);
                    setNestedUB(obj, new_indices, ub_ij);
                elseif ub_ij <= ub(i)
                    error(['Matt error: UB of nested test (' num2str(ub_ij) ') is less than UB of parent test (' num2str(ub(i)) ')'])
                end
            end
            ub = ub_ij; % Return the last upper bound
        end
        
        function return_struct = doStuffWithData(obj, app, data, ~, ~, parent_indices, runOptions)
            n_times = obj.BFinder.getN();
            n_tests = length(obj.NestedTests);
            for i = 1:n_times
                for j = 1:n_tests
                    new_indices = [parent_indices, i, j];
                    obj.NestedTests(j).doStuffWithData( ...
                        app, ...
                        data, ...
                        getNestedLB(obj, new_indices), ...
                        getNestedUB(obj, new_indices), ...
                        new_indices, ...
                        runOptions);
                end
            end
            return_struct = struct();
        end
    end
end
