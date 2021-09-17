classdef SASweepTestSection < TestSection
    
    methods
        function obj = SASweepTestSection(name)
            obj@TestSection(name);
        end
        
        function ub = getUpperBound(~, data, startIndex, ~)
            [~, ub] = groupDataDiff(data.SA, 1, 1, startIndex);
        end
        
        function returnStruct = doStuffWithData(~, ~, data, lb, ub, ~, runOpts)
            % Get all the relevant data
            saData = data.SA(lb:ub);
            nfyData = data.NFY(lb:ub);
            mzData = data.MZ(lb:ub);
            fzData = data.FZ(lb:ub);
            
            % Apply scaling factors
            saDataScaled = saData*runOpts.XScalingFactor;
            nfyDataScaled = nfyData*runOpts.YScalingFactor;
            mzDataScaled = mzData*runOpts.YScalingFactor;
            
            % Convert to radians
            saDataScaledRad = deg2rad(saDataScaled);
            
            % Fit the data and get the coeffients and exit flags
            C0_nfy = [13, 0.2, 15, 1, 0, 0];
            C0_mz = [40, 0.08, 440, 1.2, 0, 0];
            [nfyC, nfyExitFlag] = fitPacejka(saDataScaledRad, nfyDataScaled, runOpts.PacejkaAlgorithm, runOpts.PacejkaMaxIterations, C0_nfy);
            [mzC, mzExitFlag] = fitPacejka(saDataScaledRad, mzDataScaled, runOpts.PacejkaAlgorithm, runOpts.PacejkaMaxIterations, C0_mz);
            
            % Take sample points
            saSampleVals = runOpts.SASampleVals;
            saSampleValsRad = deg2rad(saSampleVals);
            nfySamplePoints = pacejka(nfyC, saSampleValsRad);
            mzSamplePoints = pacejka(mzC, saSampleValsRad);
            
            % Include all the relevant info in the return array
            returnStruct.saData = saDataScaled;
            returnStruct.nfyData = nfyDataScaled;
            returnStruct.mzData = mzDataScaled;
            returnStruct.fzData = fzData;
            returnStruct.nfyC = nfyC;
            returnStruct.nfyExitFlag = nfyExitFlag;
            returnStruct.mzC = mzC;
            returnStruct.mzExitFlag = mzExitFlag;
            returnStruct.saSampleVals = saSampleVals;
            returnStruct.nfySamplePoints = nfySamplePoints;
            returnStruct.mzSamplePoints = mzSamplePoints;
        end
    end
end
