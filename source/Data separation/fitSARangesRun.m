function [index1, index2] = fitSARangesRun(SAVals, startI, endI)

    index1 = -1; % Transition to decreasing sweep
    index2 = -1; % Transition to second increasing sweep

    consecutiveDir = 0;

    lastSAValue = 0;
    
    % 1: Inside first increasing sweep
    % 2: Inside decreasing sweep
    saState = 0;

    for saIndex = startI:endI
        saValue = SAVals(saIndex);
        switch saState
            case 0
                if saValue < lastSAValue
                    if consecutiveDir == 10
                        % Record this index, change the state and reset the counter
                        index1 = saIndex;
                        saState = 1;
                        consecutiveDir = 0;
                    else
                        consecutiveDir = consecutiveDir + 1;
                    end
                else
                    % Reset the counter
                    consecutiveDir = 0;
                end
            case 1
                if saValue > lastSAValue
                    if consecutiveDir == 10
                        % Record this index, change the state and reset the counter
                        index2 = saIndex;
                        return;
                    else
                        consecutiveDir = consecutiveDir + 1;
                    end
                else
                    % Reset the counter
                    consecutiveDir = 0;
                end
        end
        lastSAValue = saValue;
    end
    
    if index1 == -1 || index2 == -1
        error('Matt error: different SA sweep format found than expected')
    end
end