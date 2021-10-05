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
        
        function ub = getUpperBound(obj, data, startIndex, parentIndices)
            nTests = length(obj.NestedTests);
            
            for i = 1:obj.nTimes % Iterate over the number of repeated test groups
                for j = 1:nTests % Iterate inside each repeated group, for each individual test
                    newIndices = [parentIndices, i, j];
                    
                    % Get the upper bound for this test
                    %disp(['Iteration #' num2str(i) ', Test #' num2str(j)]);
                    ub_ij = obj.NestedTests(j).getUpperBound(data, startIndex);
                    
                    % Record the bounds for later
                    setNestedLB(obj, newIndices, startIndex + 1);
                    setNestedUB(obj, newIndices, ub_ij);
                    
                    startIndex = ub_ij + 1; % Start index for next nested test
                    disp(['Test: ' obj.Name ' #' num2str(i) ', UB: ' num2str(ub_ij)]);
                end
            end
            ub = ub_ij; % Return the last upper bound
        end
        
        function doStuffWithData(obj, app, data, ~, ~, parentIndices, runOptions)
            [n_times, n_tests] = size(obj.NestedLowerBounds);
            for i = 1:n_times
                for j = 1:n_tests
                    obj.NestedTests(j).doStuffWithData( ...
                        app, ...
                        data, ...
                        obj.NestedLowerBounds(parentIndices, i, j), ...
                        obj.NestedUpperBounds(parentIndices, i, j), ...
                        runOptions);
                end
            end
        end
    end
end

