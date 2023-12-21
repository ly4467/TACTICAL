clear;
close all;
clc;
bdclose('all');
cd /Users/ly/Desktop/new-project 
addpath(genpath('/Users/ly/Desktop/new-project'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
path = 'result/bestResults';
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
   
bmNameCell = {};
for f = 1:numel(bmCell)
   % get the path of each benchmark
    bmName = bmCell{f}{1};
    nnStru = bmCell{f}{2};
    bm = bmName(1:strfind(bmName, '#')-1);
    spec = str2num(bmName(strfind(bmName, '}^{')+3));
    bmMatName = sprintf('%s_%d_%d_spec%d.mat', bm, numel(nnStru), nnStru(1), spec);
    
    bmNameCell{end+1} = fullfile(path, bmMatName);
end
[RQ1_2_tab, RQ3_tab] = processBestData(bmNameCell);

