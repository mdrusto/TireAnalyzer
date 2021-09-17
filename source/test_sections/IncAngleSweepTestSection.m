classdef IncAngleSweepTestSection < TestSection
    
    methods
        function obj = IncAngleSweepTestSection(name)
            obj@TestSection(name);
        end
        
        function ub = getUpperBound(~, data, startIndex, ~)
            nCrossings = 0;
            withinThreshold = false;
            for i = (startIndex + 1):length(data.IA) % Loop over remaining data
                if abs(data.IA(i)) < 0.1
                    if ~withinThreshold
                        % Update the counter and flag
                        nCrossings = nCrossings + 1;
                        if nCrossings == 2
                            ub = i;
                            return;
                        end
                        % Update the flag if this isn't the final crossing
                        withinThreshold = true;
                    end % Do nothing if already inside threshold
                else
                    if withinThreshold
                        % Reset the flag
                        withinThreshold = false;
                    end
                end
            end % End for-loop
            error('Matt error: no upper bound found')
        end
    end
end