function fz_index = get_fz_index_from_string(string)
    switch string
        case '200'
            fz_index = 3;
        case '400'
            fz_index = 5;
        case '600'
            fz_index = 2;
        case '800'
            fz_index = 1;
        case '1000'
            fz_index = 4;
    end
end

