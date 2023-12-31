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

titleCell = {};
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
    
    data = analyzeData.topkData(3,:,topsNum);
    f = figure;
    x = 1:numel(covMetric)+1;
    b = bar(x, data,'FaceColor', 'flat');
    % barColor = {'#B22222', '#2E8B57','#B22222', '#2E8B57','#B22222', '#2E8B57','#B22222', '#2E8B57','#B22222'};
    cmap = [0.57, 0.69, 0.30
             0.89, 0.88, 0.57
             0.76, 0.49, 0.58
             0.47, 0.76, 0.81
             0.28, 0.57, 0.54
             0.07, 0.35, 0.40
             0.41, 0.20, 0.42
             0.60, 0.24, 0.18
             0, 0, 0];

    for i = 1:numel(covMetric)+1
       b.CData(i,:) = cmap(i,:);
    end

    xlabel('different coverage criterion')
    ylabel('detection rate DR')
    xticklabels(["INA", "ITK", "PNA", "PTK", "PD", "ND", "MI", "MD", "Random"]);
    yticks(0:0.1:1);
    ylim([0 1])
    yticklabels(0:10:100)
    set(gca,'FontSize',15);

    titleCell{end+1} = titleName;
    title(titleName, 'Interpreter','latex', 'FontSize', 18, 'FontName','Times New Roman'); 
    
    savepath = 'regFig';
    exportgraphics(f, fullfile(savepath, [figFilename, '.jpg']));
    savefig(f, fullfile(savepath, figFilename));    
end

