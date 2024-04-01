clear;
close all;
clc;
bdclose('all');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd /[pathtoTACTICAL]
addpath(genpath('/[pathtoTACTICAL]'));

path1 = 'result/mut1';
path2 = 'result/mut2';
path3 = 'result/mut3';
pathCell = {path1, path2, path3};
repTimes = 200;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% {benchmark name, nn Structure, topk, timeint_PNAPTK, timeint_PDND, timeint_MIMD}
% If you dont have the data of certain benchmark, you can let
% bmName_ACC1_spec1 = {} to skip the validation of this benchmark
bmName_ACC1_spec1 = {'ACC#1 S_{ACC}^{1}', [10 10 10 10], [2 3 4], [5 10 15], [5 10 15], [5 10 15]};
bmName_ACC1_spec2 = {'ACC#1 S_{ACC}^{2}', [10 10 10 10], [2 3 4], [5 10 15], [5 10 15], [5 10 15]};
bmName_ACC2_spec1 = {'ACC#2 S_{ACC}^{1}', [15 15 15], [3 4 5], [5 10 15], [5 10 15], [5 10 15]};
bmName_ACC2_spec2 = {'ACC#2 S_{ACC}^{2}', [15 15 15], [3 4 5], [5 10 15], [5 10 15], [5 10 15]};
bmName_AFC1_spec3 = {'AFC#1 S_{AFC}^{3}', [15 15 15], [3 4 5], [5 10 15], [5 10 15], [5 10 15]};
bmName_AFC1_spec4 = {'AFC#1 S_{AFC}^{4}', [15 15 15], [3 4 5], [5 10 15], [5 10 15], [5 10 15]};
bmName_AFC2_spec3 = {'AFC#2 S_{AFC}^{3}', [15 15 15 15], [3 4 5], [5 10 15], [5 10 15], [5 10 15]};
bmName_AFC2_spec4 = {'AFC#2 S_{AFC}^{4}', [15 15 15 15], [3 4 5], [5 10 15], [5 10 15], [5 10 15]};
bmName_WT1_spec5 = {'WT#1 S_{WT}^{5}', [5 5 5], [1 2 3], [5 10 15], [5 10 15], [5 10 15]};
bmName_WT2_spec5 = {'WT#2 S_{WT}^{5}', [15 15 15], [3 4 5], [5 10 15], [5 10 15], [5 10 15]};
bmName_SC1_spec6 = {'SC#1 S_{SC}^{6}', [10 10 10 10], [2 3 4], [5 10 15], [5 10 15], [5 10 15]};
bmName_SC2_spec6 = {'SC#2 S_{SC}^{6}', [15 15 15 15], [2 3 4], [5 10 15], [5 10 15], [5 10 15]};  

bmCell = {bmName_ACC1_spec1, bmName_ACC1_spec2, bmName_ACC2_spec1, bmName_ACC2_spec2, bmName_AFC1_spec3, bmName_AFC1_spec4, bmName_AFC2_spec3, bmName_AFC2_spec4, bmName_WT1_spec5, bmName_WT2_spec5, bmName_SC1_spec6, bmName_SC2_spec6};
spsMetric = {'alphaTarantula','alphaOchiai','alphaDstar','alphaJaccard','alphaKulczynski1','alphaKulczynski2'};
covMetric = {'nc','tkc','tnc','ttk','pd','nd','mi','md'}; 

for bmIdx = 1:numel(bmCell)

    bmInfo = bmCell{bmIdx};
    if isempty(bmInfo)
        continue
    end
    bmName = bmInfo{1};
    nnStru = bmInfo{2};
    bm = bmName(1:strfind(bmName, '#')-1);
    spec = str2num(bmName(strfind(bmName, '}^{')+3));
    bmfolderName = sprintf('%s_%d_%d_spec%d_mut1', bm, numel(nnStru), nnStru(1), spec);
    configName = fullfile(bmfolderName, 'transDataProcessed/*_auto_*_topkAnalyze');
    configName_onlyptk = fullfile(bmfolderName, 'transDataProcessed/onlyPTK_*');
    bmFolderDir = dir(fullfile(path1, configName));
    bmFolderDir_onlyptk = dir(fullfile(path1, configName_onlyptk));
    
    for i = 1:numel(bmFolderDir)
        spsScoreCell = {};
        topkFileDir = dir(fullfile(bmFolderDir(i).folder, bmFolderDir(i).name, '*.mat'));
        D = load(fullfile(topkFileDir(1).folder, topkFileDir(1).name));
        for j = 1:numel(D.all_neuronSpsScoreCell)
            spsScoreCell{end+1} = D.all_neuronSpsScoreCell{j};
        end     

        for mutIdx = 2:numel(pathCell)
            path_multi = fullfile(pathCell{mutIdx}, sprintf('%s_%d_%d_spec%d_mut%d/transDataProcessed/*_auto_*_topkAnalyze', bm, numel(nnStru), nnStru(1), spec, mutIdx));
            bmFolderDir_multi = dir(path_multi);
            topkFileDir_multi = dir(fullfile(bmFolderDir_multi(i).folder, bmFolderDir_multi(i).name, '*.mat'));
            D = load(fullfile(topkFileDir_multi(1).folder, topkFileDir_multi(1).name));
            for j = 1:numel(D.all_neuronSpsScoreCell)
                spsScoreCell{end+1} = D.all_neuronSpsScoreCell{j};
            end
        end 

        topkLimit = numel(D.spsneuronInfoCell);
        spsRateCell = cell(1, topkLimit);
        spsneuronInfoCell = cell(1, topkLimit);
        % for topk = 1:topkLimit
        parfor topk = 1:topkLimit
            [spsRateCell{topk}, spsneuronInfoCell{topk}] = spstopkAnalyze(spsScoreCell, repTimes, topk, nnStru);
        end

        spsRatePage = [];
        for topk = 1:topkLimit
            spsRatePage = cat(3, spsRatePage, spsRateCell{topk});
        end
        topkData = cat(2, spsRatePage, D.topkData(:,end,:));

        savepath = fullfile('result/multiMutants', bmfolderName, 'transDataProcessed', bmFolderDir(i).name);
        mkdir(savepath)
        spsconFile = fullfile(savepath, topkFileDir(1).name);
        areaArr = plotTopkAnalyze(savepath, 1, topkData, spsMetric, covMetric, bmName, sum(nnStru(2:end)));
        all_neuronSpsScoreCell = spsScoreCell;
        save(spsconFile, "all_neuronSpsScoreCell", "topkData", "spsneuronInfoCell", "areaArr");
        fprintf('%s file finished!\n', spsconFile)
    end

    for i = 1:numel(bmFolderDir_onlyptk)
        spsScoreCell = {};
        topkFileDir_onlyptk = dir(fullfile(bmFolderDir_onlyptk(i).folder, bmFolderDir_onlyptk(i).name, '*.mat'));
        D = load(fullfile(topkFileDir_onlyptk(1).folder, topkFileDir_onlyptk(1).name));
        for j = 1:numel(D.all_neuronSpsScoreCell)
            spsScoreCell{end+1} = D.all_neuronSpsScoreCell{j};
        end     

        for mutIdx = 2:numel(pathCell)
            path_multi = fullfile(pathCell{mutIdx}, sprintf('%s_%d_%d_spec%d_mut%d/transDataProcessed/onlyPTK_*', bm, numel(nnStru), nnStru(1), spec, mutIdx));
            bmFolderDir_multi = dir(path_multi);
            topkFileDir_multi = dir(fullfile(bmFolderDir_multi(i).folder, bmFolderDir_multi(i).name, '*.mat'));
            D = load(fullfile(topkFileDir_multi(1).folder, topkFileDir_multi(1).name));
            for j = 1:numel(D.all_neuronSpsScoreCell)
                spsScoreCell{end+1} = D.all_neuronSpsScoreCell{j};
            end
        end 

        topkLimit = numel(D.spsneuronInfoCell);
        spsRateCell = cell(1, topkLimit);
        spsneuronInfoCell = cell(1, topkLimit);
        % for topk = 1:topkLimit
        parfor topk = 1:topkLimit
            [spsRateCell{topk}, spsneuronInfoCell{topk}] = spstopkAnalyze(spsScoreCell, repTimes, topk, nnStru);
        end
        
        spsRatePage = [];
        for topk = 1:topkLimit
            spsRatePage = cat(3, spsRatePage, spsRateCell{topk});
        end
        topkData = cat(2, spsRatePage, D.topkData(:,end,:));

        savepath = fullfile('result/multiMutants', bmfolderName, 'transDataProcessed', bmFolderDir_onlyptk(i).name);
        mkdir(savepath)
        spsconFile = fullfile(savepath, topkFileDir_onlyptk(1).name);
        areaArr = plotTopkAnalyze(savepath, 1, topkData, spsMetric, covMetric, bmName, sum(nnStru(2:end)));
        all_neuronSpsScoreCell = spsScoreCell;
        save(spsconFile, "all_neuronSpsScoreCell", "topkData", "spsneuronInfoCell", "areaArr"); 
        fprintf('%s file finished!\n', spsconFile)
    end
end
