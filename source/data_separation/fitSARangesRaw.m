function [index1, index2, index3, index4] = fitSARangesRaw(SAVals, startI, endI)

    index1 = -1; % Start of first increasing sweep
    index2 = -1; % Transition to decreasing sweep
    index3 = -1; % Transition to second increasing sweep
    index4 = -1; % End of second increasing sweep

    consecutiveDir = 0;

    lastSAValue = 0;

    % 0: Hasn't left 0
    % 1: Has but hasn't crossed again
    % 2: Crossed 0, inside first increasing sweep
    % 3: Inside decreasing sweep
    % 4: Inside second increasing sweep
    saState = 0;

    for saIndex = startI:endI
        saValue = SA_vals(saIndex);
        switch saState
            case 0
                if abs(saValue) > 1
                    saState = 1;
                end
            case 1
                if abs(saValue) < 0.1
                    saState = 2;
                    index1 = saIndex;
                end
            case 2
                if saValue < lastSAValue
                    if consecutiveDir == 10
                        % Record this index, change the state and reset the counter
                        index2 = saIndex;
                        saState = 3;
                        consecutiveDir = 0;
                    else
                        consecutiveDir = consecutiveDir + 1;
                    end
                else
                    % Reset the counter
                    consecutiveDir = 0;
                end
            case 3
                if saValue > lastSAValue
                    if consecutiveDir == 10
                        % Record this index, change the state and reset the counter
                        index3 = saIndex;
                        saState = 4;
                        consecutiveDir = 0;
                    else
                        consecutiveDir = consecutiveDir + 1;
                    end
                else
                    % Reset the counter
                    consecutiveDir = 0;
                end
            case 4
                if abs(saValue) < 0.1
                    index4 = saIndex;
                    break;
                end
        end
        lastSAValue = saValue;
    end
    
    if index1 == -1 || index2 == -1 || index3 == -1 || index4 == -1
        error('Matt error: different SA sweep format found than expected')
    end
end