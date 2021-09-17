classdef BreakInTestSection < TestSection
    
    properties
        NCrossings
    end
    
    methods
        function obj = BreakInTestSection(name, nCrossings)
            obj@TestSection(name);
            obj.NCrossings = nCrossings;
        end
        
        function ub = getUpperBound(obj, data, startIndex, ~)
            nCrossings = 0;
            nPoints = 0;
            withinThreshold = false;
            for i = (startIndex + 1):length(data.IA) % Loop over remaining data
                if abs(data.IA(i)) < 0.5
                    if ~withinThreshold
                        % Only set the flag if this is the 10th successive point in a row
                        if nPoints == 10
                            % Update the counter and flag
                            nCrossings = nCrossings + 1;
                            if nCrossings == obj.NCrossings
                                ub = i - 10;
                                return;
                            end
                            nPoints = 0;
                            % Update the flag if this isn't the final crossing
                            withinThreshold = true;
                        else
                            nPoints = nPoints + 1;
                        end
                    end % Do nothing if already inside threshold
                else
                    if withinThreshold
                        if nPoints == 10
                            % Reset the flag
                            withinThreshold = false;
                            nPoints = 0;
                        else
                            nPoints = nPoints + 1;
                        end
                    end
                end
            end % End for-loop
            error('Matt error: no upper bound found')
        end
    end
end

