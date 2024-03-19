function diffTopkAnalyze_multi(path, fileConfig, actParam, repTimes, networkStru, bmName, thresholdArr, automode)
    spsMetric = {'alphaTarantula','alphaOchiai','alphaDstar','alphaJaccard','alphaKulczynski1','alphaKulczynski2'};
    covMetric = {'nc','tkc','tnc','ttk','pd','nd','mi','md'};    
    matfileList = dir(fullfile(path, '*_M_*.mat')); 
    mutWeights = size(thresholdArr,1);

    layerNum = numel(networkStru);
    neuronNum = networkStru(1);    
    mut_neuronList = [];
    mutateSucCell = {};
    % for mut = 1:mutWeights
    %     % [~, ~, li, i, j, ~] = readFileName(matfileList(mut).name);
    %     mut_neuronList = [mut_neuronList; li i j];
    %     mutateSucCell{end+1} = fullfile(matfileList(mut).folder, matfileList(mut).name);
    % end

    % pool = gcp('nocreate');
    % % if a parallel pool exists, delete it
    % if ~isempty(pool)
    % 	delete(pool);
    % end
    % % create a new parallel pool with the desired configuration
    % pool = parpool([2 10]);
    % 
    randStruExist = 0;
    for ana = 1:numel(actParam)
        new_file = [fileConfig{ana}, '_topkAnalyze'];
        new_folder = fullfile(path, new_file(2:end));
        [~, mkdirMsg, ~] = mkdir(new_folder);
        if ~isempty(mkdirMsg)
            continue 
        end

        %% analyze all mutation files, compute sps scpre and save them into *_topkAnalyze folder
        if randStruExist == 0
            randRateStru = cell(1, mutWeights);
            randStruExist = 1;
        end

        % read all *.mat files, analyze tops data
        % generate random information
        topkLimit = sum(networkStru(2:end));
        all_neuronSpsScoreCell = cell(1, size(thresholdArr,1));
        covPercentageCell = cell(size(thresholdArr,1),1);
        % for fileIdx = 1: size(thresholdArr,1)
        parfor fileIdx = 1: size(thresholdArr,1)
            li = thresholdArr(fileIdx,1);
            i = thresholdArr(fileIdx,2);
            j = thresholdArr(fileIdx,3);
            bugNum = thresholdArr(fileIdx,end);

            actParam_reg = actParam{ana};
            configName = fileConfig{ana};
            if automode
                thNumIdx = str2num(configName(strfind(configName, 'percent_')+8:end))/0.05;
                thArr = thresholdArr(ismember(thresholdArr(:,end), bugNum, 'rows'),:);
                thNum = thArr(ismember(thArr(:,1:3), [li i j], 'rows'), thNumIdx+5);
                
                actParam_reg{1} = thNum;
                actParam_reg{3} = [actParam_reg{3} thNum];
                actParam_reg{5} = [actParam_reg{5} thNum];
                actParam_reg{6} = [actParam_reg{6} thNum];
            else
                ncthIdx = find('sml'==actParam_reg{end}(1));
                tncthIdx = find('sml'==actParam_reg{end}(2));
                pdthIdx = find('sml'==actParam_reg{end}(3));
                ndthIdx = find('sml'==actParam_reg{end}(4));
                thArr = thresholdArr(ismember(thresholdArr(:,end), bugNum, 'rows'),:);
                actParam_reg{1} = thArr(ismember(thArr(:,1:3), [li i j], 'rows'), ncthIdx+4);
                actParam_reg{3} = [actParam_reg{3} thArr(ismember(thArr(:,1:3), [li i j], 'rows'), tncthIdx+4)];
                actParam_reg{5} = [actParam_reg{5} thArr(ismember(thArr(:,1:3), [li i j], 'rows'), pdthIdx+4)];
                actParam_reg{6} = [actParam_reg{6} thArr(ismember(thArr(:,1:3), [li i j], 'rows'), ndthIdx+4)];
                actParam_reg(end) = [];
            end
            
            fnameReg = matfileList(1).name;
            fname = [fnameReg(1:strfind(fnameReg, 'bug_')+3) num2str(bugNum) fnameReg(strfind(fnameReg, '_spec'):end)];
            D = load(fullfile(matfileList(1).folder, fname));

            [~, sps_info_new, covPercentageCell{fileIdx}] = nnresultEval(networkStru, covMetric, spsMetric, D.sig_state, actParam_reg);
            all_neuronSpsScoreCell{fileIdx}.layerIdx = li;
            all_neuronSpsScoreCell{fileIdx}.neuronIdx = i;
            all_neuronSpsScoreCell{fileIdx}.lastIdx = j;
            all_neuronSpsScoreCell{fileIdx}.spsScore = sps_info_new.sps_score;
            all_neuronSpsScoreCell{fileIdx}.bugNum = bugNum;

            % % save fault localization files
            % [~, fileName, ~] = fileparts(fname);
            % save_neuron_info = fullfile(new_folder, [fileName, new_file, '.mat']);
            % parsaveFLinfo(save_neuron_info, sig_state, D.sig_stateAll, sps_info_new, D.sig_success_rate);
            fprintf('%s mutant %d_%d_%d analyzed!\n', bmName, li, i, j)

            if isempty(randRateStru{1,fileIdx})
                randSuccess = [];
                for topk = 1:topkLimit
                    % save random fault localization result into randRateStru
                    randSuccess(end+1) = randFL(layerNum, neuronNum, li, i, topk, repTimes);
                end
                randRateStru{1, fileIdx} = [li, i, j, randSuccess];
            end
        end

        spsRateCell = cell(1, topkLimit);
        spsneuronInfoCell = cell(1, topkLimit);
        % for topk = 1:topkLimit
        parfor topk = 1:topkLimit
            [spsRateCell{topk}, spsneuronInfoCell{topk}] = spstopkAnalyze_multi(all_neuronSpsScoreCell, repTimes, topk, networkStru);
        end
        spsconFile = [matfileList(1).name(1:(strfind(matfileList(1).name, '_M_')-1)), '_topkAnalyze.mat'];
        spsconFile = fullfile(new_folder, spsconFile);        

        randRate = [];
        spsRatePage = [];
        randRatePage = [];
        for idx = 1:numel(randRateStru)
            randRate = [randRate; randRateStru{idx}];
        end
        reg = round(sum(randRate(:,4:end))/mutWeights, 2);

        for topk = 1:topkLimit
            randRatePage = cat(3, randRatePage, repmat(reg(topk), [numel(spsMetric), 1]));
            spsRatePage = cat(3, spsRatePage, spsRateCell{topk});
        end
        topkData = cat(2, spsRatePage, randRatePage);
        covPercentageArr = cat(2, thresholdArr(:,1:3), cell2mat(covPercentageCell));
        
        % %% testing codes
        % loadedData = load(spsconFile);
        % topkData = loadedData.topkData;

        %% plot topk figures, save them into dir path/fig
        % save random and sps info into variable topkData
        savepath = fullfile(new_folder, [new_file(2:end), 'Fig']);
        mkdir(savepath)
        areaArr = plotTopkAnalyze(savepath, 1, topkData, spsMetric, covMetric, bmName, sum(networkStru(2:end)));
        save(spsconFile, "all_neuronSpsScoreCell", "topkData", "spsneuronInfoCell", "covPercentageArr", "areaArr");
    end

end
