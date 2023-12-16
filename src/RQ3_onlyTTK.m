clear;
close all;
clc;
bdclose('all');
cd /Users/ly/Desktop/new-project
addpath(genpath('/Users/ly/Desktop/new-project'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dataPath = 'src/ttkdatafile';
smlPercent = [0 0.15 0.3];
maxPercent = 0:0.05:0.3;    % same as the RQ1 setting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

spsMetric = {'alphaTarantula','alphaOchiai','alphaDstar','alphaJaccard','alphaKulczynski1','alphaKulczynski2'};
covMetric = {'nc','tkc','tnc','ttk','pd','nd','mi','md'};
pathDir = dir([dataPath, '/*_spec*']);
mkdir('result/RQ2ttk');

% bmName_ACC1_spec1 = {'ACC#1 S_{ACC}^{1}', [10 10 10 10], [2 3 4], [5 10 15], [5 10 15], [5 10 15]};
% bmName_ACC1_spec2 = {'ACC#1 S_{ACC}^{2}', [10 10 10 10], [2 3 4], [5 10 15], [5 10 15], [5 10 15]};
% bmName_ACC2_spec1 = {'ACC#2 S_{ACC}^{1}', [15 15 15], [3 4 5], [5 10 15], [5 10 15], [5 10 15]};
% bmName_ACC2_spec2 = {'ACC#2 S_{ACC}^{2}', [15 15 15], [3 4 5], [5 10 15], [5 10 15], [5 10 15]};
% bmName_AFC1_spec1 = {'AFC#1 S_{AFC}^{1}', [15 15 15], [3 4 5], [5 10 15], [5 10 15], [5 10 15]};
% bmName_AFC1_spec2 = {'AFC#1 S_{AFC}^{2}', [15 15 15], [3 4 5], [5 10 15], [5 10 15], [5 10 15]};
% bmName_AFC2_spec1 = {'AFC#2 S_{AFC}^{1}', [15 15 15 15], [3 4 5], [5 10 15], [5 10 15], [5 10 15]};
% bmName_AFC2_spec2 = {'AFC#2 S_{AFC}^{2}', [15 15 15 15], [3 4 5], [5 10 15], [5 10 15], [5 10 15]};
% bmName_WT1_spec1 = {'WT#1 S_{WT}^{1}', [5 5 5], [1 2 3], [5 10 15], [5 10 15], [5 10 15]};
% bmName_WT2_spec1 = {'WT#2 S_{WT}^{1}', [15 15 15], [3 4 5], [5 10 15], [5 10 15], [5 10 15]};
% bmName_SC1_spec1 = {'SC#1 S_{SC}^{1}', [10 10 10 10], [2 3 4], [5 10 15], [5 10 15], [5 10 15]};
% bmName_SC2_spec1 = {'SC#2 S_{SC}^{1}', [15 15 15 15], [2 3 4], [5 10 15], [5 10 15], [5 10 15]};
% bmCell = {bmName_ACC1_spec1, bmName_ACC1_spec2, bmName_ACC2_spec1, bmName_ACC2_spec2, bmName_AFC1_spec1, bmName_AFC1_spec2, bmName_AFC2_spec1, bmName_AFC2_spec2, bmName_WT1_spec1, bmName_WT2_spec1, bmName_SC1_spec1, bmName_SC2_spec1};
% 
% bmPathCell = {};
% rqDataCell = cell(1,3);
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
%     path = fullfile(bmPath, 'transDataProcessed', '*_0_*');
%     pathFolder = dir(path);
% 
%     pathNameCell = {};
%     for k = 1:numel(bmCell{bmIdx}{3})
%         for time = 1:numel(bmCell{bmIdx}{4})
%             pathNameCell{end+1} = sprintf('NC_0_TK_%d_TNC_%d 0_TTK_%d %d_PDND_%d 0_MIMD_%d_topkAnalyze', bmCell{bmIdx}{3}(k), bmCell{bmIdx}{4}(time), bmCell{bmIdx}{4}(time), bmCell{bmIdx}{3}(k), bmCell{bmIdx}{5}(k), bmCell{bmIdx}{6}(k));
%         end
%     end
% 
%     bmDataCell = cell(1, numel(pathNameCell));
%     for f = 1:numel(pathNameCell) 
%         regname = dir(fullfile(pathFolder(1).folder, pathNameCell{f}, '*.mat'));
%         reg = load(fullfile(regname(1).folder, regname(1).name));
%         bmDataCell{f}.topkData = reg.topkData;
%         bmDataCell{f}.areaArr = reg.areaArr;
%         clear reg
%     end
% 
%     bmmatName = ['result/RQ2ttk/', bmFolderName, '_FLinfo.mat'];
%     save(bmmatName, 'bmDataCell')
%     fprintf('Benchmark %s finished!\n', bmFolderName)
% end


rqDir = dir('result/RQ2ttk/*.mat');
diffttkCell = {};
for i = 1:numel(rqDir)
    reg = load(fullfile(rqDir(i).folder, rqDir(i).name));
    diffttkCell{end+1} = [];
    for idx = 1:numel(reg.bmDataCell)
        diffttkCell{1,i} = cat(2, diffttkCell{1,i}, reg.bmDataCell{idx}.areaArr(6,4,1));
    end

    % 检查一下对应关系
    diffttkCell{1,i} = reshape(diffttkCell{1,i}, [3 3]);
    clear reg
end

diffttkCell


