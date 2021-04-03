classdef IncAngleSweepTestSection < TestSection
    
    methods
        function obj = IncAngleSweepTestSection(name)
            obj@TestSection(name);
        end
        
        function ub = getUpperBound(~, data, start_index)
            n_crossings = 0;
            within_threshold = false;
            for i = (start_index + 1):length(data.IA) % Loop over remaining data
                if abs(data.IA(i)) < 0.1
                    if ~within_threshold
                        % Update the counter and flag
                        n_crossings = n_crossings + 1;
                        if n_crossings == 2
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
            error('Matt error: no upper bound found')
        end
    end
end