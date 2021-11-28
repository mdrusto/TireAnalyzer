classdef IncAngleSweepTestSection < TestSection
    
    methods
        function obj = IncAngleSweepTestSection(name, children, exceptions)
            if nargin < 2
                children = TestSection.empty;
            end
            if nargin < 3
                exceptions = TestSectionException.empty;
            end
            obj@TestSection(name, BoundsFinderN(1, 0), [], children, exceptions);
        end
        
        function [lb, ub] = getBounds(~, data, startIndex)
            lb = startIndex + 1;
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