classdef TestSectionNested < TestSection
    
    properties
        NestedTests TestSection
        NestedLowerBounds
        NestedUpperBounds
    end
    
    methods
        function obj = TestSectionNested(name, nestedTests)
            obj@TestSection(name);
            obj.NestedTests = nestedTests;
        end
        
        function ub = getUpperBound(obj, data, start_index, parent_indices)
            n_tests = length(obj.NestedTests);
            
            for i = 1:n_tests

                % Get the upper bound for this test
                ub_i = obj.NestedTests(i).getUpperBound(obj, data, start_index);

                % Record the bounds for later
                obj.NestedLowerBounds(parent_indices, i) = start_index;
                obj.NestedUpperBounds(parent_indices, i) = ub_i;

                start_index = ub_i + 1; % Start index for next nested test
            end
            ub = ub_i; % Return the last upper bound
        end
        
        function doStuffWithData(obj, app, data, ~, ~, parent_indices, runOptions)
            n_tests = length(obj.NestedTests);
            for i = 1:n_tests
                obj.NestedTests(i).doStuffWithData( ...
                    app, ...
                    data, ...
                    obj.NestedLowerBounds([parent_indices i]), ...
                    obj.NestedUpperBounds([parent_indices i]), ...
                    [parent_indices i], ...
                    runOptions);
            end
        end
    end
end

