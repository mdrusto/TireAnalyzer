classdef BreakInTestSection < TestSection
    
    properties
        NCrossings
    end
    
    methods
        function obj = BreakInTestSection(name, nCrossings)
            obj@TestSection(name);
            obj.NCrossings = nCrossings;
        end
        
        function ub = getUpperBound(obj, data, start_index, ~)
            n_crossings = 0;
            n_points = 0;
            within_threshold = false;
            for i = (start_index + 1):length(data.IA) % Loop over remaining data
                if abs(data.IA(i)) < 0.5
                    if ~within_threshold
                        % Only set the flag if this is the 10th successive point in a row
                        if n_points == 10
                            % Update the counter and flag
                            n_crossings = n_crossings + 1;
                            if n_crossings == obj.NCrossings
                                ub = i - 10;
                                return;
                            end
                            n_points = 0;
                            % Update the flag if this isn't the final crossing
                            within_threshold = true;
                        else
                            n_points = n_points + 1;
                        end
                    end % Do nothing if already inside threshold
                else
                    if within_threshold
                        if n_points == 10
                            % Reset the flag
                            within_threshold = false;
                            n_points = 0;
                        else
                            n_points = n_points + 1;
                        end
                    end
                end
            end % End for-loop
            error('Matt error: no upper bound found')
        end
    end
end

