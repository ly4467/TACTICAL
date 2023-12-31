clear;
close all;
clc;
bdclose('all');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd /[pathtoTACTICAL]
addpath(genpath('/[pathtoTACTICAL]'));

% the path of mutation info data
path = '';  % enter the path of dataset
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

spsMetric = {'alphaTarantula','alphaOchiai','alphaDstar','alphaJaccard','alphaKulczynski1','alphaKulczynski2'};
covMetric = {'nc','tkc','tnc','ttk','pd','nd','mi','md'}; 

valRateCell = {};
for bmIdx = 1:numel(bmCell)
    nnStruInfo = bmCell{bmIdx}{2};
    bmName = bmCell{bmIdx}{1};
    topsNum = round(sum(nnStruInfo)*0.2);
    bm = bmName(1:strfind(bmName, '#')-1);
    spec = str2num(bmName(strfind(bmName, '}^{')+3));
    titleName = ['$\mathbf{', bm, '\#', bmName(strfind(bmName, '#')+1), '{-}\varphi_{', num2str(spec), '}}$'];
    
    figFilename = sprintf('%s_%d_%d_spec%d', bm, numel(nnStruInfo), nnStruInfo(1), spec);
    dirName = dir(fullfile(fullfile(path, figFilename, 'transDataProcessed'), '*_topkAnalyze'));
    configPath = fullfile(dirName(1).folder, dirName(1).name);
    analyzeFilePath = dir(fullfile(configPath, '*.mat'));
    analyzeData = load(fullfile(configPath, analyzeFilePath(1).name));
    
    valRateCell{end+1} = analyzeData.topkData(:,:,topsNum);
    writematrix(round(valRateCell{bmIdx}*100, 1), sprintf('valRateCell_20p_%s.csv', figFilename));
end

