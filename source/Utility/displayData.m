% Script to display the data for a single tire data file

fileName = 'tire_data/B1051run3.mat';
runNumCell = extractBetween(fileName, 'run', '.');
runNum = runNumCell{1};

data = load(fileName);

len = length(data.ET);

offset = 0;

figure
scatter((1:len)+offset, data.SA, 5);
title("SA for run" + runNum);

figure
scatter((1:len)+offset, data.FZ, 5);
title("FZ for run" + runNum);

figure
scatter((1:len)+offset, data.IA, 5);
title("IA for run" + runNum);

figure
scatter((1:len)+offset, data.P, 5);
title("P for run" + runNum);

figure
scatter((1:len)+offset, data.V, 5);
title("V for run" + runNum);
