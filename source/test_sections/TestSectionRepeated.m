classdef TestSectionRepeated < TestSectionNested
    % Test section with repeated nested tests inside it
    
    properties
        FromFile = false;
    end
    
    methods
        function obj = TestSectionRepeated(name, nTimes, nestedTests)
            obj@TestSectionNested(name, nestedTests);
            obj.nTimes = nTimes;
        end
        
        function ub = getUpperBound(obj, data, start_index, parent_indices)
            n_tests = length(obj.NestedTests);
            
            for i = 1:obj.nTimes % Iterate over the number of repeated test groups
                for j = 1:n_tests % Iterate inside each repeated group, for each individual test
                    new_indices = [parent_indices, i, j];
                    
                    % Get the upper bound for this test
                    %disp(['Iteration #' num2str(i) ', Test #' num2str(j)]);
                    ub_ij = obj.NestedTests(j).getUpperBound(data, start_index);
                    
                    % Record the bounds for later
                    setNestedLB(obj, new_indices, start_index + 1);
                    setNestedUB(obj, new_indices, ub_ij);
                    
                    start_index = ub_ij + 1; % Start index for next nested test
                    disp(['Test: ' obj.Name ' #' num2str(i) ', UB: ' num2str(ub_ij)]);
                end
            end
            ub = ub_ij; % Return the last upper bound
        end
        
        function doStuffWithData(obj, app, data, ~, ~, parent_indices, runOptions)
            [n_times, n_tests] = size(obj.NestedLowerBounds);
            for i = 1:n_times
                for j = 1:n_tests
                    obj.NestedTests(j).doStuffWithData( ...
                        app, ...
                        data, ...
                        obj.NestedLowerBounds(parent_indices, i, j), ...
                        obj.NestedUpperBounds(parent_indices, i, j), ...
                        runOptions);
                end
            end
        end
    end
end

