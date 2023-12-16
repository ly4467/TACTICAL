clear;
close all;
clc;
bdclose('all');
cd /Users/ly/Desktop/new-project 
addpath(genpath('/Users/ly/Desktop/new-project'));

%% configures
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
automode = 0;  
dataFolder = 'src/spectacle_val';

% when automode=0, set parameters manually  
bmName = 'WT#1 S_{WT}^{1}';
actParam = {['m'],['s'],['s' 'm'],['m' 'm'],['m' 'm'],['s' 'l'],['l'],['l']};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% main part
randTimes = 200;
maxPercent = 0:0.05:0.1;
transData_mode = 1;     % 1(spectacle)/2(covfl)

if automode == 1
    % {benchmark name, nn Structure, topk, timeint_TNCTTK, timeint_PDND, timeint_MIMD}
    % If you dont have the data of certain benchmark, you can let
    % bmName_ACC1_spec1 = {} to skip the validation of this benchmark

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
    bmCell = {bmName_ACC1_spec1, bmName_ACC1_spec2, bmName_ACC2_spec1, bmName_ACC2_spec2, bmName_AFC1_spec1, bmName_AFC1_spec2, bmName_AFC2_spec1, bmName_AFC2_spec2, bmName_WT1_spec1, bmName_WT2_spec1, bmName_SC1_spec1, bmName_SC2_spec1};
    bmInfo = [];
elseif automode == 0


    bmName_ACC1_spec1 = {'ACC#1 S_{ACC}^{1}', [10 10 10 10], [2 3 4], [5 10 15], [5 10 15], [5 10 15]};
    bmName_ACC1_spec2 = {'ACC#1 S_{ACC}^{2}', [10 10 10 10], [2 3 4], [5 10 15], [5 10 15], [5 10 15]};
    bmName_ACC2_spec1 = {'ACC#2 S_{ACC}^{1}', [15 15 15], [3 4 5], [5 10 15], [5 10 15], [5 10 15]};
    bmName_ACC2_spec2 = {'ACC#2 S_{ACC}^{2}', [15 15 15], [3 4 5], [5 10 15], [5 10 15], [5 10 15]};
    bmName_AFC1_spec1 = {'AFC#1 S_{AFC}^{1}', [15 15 15], [3 4 5], [5 10 15], [5 10 15], [5 10 15]};
    bmName_AFC1_spec2 = {'AFC#1 S_{AFC}^{2}', [15 15 15], [3 4 5], [5 10 15], [5 10 15], [5 10 15]};
    bmName_AFC2_spec1 = {'AFC#2 S_{AFC}^{1}', [15 15 15 15], [3 4 5], [5 10 15], [5 10 15], [5 10 15]};
    bmName_AFC2_spec2 = {'AFC#2 S_{AFC}^{2}', [15 15 15 15], [3 4 5], [5 10 15], [5 10 15], [5 10 15]};
    bmName_WT1_spec1 = {'WT#1 S_{WT}^{1}', [5 5 5], [1 2 3], [5 10 15], [5 10 15], [5 10 15]};
    bmName_WT2_spec1 = {'WT#2 S_{WT}^{1}', [15 15 15], [3 4 5], [5 10 15], [5 10 15], [5 10 15]};
    bmName_SC1_spec1 = {'SC#1 S_{SC}^{1}', [10 10 10 10], [2 3 4], [5 10 15], [5 10 15], [5 10 15]};
    bmName_SC2_spec1 = {'SC#2 S_{SC}^{1}', [15 15 15 15], [2 3 4], [5 10 15], [5 10 15], [5 10 15]};
    bmCell = {bmName_ACC1_spec1, bmName_ACC1_spec2, bmName_ACC2_spec1, bmName_ACC2_spec2, bmName_AFC1_spec1, bmName_AFC1_spec2, bmName_AFC2_spec1, bmName_AFC2_spec2, bmName_WT1_spec1, bmName_WT2_spec1, bmName_SC1_spec1, bmName_SC2_spec1};

    fileconfig = sprintf('_NC_%s_TK_%s_TNC_%s %s_TTK_%s %s_PD_%s %s_ND_%s %s_MI_%s_MD_%s', actParam{1}, actParam{2}, actParam{3}(1), actParam{3}(2), actParam{4}(1), actParam{4}(2), actParam{5}(1), actParam{5}(2), actParam{6}(1), actParam{6}(2), actParam{7}, actParam{8});
    bmInfo = {bmName, actParam, fileconfig};

    for i = 1:numel(bmCell)
        if strcmp(bmCell{i}{1}, bmName)
            bmInfo{end+1} = bmCell{i}(2:end);
        end
    end
else
    error('automode error!')
end
parallelAnalyzeDiffParam(bmCell, bmInfo, maxPercent, dataFolder, transData_mode, randTimes)
    