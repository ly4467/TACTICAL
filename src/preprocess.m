clear;
close all;
clc;
bdclose('all');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd /[pathtoTACTICAL]
addpath(genpath('/[pathtoTACTICAL]'));
dataFolder = 'result/mut1';
automode = 1;   % 1 auto/ 0 manual

% 'mutNum = 1' for only 1 mutant fault localization
% 'mutNum = 2' for 2 mutants fault localization
% 'mutNum = 123' for the synthesize of 1(mutant) + 2(mutants) + 3(mutants) fault localization
mutNum = 123;

% when automode=0, set parameters manually  
bmName = 'ACC#1 S_{ACC}^{1}';
% parameter has small/medium/large 3 levels
actParam = {['s'],['l'],['s' 's'],['l' 's'],['s' 's'],['s' 's'],['s'],['l']};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% main part
randTimes = 200;
maxPercent = 0:0.05:0.1;
transData_mode = 2;

if automode == 1
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
    bmInfo = [];

elseif automode == 0
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

    fileconfig = sprintf('_INA_%s_ITK_%s_PNA_%s %s_PTK_%s %s_PD_%s %s_ND_%s %s_MI_%s_MD_%s', actParam{1}, actParam{2}, actParam{3}(1), actParam{3}(2), actParam{4}(1), actParam{4}(2), actParam{5}(1), actParam{5}(2), actParam{6}(1), actParam{6}(2), actParam{7}, actParam{8});
    bmInfo = {bmName, actParam, fileconfig};

    for i = 1:numel(bmCell)
        if strcmp(bmCell{i}{1}, bmName)
            bmInfo{end+1} = bmCell{i}(2:end);
        end
    end
else
    error('automode error!')
end

parallelAnalyzeDiffParam_multi(bmCell, bmInfo, maxPercent, dataFolder, transData_mode, randTimes, mutNum)
    