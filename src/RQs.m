clear;
close all;
clc;
bdclose('all');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cd /[pathtoTACTICAL]
% addpath(genpath('/[pathtoTACTICAL]'));
cd /Users/ly/Desktop/TACTICAL
addpath(genpath('/Users/ly/Desktop/TACTICAL'));
mutNum = 1;
dataPath = 'result/mut1';
storagePath = 'result/mut1/RQ2Data';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

maxPercent = 0:0.05:0.1;    % same as the RQ1 setting
spsMetric = {'alphaTarantula','alphaOchiai','alphaDstar','alphaJaccard','alphaKulczynski1','alphaKulczynski2'};
pathDir = dir([dataPath, '/*_spec*']);
mkdir(fullfile(dataPath, 'RQ2Data'));

bmName_ACC1_spec1 = {'ACC#1 S_{ACC}^{1}', [10 10 10 10], [2 3 4], [5 10 15], [5 10 15], [5 10 15]};
bmName_ACC1_spec2 = {'ACC#1 S_{ACC}^{2}', [10 10 10 10], [2 3 4], [5 10 15], [5 10 15], [5 10 15]};
bmName_ACC2_spec1 = {'ACC#2 S_{ACC}^{1}', [15 15 15], [3 4 5], [5 10 15], [5 10 15], [5 10 15]};
bmName_ACC2_spec2 = {'ACC#2 S_{ACC}^{2}', [15 15 15], [3 4 5], [5 10 15], [5 10 15], [5 10 15]};
bmName_AFC1_spec1 = {'AFC#1 S_{AFC}^{3}', [15 15 15], [3 4 5], [5 10 15], [5 10 15], [5 10 15]};
bmName_AFC1_spec2 = {'AFC#1 S_{AFC}^{4}', [15 15 15], [3 4 5], [5 10 15], [5 10 15], [5 10 15]};
bmName_AFC2_spec1 = {'AFC#2 S_{AFC}^{3}', [15 15 15 15], [3 4 5], [5 10 15], [5 10 15], [5 10 15]};
bmName_AFC2_spec2 = {'AFC#2 S_{AFC}^{4}', [15 15 15 15], [3 4 5], [5 10 15], [5 10 15], [5 10 15]};
bmName_WT1_spec1 = {'WT#1 S_{WT}^{5}', [5 5 5], [1 2 3], [5 10 15], [5 10 15], [5 10 15]};
bmName_WT2_spec1 = {'WT#2 S_{WT}^{5}', [15 15 15], [3 4 5], [5 10 15], [5 10 15], [5 10 15]};
bmName_SC1_spec1 = {'SC#1 S_{SC}^{6}', [10 10 10 10], [2 3 4], [5 10 15], [5 10 15], [5 10 15]};
bmName_SC2_spec1 = {'SC#2 S_{SC}^{6}', [15 15 15 15], [2 3 4], [5 10 15], [5 10 15], [5 10 15]};  
bmCell = {bmName_ACC1_spec1, bmName_ACC1_spec2, bmName_ACC2_spec1, bmName_ACC2_spec2, bmName_AFC1_spec1, bmName_AFC1_spec2, bmName_AFC2_spec1, bmName_AFC2_spec2, bmName_WT1_spec1, bmName_WT2_spec1, bmName_SC1_spec1, bmName_SC2_spec1};

for bmIdx = 1:numel(bmCell)
    bmFileName = bmCell{bmIdx}{1};
    blankidx = strfind(bmFileName, '_');
    bmInfo = bmCell{bmIdx};
    bmName = bmInfo{1};
    nnStru = bmInfo{2};
    bm = bmName(1:strfind(bmName, '#')-1);
    spec = str2num(bmName(strfind(bmName, '}^{')+3));
    bmFolderName = sprintf('%s_%d_%d_spec%d_mut%d', bm, numel(nnStru), nnStru(1), spec, mutNum);
    bmPath = fullfile(dataPath, bmFolderName);

    bmDir = dir(fullfile(bmPath, 'transDataProcessed', '*_auto_*_topkAnalyze'));
    bmDataCell = cell(1, numel(bmDir));

    for f = 1:numel(bmDir)
        configDir = dir(fullfile(bmDir(f).folder, bmDir(f).name, '*.mat'));
        startidx = strfind(bmDir(f).name, 'percent_')+8;
        endidx = strfind(bmDir(f).name, 'percent_')+11;
        percentageNum = str2num(bmDir(f).name(startidx:endidx));
        for matIdx = 1:numel(configDir)
            if contains(configDir(matIdx).name, '_M_')
                continue
            end
            reg = load(fullfile(configDir(matIdx).folder, configDir(matIdx).name));
            bmDataCell{f}.topkData = reg.topkData;
            bmDataCell{f}.areaArr = reg.areaArr;
            bmDataCell{f}.percentageNum = percentageNum;
        end
    end

    bmmatName = fullfile(storagePath, [bmFolderName, '_FLinfo.mat']);
    save(bmmatName, 'bmDataCell')
    fprintf('Benchmark %s finished!\n', bmFolderName)

    path_onlyptk = fullfile(bmPath, 'transDataProcessed', 'onlyPTK*');
    pathFolder = dir(path_onlyptk);

    pathNameCell = {};
    for k = 1:numel(bmCell{bmIdx}{3})
        for time = 1:numel(bmCell{bmIdx}{4})
            pathNameCell{end+1} = sprintf('onlyPTK_%d %d_percent_0.00_topkAnalyze', bmCell{bmIdx}{4}(time), bmCell{bmIdx}{3}(k));
        end
    end

    bmDataCell = cell(1, numel(pathNameCell));
    for f = 1:numel(pathNameCell) 
        regname = dir(fullfile(pathFolder(1).folder, pathNameCell{f}, '*.mat'));
        reg = load(fullfile(regname(1).folder, regname(1).name));
        bmDataCell{f}.topkData = reg.topkData;
        bmDataCell{f}.areaArr = reg.areaArr;
        % movefile(fullfile(pathFolder(1).folder, pathNameCell{f}), fullfile(bmPath, 'RQ1preprocessdata'));
    end

    bmmatName = fullfile(storagePath, [bmFolderName, '_FLinfo_onlyPTK.mat']);
    save(bmmatName, 'bmDataCell')
    fprintf('Benchmark %s finished!\n', bmFolderName)
end

rqDir = dir(fullfile(storagePath, '/*_FLinfo.mat'));
rqDir_onlyptk = dir(fullfile(storagePath, '/*_onlyPTK.mat'));
diffPercentArea = cell(1,numel(maxPercent));
ptkData = {};
for i = 1:numel(bmCell)
    bmInfo = bmCell{i};
    bmName = bmInfo{1};
    networkStru = bmInfo{2};
    bm = bmName(1:strfind(bmName, '#')-1);
    spec = str2num(bmName(strfind(bmName, '}^{')+3));
    bmFileName = sprintf('%s_%d_%d_spec%d_mut%d_FLinfo.mat', bm, numel(networkStru), networkStru(1), spec, mutNum);
    bmFileName_onlyptk = sprintf('%s_%d_%d_spec%d_mut%d_FLinfo_onlyPTK.mat', bm, numel(networkStru), networkStru(1), spec, mutNum);
    filename_reg = fullfile(rqDir(i).folder, bmFileName);
    filename_reg_onlyptk = fullfile(rqDir_onlyptk(i).folder, bmFileName);

    reg = load(filename_reg);
    reg_onlyptk = load(filename_reg_onlyptk);

    if (i == 1)
        randArr = repmat(reg.bmDataCell{1}.areaArr(1,end,1), [12 1]);
    end

    for idx = 1:numel(reg.bmDataCell)
        perIdx = round(reg.bmDataCell{idx}.percentageNum/0.05) + 1;
        if isempty(diffPercentArea{perIdx})
            diffPercentArea{perIdx}.areaPage_20p = [];
        end
        diffPercentArea{perIdx}.areaPage_20p = cat(3, diffPercentArea{perIdx}.areaPage_20p, reg.bmDataCell{idx}.areaArr(:,:,1));
    end

    ptkData{end+1} = [];
    for idx = 1:numel(reg.bmDataCell)
        ptkData{1,i} = cat(2, ptkData{1,i}, reg.bmDataCell{idx}.areaArr(6,4,1));
    end
    ptkData{1,i} = reshape(ptkData{1,i}, [3 3]);    
end

smallData_20p = [];
mediumData_20p = [];
largeData_20p = [];
for perIdx = 1:numel(maxPercent)
    for i = 1:numel(pathDir)
        smallData_20p = cat(3, smallData_20p, diffPercentArea{perIdx}.areaPage_20p(:,:,1+3*(i-1)));
        mediumData_20p = cat(3, mediumData_20p, diffPercentArea{perIdx}.areaPage_20p(:,:,2+3*(i-1)));
        largeData_20p = cat(3, largeData_20p, diffPercentArea{perIdx}.areaPage_20p(:,:,3+3*(i-1)));
    end
end

allCriteriaDataCell = cell(1,6);
for metIdx = 1:6
    inaData = reshape(smallData_20p(metIdx,1,:), [numel(pathDir) numel(maxPercent)]);
    itkData = cat(2, reshape(smallData_20p(metIdx,2,1:numel(pathDir)), [numel(pathDir) 1]), reshape(mediumData_20p(metIdx,2,1:numel(pathDir)), [numel(pathDir) 1]), reshape(largeData_20p(metIdx,2,1:numel(pathDir)), [numel(pathDir) 1]));
    
    tncData_s = reshape(smallData_20p(metIdx,3,:), [numel(pathDir) numel(maxPercent)]);
    tncData_m = reshape(mediumData_20p(metIdx,3,:), [numel(pathDir) numel(maxPercent)]);
    tncData_l = reshape(largeData_20p(metIdx,3,:), [numel(pathDir) numel(maxPercent)]);
    tncData_Page = cat(3, tncData_s, tncData_m, tncData_l);
    tncData_mean = mean(tncData_Page, 3);
    
    pdData_s = reshape(smallData_20p(metIdx,5,:), [numel(pathDir) numel(maxPercent)]);
    pdData_m = reshape(mediumData_20p(metIdx,5,:), [numel(pathDir) numel(maxPercent)]);
    pdData_l = reshape(largeData_20p(metIdx,5,:), [numel(pathDir) numel(maxPercent)]);
    pdData_Page = cat(3, pdData_s, pdData_m, pdData_l);
    pdData_mean = mean(pdData_Page, 3);
    
    ndData_s = reshape(smallData_20p(metIdx,6,:), [numel(pathDir) numel(maxPercent)]);
    ndData_m = reshape(mediumData_20p(metIdx,6,:), [numel(pathDir) numel(maxPercent)]);
    ndData_l = reshape(largeData_20p(metIdx,6,:), [numel(pathDir) numel(maxPercent)]);
    ndData_Page = cat(3, ndData_s, ndData_m, ndData_l);
    ndData_mean = mean(ndData_Page, 3);
    
    miData = cat(2, reshape(smallData_20p(metIdx,7,1:numel(pathDir)), [numel(pathDir) 1]), reshape(mediumData_20p(metIdx,7,1:numel(pathDir)), [numel(pathDir) 1]), reshape(largeData_20p(metIdx,7,1:numel(pathDir)), [numel(pathDir) 1]));
    mdData = cat(2, reshape(smallData_20p(metIdx,8,1:numel(pathDir)), [numel(pathDir) 1]), reshape(mediumData_20p(metIdx,8,1:numel(pathDir)), [numel(pathDir) 1]), reshape(largeData_20p(metIdx,8,1:numel(pathDir)), [numel(pathDir) 1]));
    mimdData_met = {};
    for lineIdx = 1:size(miData,1)
        mimdData_met{end+1} = cat(1, miData(lineIdx,:), mdData(lineIdx,:));
    end
    
    pna_arr = cell(1,10);
    for sz = 1:size(tncData_Page,1)
        pna_arr{sz} = [];
        for bm = 1:size(tncData_Page(sz,:,:), 3)
            pna_arr{sz} = cat(1, pna_arr{sz}, tncData_Page(sz, :, bm));
        end  
    end
    pd_arr = cell(1,10);
    for sz = 1:size(pdData_Page,1)
        pd_arr{sz} = [];
        for bm = 1:size(pdData_Page(sz,:,:), 3)
            pd_arr{sz} = cat(1, pd_arr{sz}, pdData_Page(sz, :, bm));
        end  
    end
    nd_arr = cell(1,10);
    for sz = 1:size(ndData_Page,1)
        nd_arr{sz} = [];
        for bm = 1:size(ndData_Page(sz,:,:), 3)
            nd_arr{sz} = cat(1, nd_arr{sz}, ndData_Page(sz, :, bm));
        end  
    end
    
    RQ2filename = fullfile(dataPath, sprintf('RQ2AllMetricsData.mat'));
    
    pna_arr_ths = [];
    pna_arr_thm = [];
    pna_arr_thl = [];
    pna_arr_ints = [];
    pna_arr_intm = [];
    pna_arr_intl = [];
    
    ptk_arr_topks = [];
    ptk_arr_topkm = [];
    ptk_arr_topkl = [];
    ptk_arr_ints = [];
    ptk_arr_intm = [];
    ptk_arr_intl = [];
    
    pd_arr_ths = [];
    pd_arr_thm = [];
    pd_arr_thl = [];
    pd_arr_ints = [];
    pd_arr_intm = [];
    pd_arr_intl = [];
    
    nd_arr_ths = [];
    nd_arr_thm = [];
    nd_arr_thl = [];
    nd_arr_ints = [];
    nd_arr_intm = [];
    nd_arr_intl = [];
    
    for i = 1:numel(pna_arr)
        % pna_arr_ths = [pna_arr_ths; pna_arr{i}(:,1)'];
        % pna_arr_thm = [pna_arr_thm; pna_arr{i}(:,2)'];
        % pna_arr_thl = [pna_arr_thl; pna_arr{i}(:,3)'];
        pna_arr_ints = [pna_arr_ints; pna_arr{i}(1,:)];
        pna_arr_intm = [pna_arr_intm; pna_arr{i}(2,:)];
        pna_arr_intl = [pna_arr_intl; pna_arr{i}(3,:)];
    
        % ptk_arr_topks = [ptk_arr_topks; ptkData{i}(:,1)'];
        % ptk_arr_topkm = [ptk_arr_topkm; ptkData{i}(:,2)'];
        % ptk_arr_topkl = [ptk_arr_topkl; ptkData{i}(:,3)'];
        ptk_arr_ints = [ptk_arr_ints; ptkData{i}(1,:)];
        ptk_arr_intm = [ptk_arr_intm; ptkData{i}(2,:)];
        ptk_arr_intl = [ptk_arr_intl; ptkData{i}(3,:)];
    
        % pd_arr_ths = [pd_arr_ths; pd_arr{i}(:,1)'];
        % pd_arr_thm = [pd_arr_thm; pd_arr{i}(:,2)'];
        % pd_arr_thl = [pd_arr_thl; pd_arr{i}(:,3)'];
        pd_arr_ints = [pd_arr_ints; pd_arr{i}(1,:)];
        pd_arr_intm = [pd_arr_intm; pd_arr{i}(2,:)];
        pd_arr_intl = [pd_arr_intl; pd_arr{i}(3,:)];
    
        % nd_arr_ths = [nd_arr_ths; nd_arr{i}(:,1)'];
        % nd_arr_thm = [nd_arr_thm; nd_arr{i}(:,2)'];
        % nd_arr_thl = [nd_arr_thl; nd_arr{i}(:,3)'];
        nd_arr_ints = [nd_arr_ints; nd_arr{i}(1,:)];
        nd_arr_intm = [nd_arr_intm; nd_arr{i}(2,:)];
        nd_arr_intl = [nd_arr_intl; nd_arr{i}(3,:)];
    end
    
    pna_arr_data = cat(2, pna_arr_ints, pna_arr_intm, pna_arr_intl);
    ptk_arr_data = cat(2, ptk_arr_ints, ptk_arr_intm, ptk_arr_intl);
    pd_arr_int = cat(2, pd_arr_ints, pd_arr_intm, pd_arr_intl);
    nd_arr_int = cat(2, nd_arr_ints, nd_arr_intm, nd_arr_intl);
    allCriteriaDataCell{metIdx} = cat(2, inaData, itkData, pna_arr_data, ptk_arr_data, pd_arr_int, nd_arr_int, miData, mdData, randArr);
end
% save(RQ2filename, 'allCriteriaDataCell');

%% RQ1 cohens
allDataArr = cat(1, allCriteriaDataCell{1}, allCriteriaDataCell{2}, allCriteriaDataCell{3}, allCriteriaDataCell{4}, allCriteriaDataCell{5}, allCriteriaDataCell{6});
allDataArr_noku1 = cat(1, allCriteriaDataCell{1}, allCriteriaDataCell{2}, allCriteriaDataCell{3}, allCriteriaDataCell{4}, allCriteriaDataCell{6});
cohensDataArr = zeros(1, size(allDataArr, 2)-1);
for i = 1:size(allDataArr, 2)-1
    cohensDataArr(i) = computeCohen_d(allDataArr(:,i), allDataArr(:,end), 'paired');
end
cohensDataArr_noku1 = zeros(1, size(allDataArr_noku1, 2)-1);
for i = 1:size(allDataArr_noku1, 2)-1
    cohensDataArr_noku1(i) = computeCohen_d(allDataArr_noku1(:,i), allDataArr_noku1(:,end), 'paired');
end
[large_worse, medium_worse, small_worse, small_better, medium_better, large_better] = label(cohensDataArr);
cohensResultRQ1 = string(cohensDataArr);
cohensResultRQ1(large_worse) = 'large_worse';
cohensResultRQ1(medium_worse) = 'medium_worse';
cohensResultRQ1(small_worse) = 'small_worse';
cohensResultRQ1(small_better) = 'small_better';
cohensResultRQ1(medium_better) = 'medium_better';
cohensResultRQ1(large_better) = 'large_better';
[large_worse, medium_worse, small_worse, small_better, medium_better, large_better] = label(cohensDataArr_noku1);
cohensResultRQ1_noku1 = string(cohensDataArr_noku1);
cohensResultRQ1_noku1(large_worse) = 'large_worse';
cohensResultRQ1_noku1(medium_worse) = 'medium_worse';
cohensResultRQ1_noku1(small_worse) = 'small_worse';
cohensResultRQ1_noku1(small_better) = 'small_better';
cohensResultRQ1_noku1(medium_better) = 'medium_better';
cohensResultRQ1_noku1(large_better) = 'large_better';

%% RQ2 cohens
app_num = size(allCriteriaDataCell{1}, 2)-1;
matrix_d_All_RQ2 = zeros(app_num, app_num);
for i = 1:app_num
    for j = 1:app_num
        % calculate the Cohen's d effect size
        matrix_d_All_RQ2(i, j) = computeCohen_d(allDataArr(:, i), allDataArr(:, j), 'paired');
    end
end
matrix_d_All_RQ2_noku1 = zeros(app_num, app_num);
for i = 1:app_num
    for j = 1:app_num
        % calculate the Cohen's d effect size
        matrix_d_All_RQ2_noku1(i, j) = computeCohen_d(allDataArr_noku1(:, i), allDataArr_noku1(:, j), 'paired');
    end
end
cohensResultRQ2 = string(matrix_d_All_RQ2);
[large_worse, medium_worse, small_worse, small_better, medium_better, large_better] = label(matrix_d_All_RQ2);
cohensResultRQ2(large_worse) = 'large_worse';
cohensResultRQ2(medium_worse) = 'medium_worse';
cohensResultRQ2(small_worse) = 'small_worse';
cohensResultRQ2(small_better) = 'small_better';
cohensResultRQ2(medium_better) = 'medium_better';
cohensResultRQ2(large_better) = 'large_better';
cohensResultRQ2_noku1 = string(matrix_d_All_RQ2_noku1);
[large_worse, medium_worse, small_worse, small_better, medium_better, large_better] = label(matrix_d_All_RQ2_noku1);
cohensResultRQ2_noku1(large_worse) = 'large_worse';
cohensResultRQ2_noku1(medium_worse) = 'medium_worse';
cohensResultRQ2_noku1(small_worse) = 'small_worse';
cohensResultRQ2_noku1(small_better) = 'small_better';
cohensResultRQ2_noku1(medium_better) = 'medium_better';
cohensResultRQ2_noku1(large_better) = 'large_better';

%% RQ3 cohens
inaResult = matrix_d_All_RQ2(1:3, 1:3);
itkResult = matrix_d_All_RQ2(4:6, 4:6);
pnaResult = matrix_d_All_RQ2(7:15, 7:15);
ptkResult = matrix_d_All_RQ2(16:24, 16:24);
pdResult = matrix_d_All_RQ2(25:33, 25:33);
ndResult = matrix_d_All_RQ2(34:42, 34:42);
miResult = matrix_d_All_RQ2(43:45, 43:45);
mdResult = matrix_d_All_RQ2(46:48, 46:48);
cohensResultRQ2Cell = {inaResult, itkResult, pnaResult, ptkResult, pdResult, ndResult, miResult, mdResult};
inaResult = matrix_d_All_RQ2_noku1(1:3, 1:3);
itkResult = matrix_d_All_RQ2_noku1(4:6, 4:6);
pnaResult = matrix_d_All_RQ2_noku1(7:15, 7:15);
ptkResult = matrix_d_All_RQ2_noku1(16:24, 16:24);
pdResult = matrix_d_All_RQ2_noku1(25:33, 25:33);
ndResult = matrix_d_All_RQ2_noku1(34:42, 34:42);
miResult = matrix_d_All_RQ2_noku1(43:45, 43:45);
mdResult = matrix_d_All_RQ2_noku1(46:48, 46:48);
cohensResultRQ2Cell_noku1 = {inaResult, itkResult, pnaResult, ptkResult, pdResult, ndResult, miResult, mdResult};

inaResult_str = cohensResultRQ2(1:3, 1:3);
itkResult_str = cohensResultRQ2(4:6, 4:6);
pnaResult_str = cohensResultRQ2(7:15, 7:15);
ptkResult_str = cohensResultRQ2(16:24, 16:24);
pdResult_str = cohensResultRQ2(25:33, 25:33);
ndResult_str = cohensResultRQ2(34:42, 34:42);
miResult_str = cohensResultRQ2(43:45, 43:45);
mdResult_str = cohensResultRQ2(46:48, 46:48);
cohensResultRQ2CellStr = {inaResult_str, itkResult_str, pnaResult_str, ptkResult_str, pdResult_str, ndResult_str, miResult_str, mdResult_str};
inaResult_str = cohensResultRQ2_noku1(1:3, 1:3);
itkResult_str = cohensResultRQ2_noku1(4:6, 4:6);
pnaResult_str = cohensResultRQ2_noku1(7:15, 7:15);
ptkResult_str = cohensResultRQ2_noku1(16:24, 16:24);
pdResult_str = cohensResultRQ2_noku1(25:33, 25:33);
ndResult_str = cohensResultRQ2_noku1(34:42, 34:42);
miResult_str = cohensResultRQ2_noku1(43:45, 43:45);
mdResult_str = cohensResultRQ2_noku1(46:48, 46:48);
cohensResultRQ2CellStr_noku1 = {inaResult_str, itkResult_str, pnaResult_str, ptkResult_str, pdResult_str, ndResult_str, miResult_str, mdResult_str};

bestconfigDataCell = {};
AUC_Bench_App_All = [];
for i = 1:6
    bestconfigDataArr = [];
    for j = 1:numel(cohensResultRQ2Cell)
        rowIdx = find(sum(cohensResultRQ2Cell{j}>0,2) == (size(cohensResultRQ2Cell{j}, 1)-1));
        if j==2
            rowIdx = rowIdx + 3;
        elseif j==3
            rowIdx = rowIdx + 6;
        elseif j==4
            rowIdx = rowIdx + 15;
        elseif j==5
            rowIdx = rowIdx + 24;
        elseif j==6
            rowIdx = rowIdx + 33; 
        elseif j==7
            rowIdx = rowIdx + 42;
        elseif j==8
            rowIdx = rowIdx + 45;         
        end
        bestconfigDataArr = cat(2, bestconfigDataArr, allCriteriaDataCell{i}(:,rowIdx));
    end
    bestconfigDataCell{end+1} = bestconfigDataArr;
    AUC_Bench_App_All = [AUC_Bench_App_All; bestconfigDataArr];
end
bestconfigDataCell_noku1 = {};
AUC_Bench_App_All_noku1 = [];
for i = 1:6
    if i==5
        continue
    end
    bestconfigDataArr_noku1 = [];
    for j = 1:numel(cohensResultRQ2Cell_noku1)
        rowIdx = find(sum(cohensResultRQ2Cell_noku1{j}>0,2) == (size(cohensResultRQ2Cell_noku1{j}, 1)-1));
        if j==2
            rowIdx = rowIdx + 3;
        elseif j==3
            rowIdx = rowIdx + 6;
        elseif j==4
            rowIdx = rowIdx + 15;
        elseif j==5
            rowIdx = rowIdx + 24;
        elseif j==6
            rowIdx = rowIdx + 33; 
        elseif j==7
            rowIdx = rowIdx + 42;
        elseif j==8
            rowIdx = rowIdx + 45;         
        end
        bestconfigDataArr_noku1 = cat(2, bestconfigDataArr_noku1, allCriteriaDataCell{i}(:,rowIdx));
    end
    bestconfigDataCell_noku1{end+1} = bestconfigDataArr_noku1;
    AUC_Bench_App_All_noku1 = [AUC_Bench_App_All_noku1; bestconfigDataArr_noku1];
end

app_num = size(bestconfigDataCell{1}, 2);
matrix_d_All_RQ3 = zeros(app_num, app_num);
for i = 1:app_num
    for j = 1:app_num
        % calculate the Cohen's d effect size
        matrix_d_All_RQ3(i, j) = computeCohen_d(AUC_Bench_App_All(:, i), AUC_Bench_App_All(:, j), 'paired');
    end
end
app_num = size(bestconfigDataCell_noku1{1}, 2);
matrix_d_All_RQ3_noku1 = zeros(app_num, app_num);
for i = 1:app_num
    for j = 1:app_num
        % calculate the Cohen's d effect size
        matrix_d_All_RQ3_noku1(i, j) = computeCohen_d(AUC_Bench_App_All_noku1(:, i), AUC_Bench_App_All_noku1(:, j), 'paired');
    end
end

cohensResultRQ3 = string(matrix_d_All_RQ3);
[large_worse, medium_worse, small_worse, small_better, medium_better, large_better] = label(matrix_d_All_RQ3);
cohensResultRQ3(large_worse) = 'large_worse';
cohensResultRQ3(medium_worse) = 'medium_worse';
cohensResultRQ3(small_worse) = 'small_worse';
cohensResultRQ3(small_better) = 'small_better';
cohensResultRQ3(medium_better) = 'medium_better';
cohensResultRQ3(large_better) = 'large_better';
cohensResultRQ3_noku1 = string(matrix_d_All_RQ3_noku1);
[large_worse, medium_worse, small_worse, small_better, medium_better, large_better] = label(matrix_d_All_RQ3_noku1);
cohensResultRQ3_noku1(large_worse) = 'large_worse';
cohensResultRQ3_noku1(medium_worse) = 'medium_worse';
cohensResultRQ3_noku1(small_worse) = 'small_worse';
cohensResultRQ3_noku1(small_better) = 'small_better';
cohensResultRQ3_noku1(medium_better) = 'medium_better';
cohensResultRQ3_noku1(large_better) = 'large_better';

%% RQ4 cohens
app_num = 6;
AUC_Bench_App_All_Param = [];
AUC_Bench_App_All_Param_noku1 = [];
for spsIdx = 1:app_num
    AUC_Bench_App_All_Param = cat(2, AUC_Bench_App_All_Param, reshape(bestconfigDataCell{spsIdx}, size(bestconfigDataCell{spsIdx},1)*size(bestconfigDataCell{spsIdx},2), 1));
    if spsIdx == 5
        continue
    end
    AUC_Bench_App_All_Param_noku1 = cat(2, AUC_Bench_App_All_Param_noku1, reshape(bestconfigDataCell{spsIdx}, size(bestconfigDataCell{spsIdx},1)*size(bestconfigDataCell{spsIdx},2), 1));
end

matrix_d_All_Param_RQ4 = zeros(app_num, app_num);
for i = 1:app_num
    for j = 1:app_num
        % calculate the Cohen's d effect size
        matrix_d_All_Param_RQ4(i, j) = computeCohen_d(AUC_Bench_App_All_Param(:, i), AUC_Bench_App_All_Param(:, j), 'paired');
    end
end

matrix_d_All_Param_RQ4_noku1 = zeros(app_num-1, app_num-1);
for i = 1:app_num-1
    for j = 1:app_num-1
        % calculate the Cohen's d effect size
        matrix_d_All_Param_RQ4_noku1(i, j) = computeCohen_d(AUC_Bench_App_All_Param_noku1(:, i), AUC_Bench_App_All_Param_noku1(:, j), 'paired');
    end
end

cohensResultRQ4_data = matrix_d_All_Param_RQ4;
cohensResultRQ4 = string(matrix_d_All_Param_RQ4);
[large_worse, medium_worse, small_worse, small_better, medium_better, large_better] = label(matrix_d_All_Param_RQ4);
cohensResultRQ4(large_worse) = 'large_worse';
cohensResultRQ4(medium_worse) = 'medium_worse';
cohensResultRQ4(small_worse) = 'small_worse';
cohensResultRQ4(small_better) = 'small_better';
cohensResultRQ4(medium_better) = 'medium_better';
cohensResultRQ4(large_better) = 'large_better';

cohensResultRQ4_data_noku1 = matrix_d_All_Param_RQ4_noku1;
cohensResultRQ4_noku1 = string(matrix_d_All_Param_RQ4_noku1);
[large_worse, medium_worse, small_worse, small_better, medium_better, large_better] = label(matrix_d_All_Param_RQ4_noku1);
cohensResultRQ4_noku1(large_worse) = 'large_worse';
cohensResultRQ4_noku1(medium_worse) = 'medium_worse';
cohensResultRQ4_noku1(small_worse) = 'small_worse';
cohensResultRQ4_noku1(small_better) = 'small_better';
cohensResultRQ4_noku1(medium_better) = 'medium_better';
cohensResultRQ4_noku1(large_better) = 'large_better';

% allData_exceptRand = {};
% for i = 1:numel(allCriteriaDataCell)
%     allData_exceptRand{i} = allCriteriaDataCell{i}(:,1:end-1);
% end
% 
% app_num = 6;
% AUC_Bench_App_All_Param = [];
% for spsIdx = 1:app_num
%     AUC_Bench_App_All_Param = cat(2, AUC_Bench_App_All_Param, reshape(allData_exceptRand{spsIdx}, size(allData_exceptRand{spsIdx},1)*size(allData_exceptRand{spsIdx},2), 1));
% end
% 
% wilcoxonP_RQ4 = zeros(app_num, app_num);
% wilcoxonH_RQ4 = zeros(app_num, app_num);
% for i = 1:app_num
%     for j = 1:app_num
%         % perform Wilcoxon signed-rank test
%         [wilcoxonP_RQ4(i, j), wilcoxonH_RQ4(i, j), ~] = signrank(AUC_Bench_App_All_Param(:, i)', AUC_Bench_App_All_Param(:, j)', 'method', 'exact');
%     end
% end

save(fullfile(storagePath, 'AllRQsResult.mat'), 'cohensResultRQ1_noku1', 'cohensResultRQ2CellStr_noku1', 'cohensResultRQ3_noku1', 'cohensResultRQ4_noku1')

%% func
function [large_worse, medium_worse, small_worse, small_better, medium_better, large_better] = label(matrix_d)
    large_worse = matrix_d < -0.8;
    medium_worse = matrix_d >= -0.8 & matrix_d <= -0.2;
    small_worse = matrix_d > -0.2 & matrix_d < 0;
    small_better = matrix_d > 0 & matrix_d < 0.2;
    medium_better = matrix_d >= 0.2 & matrix_d <= 0.8;
    large_better = matrix_d > 0.8;
end