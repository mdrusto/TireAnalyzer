classdef TestSectionNested < TestSection
    
    properties
        NestedTests TestSection
        NestedLowerBounds double
        NestedUpperBounds double
    end
    
    methods
        function obj = TestSectionNested(name, nestedTests)
            obj@TestSection(name);
            obj.NestedTests = nestedTests;
        end
        
        function ub = getUpperBound(obj, app, data, start_index, parent_indices)
            n_tests = length(obj.NestedTests);
            
            for i = 1:n_tests
                new_indices = [parent_indices i];
                
                % Get the upper bound for this test
                ub_i = obj.NestedTests(i).getUpperBound(obj, app, data, start_index, new_indices);

                % Record the bounds for later
                setNestedLB(obj, new_indices, start_index + 1);
                setNestedUB(obj, new_indices, ub_ij);

                start_index = ub_i + 1; % Start index for next nested test
            end
            ub = ub_i; % Return the last upper bound
        end
        
        function doStuffWithData(obj, app, data, ~, ~, parent_indices, runOptions)
            n_tests = length(obj.NestedTests);
            for i = 1:n_tests
                new_indices = [parent_indices, i];
                obj.NestedTests(i).doStuffWithData( ...
                    app, ...
                    data, ...
                    getNestedLB(obj, new_indices), ...
                    getNestedUB(obj, new_indices), ...
                    new_indices, ...
                    runOptions);
            end
        end
        
        function lb = getNestedLB(obj, indices)
            bound_size = size(obj.NestedLowerBounds);
            if length(indices) > length(bound_size) || ...
                    (length(indices) == length(bound_size) && any(indices > bound_size))
                error(['Matt error: indices outside of bounds. Indices: ' num2str(indices) ', size of bounds: ' num2str(bound_size)]);
            end
            %indices
            indices_cell = num2cell(indices);
            lb = obj.NestedLowerBounds(indices_cell{:});
            if isempty(lb)
                error(['Matt error: Empty LB at [' num2str(indices) ']'])
            end
            if ~isscalar(lb)
                error(['Matt error: need more specific indices. Given: [' num2str(indices_cell{:}) '], need ' num2str(ndims(obj.NestedLowerBounds)) '. Result: ' num2str(lb)])
            end
        end
        
        function ub = getNestedUB(obj, indices)
            bound_size = size(obj.NestedUpperBounds);
            if length(indices) > length(bound_size) || ...
                    (length(indices) == length(bound_size) && any(indices > bound_size))
                error(['Matt error: indices outside of bounds. Indices: ' num2str(indices{:}) ', size of bounds: ' num2str(bound_size)]);
            end
            indices = num2cell(indices);
            ub = obj.NestedUpperBounds(indices{:});
            if isempty(ub)
                error(['Matt error: Empty UB at [' num2str(indices) ']'])
            end
            if ~isscalar(ub)
                error(['Matt error: need more specific indices. Given: [' num2str(indices) '], need ' num2str(ndims(obj.NestedUpperBounds))])
            end
        end
        
        function setNestedLB(obj, indices, value)
            if ~isscalar(value)
                error(['Matt error: non-scalar argument: ' string(value)])
            end
            indices = num2cell(indices);
            obj.NestedLowerBounds(indices{:}) = value;
        end
        
        function setNestedUB(obj, indices, value)
            if ~isscalar(value)
                error(['Matt error: non-scalar argument: ' string(value)])
            end
            %if isempty(obj.NestedUpperBounds) 
            %    disp('EMPTY')
            %    obj.NestedLowerBounds = cell(1);
            %end
            indices = num2cell(indices);
            obj.NestedUpperBounds(indices{:}) = value;
        end
    end
end

