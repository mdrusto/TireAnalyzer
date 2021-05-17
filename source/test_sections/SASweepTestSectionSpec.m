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
        
        function ub = getUpperBound(obj, data, start_index, ~)
            n_crossings = 0;
            within_threshold = false;
            for i = (start_index + 1):length(data.SA) % Loop over remaining data
                if abs(data.SA(i) - obj.FinalVal) < obj.Threshold
                    if ~within_threshold
                        % Update the counter and flag
                        n_crossings = n_crossings + 1;
                        if n_crossings == 3
                            ub = i;
                            return;
                        end
                        % Update the flag if this isn't the final crossing
                        within_threshold = true;
                    end % Do nothing if already inside threshold
                else
                    if within_threshold
                        % Reset the flag
                        within_threshold = false;
                    end
                end
            end % End for-loop
            error(['Matt error: no upper bound found. Value: ' num2str(obj.FinalVal) ', threshold: ' num2str(obj.Threshold)])
        end % End function   
    end
end % End class