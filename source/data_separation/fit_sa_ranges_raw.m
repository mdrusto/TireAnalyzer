function [index_1, index_2, index_3, index_4] = fit_sa_ranges_raw(SA_vals, start_i, end_i)

    index_1 = -1; % Start of first increasing sweep
    index_2 = -1; % Transition to decreasing sweep
    index_3 = -1; % Transition to second increasing sweep
    index_4 = -1; % End of second increasing sweep

    consecutive_dir = 0;

    last_sa_value = 0;

    % 0: Hasn't left 0
    % 1: Has but hasn't crossed again
    % 2: Crossed 0, inside first increasing sweep
    % 3: Inside decreasing sweep
    % 4: Inside second increasing sweep
    sa_state = 0;

    for sa_index = start_i:end_i
        sa_value = SA_vals(sa_index);
        switch sa_state
            case 0
                if abs(sa_value) > 1
                    sa_state = 1;
                end
            case 1
                if abs(sa_value) < 0.1
                    sa_state = 2;
                    index_1 = sa_index;
                end
            case 2
                if sa_value < last_sa_value
                    if consecutive_dir == 10
                        % Record this index, change the state and reset the counter
                        index_2 = sa_index;
                        sa_state = 3;
                        consecutive_dir = 0;
                    else
                        consecutive_dir = consecutive_dir + 1;
                    end
                else
                    % Reset the counter
                    consecutive_dir = 0;
                end
            case 3
                if sa_value > last_sa_value
                    if consecutive_dir == 10
                        % Record this index, change the state and reset the counter
                        index_3 = sa_index;
                        sa_state = 4;
                        consecutive_dir = 0;
                    else
                        consecutive_dir = consecutive_dir + 1;
                    end
                else
                    % Reset the counter
                    consecutive_dir = 0;
                end
            case 4
                if abs(sa_value) < 0.1
                    index_4 = sa_index;
                    break;
                end
        end
        last_sa_value = sa_value;
    end
    
    if index_1 == -1 || index_2 == -1 || index_3 == -1 || index_4 == -1
        error('Matt error: different SA sweep format found than expected')
    end
    
    %if p_counter == 2 && ia_counter == 2 && fz_counter == 2
    %    figure
    %    scatter(start_i:end_i, app.UsedTireData.SA(start_i:end_i), 5)
    %    hold on
    %    plot([index_1 index_1], [-15 15], 'magenta')
    %    plot([index_2 index_2], [-15 15], 'magenta')
    %    plot([index_3 index_3], [-15 15], 'magenta')
    %    plot([index_4 index_4], [-15 15], 'magenta')
    %end
end