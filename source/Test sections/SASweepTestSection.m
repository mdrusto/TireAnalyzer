classdef SASweepTestSection < TestSection
    
    methods
        function obj = SASweepTestSection(name, exceptions)
            if nargin < 2
                exceptions = TestSectionException.empty;
            end
            obj@TestSection(name, BoundsFinderN(1, 1), 'SA', TestSection.empty, exceptions);
        end
        
        function processingResults = processData(~, ~, data, ~, runOpts)
            
            % Apply scaling factors
            saDataScaled = data.SA*runOpts.XScalingFactor;
            nfyDataScaled = data.NFY*runOpts.YScalingFactor;
            mzDataScaled = data.MZ*runOpts.YScalingFactor;
            
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
            processingResults.saData = saDataScaled;
            processingResults.nfyData = nfyDataScaled;
            processingResults.mzData = mzDataScaled;
            processingResults.fzData = data.FZ;
            processingResults.pData = data.P;
            processingResults.iaData = data.IA;
            processingResults.nfyC = nfyC';
            processingResults.nfyExitFlag = nfyExitFlag;
            processingResults.mzC = mzC';
            processingResults.mzExitFlag = mzExitFlag;
            processingResults.saSampleVals = saSampleVals;
            processingResults.nfySamplePoints = nfySamplePoints;
            processingResults.mzSamplePoints = mzSamplePoints;
        end
    end
end
