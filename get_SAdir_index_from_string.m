function [SAdir_index] = get_SAdir_index_from_string(string)
    switch string
        case '+'
            SAdir_index = 1;
        case '-'
            SAdir_index = 2;
    end
end

