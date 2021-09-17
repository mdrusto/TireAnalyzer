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
        
        function ub = getUpperBound(obj, app, data, startIndex, parentIndices)
            nTests = length(obj.NestedTests);
            
            for i = 1:nTests
                newIndices = [parentIndices i];
                
                % Get the upper bound for this test
                ub_i = obj.NestedTests(i).getUpperBound(obj, app, data, startIndex, newIndices);

                % Record the bounds for later
                setNestedLB(obj, newIndices, startIndex + 1);
                setNestedUB(obj, newIndices, ub_ij);

                startIndex = ub_i + 1; % Start index for next nested test
            end
            ub = ub_i; % Return the last upper bound
        end
        
        function doStuffWithData(obj, app, data, ~, ~, parentIndices, runOptions)
            nTests = length(obj.NestedTests);
            for i = 1:nTests
                newIndices = [parentIndices, i];
                obj.NestedTests(i).doStuffWithData( ...
                    app, ...
                    data, ...
                    getNestedLB(obj, newIndices), ...
                    getNestedUB(obj, newIndices), ...
                    newIndices, ...
                    runOptions);
            end
        end
        
        function lb = getNestedLB(obj, indices)
            boundSize = size(obj.NestedLowerBounds);
            if length(indices) > length(boundSize) || ...
                    (length(indices) == length(boundSize) && any(indices > boundSize))
                error(['Matt error: indices outside of bounds. Indices: ' num2str(indices) ', size of bounds: ' num2str(boundSize)]);
            end
            indicesCell = num2cell(indices);
            lb = obj.NestedLowerBounds(indicesCell{:});
            if isempty(lb)
                error(['Matt error: Empty LB at [' num2str(indices) ']'])
            end
            if ~isscalar(lb)
                error(['Matt error: need more specific indices. Given: [' num2str(indicesCell{:}) '], need ' num2str(ndims(obj.NestedLowerBounds)) '. Result: ' num2str(lb)])
            end
        end
        
        function ub = getNestedUB(obj, indices)
            boundSize = size(obj.NestedUpperBounds);
            if length(indices) > length(boundSize) || ...
                    (length(indices) == length(boundSize) && any(indices > boundSize))
                error(['Matt error: indices outside of bounds. Indices: ' num2str(indices{:}) ', size of bounds: ' num2str(boundSize)]);
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
            indices = num2cell(indices);
            obj.NestedUpperBounds(indices{:}) = value;
        end
    end
end

