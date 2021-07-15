% Script to display the data for a single tire data file

file_name = 'tire_data/B1320run5.mat';
runnum_cell = extractBetween(file_name, 'run', '.');
runnum = runnum_cell{1};

data = load(file_name);

len = length(data.ET);

offset = 34383;

figure
scatter((1:len)+offset, data.SA, 5);
title(['SA for run' num2str(runnum)]);

figure
scatter((1:len)+offset, data.FZ, 5);
title(['FZ for run' num2str(runnum)]);

figure
scatter((1:len)+offset, data.IA, 5);
title(['IA for run' num2str(runnum)]);

figure
scatter((1:len)+offset, data.P, 5);
title(['P for run' num2str(runnum)]);

figure
scatter((1:len)+offset, data.V, 5);
title(['V for run' num2str(runnum)]);
