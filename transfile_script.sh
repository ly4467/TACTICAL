#!/bin/sh
csv=$1
matlab -nodesktop -nosplash <<EOF

clear;
close all;
clc;
bdclose('all');
addpath(genpath('/Users/ly/Desktop/TACTICAL'));
addpath(genpath('/Users/ly/Desktop'));

path = '~/mut2_liyi';
folderPath = dir(path);
newfolder = [path, '_prepared'];
mkdir(newfolder)

for i = 1:numel(folderPath)
    targetFile = fullfile(folderPath(i).folder, folderPath(i).name);
    transData_multi(targetFile, 1);
    movefile(fullfile(targetFile, 'transDataProcessed'), fullfile(newfolder, folderPath(i).name))
end

quit force
EOF  