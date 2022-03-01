classdef CamberVaryingTestSection < TestSection
    
    methods

        % Constructor
        function obj = CamberVaryingTestSection(name, bFinder, children, exceptions)
            if nargin < 2
                bFinder = BoundsFinderN(1, 0);
            end
            if nargin < 3
                children = TestSection.empty;
            end
            if nargin < 4
                exceptions = TestSectionException.empty;
            end
            obj@TestSection(name, bFinder, "IA", children, exceptions);
        end
        
        function processingResults = processData(obj, app, ~, childrenResults, runOpts)
            nIncAngles = obj.BFinder.getN();
            nTests = length(obj.Children);
            nLoads = 0;
            nSASample = length(runOpts.SASampleVals);
            nLoadSample = length(runOpts.LoadSampleVals);
            iaOptions = zeros(nIncAngles, 1);

            % Make sure there is a LoadsTestSection inside this test section
            foundLoads = false;
            for j = 1:nTests
                test = obj.Children(j);
                if isa(test, 'LoadsTestSection')
                    foundLoads = true;
                    nLoads = test.BFinder.getN();
                    break;
                end
            end
            
            if ~foundLoads
                error('Matt error: no loads found in intermediate test section');
            end
            
            % Create all array variables
            saData = cell(nLoads, nIncAngles);
            fzData = cell(nLoads, nIncAngles);
            nfyData = cell(nLoads, nIncAngles);
            fyData = cell(nLoads, nIncAngles);
            mzData = cell(nLoads, nIncAngles);
            nfyC = zeros(6, nLoads, nIncAngles);
            mzC = zeros(6, nLoads, nIncAngles);
            nfyExitFlags = zeros(nLoads, nIncAngles);
            mzExitFlags = zeros(nLoads, nIncAngles);
            nfyLoadPolyCoeff = 0;
            mzLoadPolyCoeff = 0;
            nfyVals = zeros(nSASample, nLoadSample, nIncAngles);
            mzVals = zeros(nSASample, nLoadSample, nIncAngles);
            meanLoads = zeros(nLoads, nIncAngles);
            fzOptions = zeros(nLoads, 1);
            iaOptions = zeros(nLoads, 1);
            alpha_adj = cell(nIncAngles, 1);
            FY_adj = cell(nIncAngles, 1);
            MZ_adj = cell(nIncAngles, 1);
            cornerStiff_FY_adj = zeros(nLoads, nIncAngles);
            cornerStiff_MZ_adj = zeros(nLoads, nIncAngles);
            camberShiftFY = zeros(nLoads, nIncAngles);
            camberShiftMZ = zeros(nLoads, nIncAngles);
            fz_bar = zeros(nLoads, nIncAngles);
            maxNFY = zeros(nLoads, nIncAngles);
            
            % Iterate over the instances of this repeated test (so one iteration per IA value)
            for i = 1:nIncAngles

                % Iterate over the different tests inside one instance of this repeated test
                for j = 1:nTests

                    test = obj.Children(j);
                    childResults = childrenResults{j}(i);
                    
                    if isa(test, 'LoadsTestSection')
                        
                        % Insert each row into global array
                        saData(:, i) = childResults.saData;
                        fzData(:, i) = childResults.fzData;
                        nfyData(:, i) = childResults.nfyData;
                        fyData(:, i) = childResults.fyData;
                        mzData(:, i) = childResults.mzData;
                        nfySamplePoints(:, :, i) = childResults.nfySamplePoints;
                        mzSamplePoints(:, :, i) = childResults.mzSamplePoints;
                        nfyC(:, :, i) = childResults.nfyC;
                        mzC(:, :, i) = childResults.mzC;
                        nfyExitFlags(:, i) = childResults.nfyExitFlags;
                        mzExitFlags(:, i) = childResults.mzExitFlags;
                        nfyVals(:, :, i) = childResults.nfyVals;
                        mzVals(:, :, i) = childResults.mzVals;
                        meanLoads(:, i) = childResults.meanLoads;
                        fzOptions = childResults.fzOptions;
                        % Save the average value of all the inclination angle values
                        iaOptions(i) = mean(vertcat(childResults.iaData{:}));
                        
                        camberShiftFY(:, i) = childResults.camberShiftFY;
                        camberShiftMZ(:, i) = childResults.camberShiftMZ;

                        cornerStiff_FY_adj(:, i) = childResults.cornerStiff_FY_adj;
                        cornerStiff_MZ_adj(:, i) = childResults.cornerStiff_MZ_adj;

                        fz_bar(:, i) = childResults.fz_bar;
                        maxNFY(:, i) = childResults.maxNFY;
                        
                        % We don't actually know the number of load polynomial coefficients ahead of time so we set the size of the arrays here
                        nLoadCoeff = size(childResults.nfyLoadPolyCoeff, 1);
                        if i == 1
                            nfyLoadPolyCoeff = zeros(nLoadCoeff, nSASample, nIncAngles);
                            mzLoadPolyCoeff = zeros(nLoadCoeff, nSASample, nIncAngles);
                        end
                        nfyLoadPolyCoeff(:, :, i) = childResults.nfyLoadPolyCoeff;
                        mzLoadPolyCoeff(:, :, i) = childResults.mzLoadPolyCoeff;
                    end
                end
            end
            
            % Round camber values to whole numbers
            iaOptions = round(iaOptions);
            % Sort camber values and retrieve order for sorting the results
            [iaOptions, order] = sort(iaOptions);
            
            % Reorder each array based on order of camber values (reorder2DCellDim2 is a custom function)
            saData = saData(:, order);
            fzData = fzData(:, order);
            nfyData = nfyData(:, order);
            fyData = fyData(:, order);
            mzData = mzData(:, order);
            nfyC = nfyC(:, :, order);
            mzC = mzC(:, :, order);
            nfyExitFlags = nfyExitFlags(:, order);
            mzExitFlags = mzExitFlags(:, order);
            nfySamplePoints = nfySamplePoints(:, :, order);
            mzSamplePoints = mzSamplePoints(:, :, order);
            nfyVals = nfyVals(:, :, order);
            mzVals = mzVals(:, :, order);
            cornerStiff_FY_adj = cornerStiff_FY_adj(:, order);
            cornerStiff_MZ_adj = cornerStiff_MZ_adj(:, order);
            camberShiftFY = camberShiftFY(:, order);
            camberShiftMZ = camberShiftMZ(:, order);
            fz_bar = fz_bar(:, order);
            maxNFY = maxNFY(:, order);
            
            % First, calculate the camber stiffness for each load
            camberStiffnessFY = zeros(nLoads, 1);
            camberStiffnessMZ = zeros(nLoads, 1);
            
            % Get the camber stiffness for each load value
            for i = 1:nLoads
                % Slope of camber shifts line
                camberStiffnessFY(i) = (camberShiftFY(i, 2) - camberShiftFY(i, 1)) / (iaOptions(2) - iaOptions(1));
                camberStiffnessMZ(i) = (camberShiftMZ(i, 2) - camberShiftMZ(i, 1)) / (iaOptions(2) - iaOptions(1));
            end
            
            % Now, modify the similarity method values
            % First get the reference function values
            refSA = saData{5, 1};
            refFY = fyData{5, 1};
            refMZ = mzData{5, 1};
            % First loop: iterate over all inc angle values, so i is the 'inc angle index'
            for i = 1:nIncAngles

                % Second loop: iterate over all load values, so j is the 'load index'
                for j = 1:nLoads

                    % Set the adjusted variables to the reference function to start
                    alpha_adj{i}(:, j) = refSA;
                    FY_adj{i}(:, j) = refFY;
                    MZ_adj{i}(:, j) = refMZ;
                    
                    % Combining and reversing Eqns 4.16 to 4.18
                    if runOpts.SimilarityCamberShift
                        % Calculate the horizontal shift (Eqn 4.17)
                        S_Hy = (camberStiffnessFY(j) / cornerStiff_FY_adj(j, 1)) * iaOptions(i);
                        S_Hy_array = S_Hy * ones(length(alpha_adj{i}(:, j)), 1); % Array of the same value obtained above, so it can be added/subtracted
                        alpha_adj{i}(:, j) = alpha_adj{i}(:, j) - S_Hy_array; % Eqn 4.17
                        % Now, the aligning torque vertical shift (bottom of page 162) - Eqn 4.19
                        S_Vz = camberStiffnessMZ(j) * iaOptions(i) + cornerStiff_MZ_adj(j, 1) * S_Hy;
                        S_Vz_array = S_Vz * ones(length(alpha_adj{i}(:, j)), 1);
                        % Add vertical shift to aligning torque values
                        MZ_adj{i}(:, j) = MZ_adj{i}(:, j) + S_Vz_array;
                    end
                    if runOpts.SimilarityLoadAdjustment
                        alpha_adj{i}(:, j) = alpha_adj{i}(:, j) * (fz_bar(j, 1) / fz_bar(5, 1));
                        FY_adj{i}(:, j) = FY_adj{i}(:, j) * (fz_bar(j, 1) / fz_bar(5, 1));
                        MZ_adj{i}(:, j) = MZ_adj{i}(:, j) * (fz_bar(j, 1) / fz_bar(5, 1));
                    end
                    if runOpts.SimilarityStiffnessAdjustment
                        alpha_adj{i}(:, j) = alpha_adj{i}(:, j) * (cornerStiff_FY_adj(5, 1) / cornerStiff_FY_adj(j, 1));
                        MZ_adj{i}(:, j) = MZ_adj{i}(:, j) * (cornerStiff_FY_adj(5, 1) / cornerStiff_FY_adj(j, 1)) * (cornerStiff_MZ_adj(j, 1) / cornerStiff_MZ_adj(5, 1));
                    end
                    if runOpts.SimilarityCoFAdjustment
                        alpha_adj{i}(:, j) = alpha_adj{i}(:, j) * (maxNFY(j, 1) / maxNFY(5, 1));
                        FY_adj{i}(:, j) = FY_adj{i}(:, j) * (maxNFY(j, 1) / maxNFY(5, 1));
                        MZ_adj{i}(:, j) = MZ_adj{i}(:, j) * (maxNFY(j, 1) / maxNFY(5, 1));
                    end
                    
                end
            end
            
            % Save all relevant variables to app global variable so that they can be accessed in the app functions for plotting
            app.LatCamberLUTData.saData = saData;
            app.LatCamberLUTData.fzData = fzData;
            app.LatCamberLUTData.nfyData = nfyData;
            app.LatCamberLUTData.mzData = mzData;
            app.LatCamberLUTData.nfyC = nfyC;
            app.LatCamberLUTData.mzC = mzC;
            app.LatCamberLUTData.nfyExitFlags = nfyExitFlags;
            app.LatCamberLUTData.mzExitFlags = mzExitFlags;
            app.LatCamberLUTData.nfySamplePoints = nfySamplePoints;
            app.LatCamberLUTData.mzSamplePoints = mzSamplePoints;
            app.LatCamberLUTData.nfyLoadPolyCoeff = nfyLoadPolyCoeff;
            app.LatCamberLUTData.mzLoadPolyCoeff = mzLoadPolyCoeff;
            app.LatCamberLUTData.nfyVals = nfyVals;
            app.LatCamberLUTData.mzVals = mzVals;
            app.LatCamberLUTData.meanLoads = meanLoads;
            app.LatCamberLUTData.fzOptions = fzOptions;
            app.LatCamberLUTData.iaOptions = iaOptions;
            app.LatCamberLUTData.alpha_adj = alpha_adj;
            app.LatCamberLUTData.FY_adj = FY_adj;
            app.LatCamberLUTData.MZ_adj = MZ_adj;
            
            % Make the return struct an empty struct because we don't actually use it (this is a top-level test section)
            processingResults = struct();
        end
    end
end
