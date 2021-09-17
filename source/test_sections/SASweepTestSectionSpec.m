classdef SASweepTestSectionSpec < SASweepTestSection
    
    properties
        FinalVal
        Threshold
    end
    
    methods
        function obj = SASweepTestSectionSpec(name, finalVal, threshold)
            obj@SASweepTestSection(name);
            obj.FinalVal = finalVal;
            obj.Threshold = threshold;
        end
        
        function ub = getUpperBound(obj, data, startIndex, ~)
            nCrossings = 0;
            withinThreshold = false;
            for i = (startIndex + 1):length(data.SA) % Loop over remaining data
                if abs(data.SA(i) - obj.FinalVal) < obj.Threshold
                    if ~withinThreshold
                        % Update the counter and flag
                        nCrossings = nCrossings + 1;
                        if nCrossings == 3
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
            error(['Matt error: no upper bound found. Value: ' num2str(obj.FinalVal) ', threshold: ' num2str(obj.Threshold)])
        end % End function   
    end
end % End class