function start_index = find_start_index(ia_vals, round)
    counter = 0;
    start_again = false;
    n_data = length(ia_vals);
    %disp(strcat('Number of points: ', num2str(n_data)))
    %disp(strcat('Tire name: ', app.UsedTireData.tireid))

    % Iterate over all the data
    for i = 1:n_data

        % Check if abs value of point is less than 0.1
        if abs(app.UsedTireData.IA(i)) < 0.1
            counter = counter + 1;
        else % If not, reset the counter
            counter = 0;
        end

        % Outside of first flat zone?
        if abs(app.UsedTireData.IA(i)) > 0.1
            %disp('Exited first flat zone')
            start_again = true;
            counter = 0;
        end

        % Only if this is the 1000th point that's less than 0.1
        % AND if this is the second flat zone, not first
        if counter == 1000 && start_again
            start_index = i - 1000; % Where we started counting
            return;
        end

        if i == n_data
            error('Matt error: no start index found');
        end
    end
end

