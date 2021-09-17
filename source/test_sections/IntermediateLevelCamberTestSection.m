classdef IntermediateLevelCamberTestSection < TestSectionRepeatedWSpec
    
    methods
        function obj = IntermediateLevelCamberTestSection(name, varName, bFinder, tests)
            obj@TestSectionRepeatedWSpec(name, varName, bFinder, tests);
        end
        
        function return_struct = doStuffWithData(obj, app, data, ~, ~, parentIndices, run_opts)
            nTimes = obj.BFinder.getN();
            nTests = length(obj.NestedTests);
            nLoads = 0;
            nSASample = length(run_opts.SASampleVals);
            nLoadSample = length(run_opts.LoadSampleVals);
            foundLoads = false;
            for j = 1:nTests
                test = obj.NestedTests(j);
                if isa(test, 'LoadsTestSection')
                    foundLoads = true;
                    nLoads = test.BFinder.getN();
                    break;
                end
            end
            
            if ~foundLoads
                error('Matt error: no loads found in intermediate test section');
            end
            
            saData = cell(nLoads, nTimes);
            fzData = cell(nLoads, nTimes);
            nfyData = cell(nLoads, nTimes);
            mzData = cell(nLoads, nTimes);
            
            nfyC = zeros(6, nLoads, nTimes);
            mzC = zeros(6, nLoads, nTimes);
            nfyExitFlags = zeros(nLoads, nTimes);
            mzExitFlags = zeros(nLoads, nTimes);
            nfySamplePoints = zeros(nSASample, nLoads, nTimes);
            mzSamplePoints = zeros(nSASample, nLoads, nTimes);
            nfyLoadPolyCoeff = 0;
            mzLoadPolyCoeff = 0;
            nfyVals = zeros(nSASample, nLoadSample, nTimes);
            mzVals = zeros(nSASample, nLoadSample, nTimes);
            meanLoads = zeros(nLoads, nTimes);
            fzOptions = 0;
            iaOptions = zeros(nTimes, 1);
            
            for i = 1:nTimes
                %disp(['Camber #' num2str(i)])
                for j = 1:nTests
                    newIndices = [parentIndices, i, j];
                    test = obj.NestedTests(j);
                    
                    nestedLB = getNestedLB(obj, newIndices);
                    nestedUB = getNestedUB(obj, newIndices);
                    
                    retStruct = test.doStuffWithData( ...
                        app, ...
                        data, ...
                        nestedLB, ...
                        nestedUB, ...
                        newIndices, ...
                        run_opts);
                    if isa(obj.NestedTests(j), 'LoadsTestSection')
                        saData = assign1DInto2DCell(saData, retStruct.sa_data, i);
                        fzData = assign1DInto2DCell(fzData, retStruct.fz_data, i);
                        nfyData = assign1DInto2DCell(nfyData, retStruct.nfy_data, i);
                        mzData = assign1DInto2DCell(mzData, retStruct.mz_data, i);
                        nfySamplePoints(:, :, i) = retStruct.nfy_sample_points;
                        mzSamplePoints(:, :, i) = retStruct.mz_sample_points;
                        nfyC(:, :, i) = retStruct.nfy_C;
                        mzC(:, :, i) = retStruct.mz_C;
                        nfyExitFlags(:, i) = retStruct.nfy_exitflags;
                        mzExitFlags(:, i) = retStruct.mz_exitflags;
                        
                        retNfyLoadPolyCoeff = retStruct.nfyLoadPolyCoeff;
                        nLoadCoeff = size(retNfyLoadPolyCoeff, 1);
                        if i == 1
                            nfyLoadPolyCoeff = zeros(nLoadCoeff, nSASample, nTimes);
                            mzLoadPolyCoeff = zeros(nLoadCoeff, nSASample, nTimes);
                        end
                        nfyLoadPolyCoeff(:, :, i) = retNfyLoadPolyCoeff; %#ok<AGROW>
                        mzLoadPolyCoeff(:, :, i) = retStruct.mzLoadPolyCoeff; %#ok<AGROW>
                        
                        nfyVals(:, :, i) = retStruct.nfyVals;
                        mzVals(:, :, i) = retStruct.mzVals;
                        meanLoads(:, i) = retStruct.meanLoads;
                        fzOptions = retStruct.fzOptions;
                        
                        iaOptions(i) = mean(data.IA(nestedLB:nestedUB));
                    end
                end
            end
            
            iaOptions = round(iaOptions);
            [iaOptions, order] = sort(iaOptions);
            return_struct.ia_options = iaOptions;

            saData = reorder2DCellDim2(saData, order);
            fzData = reorder2DCellDim2(fzData, order);
            nfyData = reorder2DCellDim2(nfyData, order);
            mzData = reorder2DCellDim2(mzData, order);
            nfySamplePoints = nfySamplePoints(:, :, order);
            mzSamplePoints = mzSamplePoints(:, :, order);
            nfyC = nfyC(:, :, order);
            mzC = mzC(:, :, order);
            nfyExitFlags = nfyExitFlags(:, order);
            mzExitFlags = mzExitFlags(:, order);
            nfyVals = nfyVals(:, :, order);
            mzVals = mzVals(:, :, order);
            
            return_struct.sa_data = saData;
            return_struct.fz_data = fzData;
            return_struct.nfy_data = nfyData;
            return_struct.mz_data = mzData;
            return_struct.nfy_C = nfyC;
            return_struct.mz_C = mzC;
            return_struct.nfy_exitflags = nfyExitFlags;
            return_struct.mz_exitflags = mzExitFlags;
            return_struct.nfy_sample_points = nfySamplePoints;
            return_struct.mz_sample_points = mzSamplePoints;
            return_struct.nfy_load_poly_coeff = nfyLoadPolyCoeff;
            return_struct.mz_load_poly_coeff = mzLoadPolyCoeff;
            return_struct.nfy_vals = nfyVals;
            return_struct.mz_vals = mzVals;
            return_struct.mean_loads = meanLoads;
            return_struct.fz_options = fzOptions;
            return_struct.ia_options = iaOptions;
        end
    end
end