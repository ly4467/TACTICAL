clear;
close all;
clc;
bdclose('all');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cd /[pathtoTACTICAL]
% addpath(genpath('/[pathtoTACTICAL]'));
cd /Users/ly/Desktop/TACTICAL
addpath(genpath('/Users/ly/Desktop/TACTICAL'));
metIdx = 6;     % the metric you want to use. e.g. 6 -> alphaKulczynski2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dataPath = 'result';
maxPercent = 0:0.05:0.1;    % same as the RQ1 setting
spsMetric = {'alphaTarantula','alphaOchiai','alphaDstar','alphaJaccard','alphaKulczynski1','alphaKulczynski2'};
pathDir = dir([dataPath, '/*_spec*']);
mkdir('result/RQ2Data');

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

% bmPathCell = {};
% for i = 1:numel(pathDir)
%     bmPathCell{end+1} = fullfile(pathDir(i).folder, pathDir(i).name, 'transDataProcessed');
%     bmDir = dir(fullfile(bmPathCell{i}, '*_auto_*_topkAnalyze'));
%     bmDataCell = cell(1, numel(bmDir));
% 
%     for f = 1:numel(bmDir)
%         configDir = dir(fullfile(bmDir(f).folder, bmDir(f).name, '*.mat'));
%         startidx = strfind(bmDir(f).name, 'percent_')+8;
%         endidx = strfind(bmDir(f).name, 'percent_')+11;
%         percentageNum = str2num(bmDir(f).name(startidx:endidx));
%         for matIdx = 1:numel(configDir)
%             if contains(configDir(matIdx).name, '_M_')
%                 continue
%             end
%             reg = load(fullfile(configDir(matIdx).folder, configDir(matIdx).name));
%             bmDataCell{f}.topkData = reg.topkData;
%             bmDataCell{f}.areaArr = reg.areaArr;
%             bmDataCell{f}.percentageNum = percentageNum;
%         end
%         % movefile(fullfile(bmDir(f).folder, bmDir(f).name), fullfile(pathDir(i).folder, pathDir(i).name, 'RQ1preprocessdata'));
%     end
% 
%     bmmatName = ['result/RQ2Data/', pathDir(i).name, '_FLinfo.mat'];
%     save(bmmatName, 'bmDataCell')
%     fprintf('Benchmark %s finished!\n', pathDir(i).name)
% end
% 
% for bmIdx = 1:numel(bmCell)
%     bmFileName = bmCell{bmIdx}{1};
%     blankidx = strfind(bmFileName, '_');
%     bmInfo = bmCell{bmIdx};
%     bmName = bmInfo{1};
%     nnStru = bmInfo{2};
%     bm = bmName(1:strfind(bmName, '#')-1);
%     spec = str2num(bmName(strfind(bmName, '}^{')+3));
%     bmFolderName = sprintf('%s_%d_%d_spec%d', bm, numel(nnStru), nnStru(1), spec);
%     bmPath = fullfile(dataPath, bmFolderName);
% 
%     path = fullfile(bmPath, 'transDataProcessed', 'onlyPTK*');
%     pathFolder = dir(path);
% 
%     pathNameCell = {};
%     for k = 1:numel(bmCell{bmIdx}{3})
%         for time = 1:numel(bmCell{bmIdx}{4})
%             pathNameCell{end+1} = sprintf('onlyPTK_%d %d_percent_0.00_topkAnalyze', bmCell{bmIdx}{4}(time), bmCell{bmIdx}{3}(k));
%         end
%     end
% 
%     bmDataCell = cell(1, numel(pathNameCell));
%     for f = 1:numel(pathNameCell) 
%         regname = dir(fullfile(pathFolder(1).folder, pathNameCell{f}, '*.mat'));
%         reg = load(fullfile(regname(1).folder, regname(1).name));
%         bmDataCell{f}.topkData = reg.topkData;
%         bmDataCell{f}.areaArr = reg.areaArr;
%         % movefile(fullfile(pathFolder(1).folder, pathNameCell{f}), fullfile(bmPath, 'RQ1preprocessdata'));
%     end
% 
%     bmmatName = ['result/RQ2Data/', bmFolderName, '_FLinfo_onlyPTK.mat'];
%     save(bmmatName, 'bmDataCell')
%     fprintf('Benchmark %s finished!\n', bmFolderName)
% end
% 
rqDir = dir('result/RQ2Data/*.mat');
diffPercentArea = cell(1,numel(maxPercent));
for i = 1:numel(bmCell)
    bmInfo = bmCell{i};
    bmName = bmInfo{1};
    networkStru = bmInfo{2};
    bm = bmName(1:strfind(bmName, '#')-1);
    spec = str2num(bmName(strfind(bmName, '}^{')+3));
    bmFileName = sprintf('%s_%d_%d_spec%d_FLinfo.mat', bm, numel(networkStru), networkStru(1), spec);
    filename_reg = fullfile(rqDir(i).folder, bmFileName);

    reg = load(filename_reg);

    for idx = 1:numel(reg.bmDataCell)
        perIdx = round(reg.bmDataCell{idx}.percentageNum/0.05) + 1;
        if isempty(diffPercentArea{perIdx})
            diffPercentArea{perIdx}.areaPage_20p = [];
        end
        diffPercentArea{perIdx}.areaPage_20p = cat(3, diffPercentArea{perIdx}.areaPage_20p, reg.bmDataCell{idx}.areaArr(:,:,1));
    end
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

rqDir = dir('result/RQ2Data/*_onlyPTK.mat');
ptkData = {};
for i = 1:numel(rqDir)
    filename_reg = fullfile(rqDir(i).folder, rqDir(i).name);
    reg = load(filename_reg);

    ptkData{end+1} = [];
    for idx = 1:numel(reg.bmDataCell)
        ptkData{1,i} = cat(2, ptkData{1,i}, reg.bmDataCell{idx}.areaArr(6,4,1));
    end
    ptkData{1,i} = reshape(ptkData{1,i}, [3 3]);
end

RQ2filename = fullfile(dataPath, sprintf('RQ2Data_%s.mat', spsMetric{metIdx}));

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

allCriteriaData = cat(2, inaData, itkData, pna_arr_data, ptk_arr_data, pd_arr_int, nd_arr_int, miData, mdData);
save(RQ2filename, 'inaData', 'itkData', 'pna_arr', 'ptkData', 'pd_arr', 'nd_arr', 'miData', 'mdData', 'allCriteriaData');