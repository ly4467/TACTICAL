clear;
close all;
clc;
bdclose('all');
cd /Users/ly/Desktop/new-project
addpath(genpath('/Users/ly/Desktop/new-project'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dataPath = 'src/finalresult';
smlPercent = [0 0.15 0.3];
maxPercent = 0:0.05:0.3;    % same as the RQ1 setting
metIdx = 6;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

spsMetric = {'alphaTarantula','alphaOchiai','alphaDstar','alphaJaccard','alphaKulczynski1','alphaKulczynski2'};
covMetric = {'nc','tkc','tnc','ttk','pd','nd','mi','md'};
pathDir = dir([dataPath, '/*_spec*']);
mkdir('result/RQ2RQ3');

% pool = gcp('nocreate');
% % if a parallel pool exists, delete it
% if ~isempty(pool)
% 	delete(pool);
% end
% % create a new parallel pool with the desired configuration
% pool = parpool([2 10]);
% 
% bmPathCell = {};
% rqDataCell = cell(1,3);    % According to s/m/l data
% for i = 1:numel(pathDir)
% 
%     bmPathCell{end+1} = fullfile(pathDir(i).folder, pathDir(i).name, 'transDataProcessed');
%     bmDir = dir(fullfile(bmPathCell{i}, '*_auto_*_topkAnalyze'));
%     bmDataCell = cell(1, numel(bmDir));
% 
%     parfor f = 1:numel(bmDir)
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
%             bmDataCell{f}.areaArr = reg.areaArr;     % Take the 25% data page
%             bmDataCell{f}.percentageNum = percentageNum;
%         end
%     end
% 
%     bmmatName = ['result/RQ2RQ3/', pathDir(i).name, '_FLinfo.mat'];
%     save(bmmatName, 'bmDataCell')
%     fprintf('Benchmark %s finished!\n', pathDir(i).name)
%     clear bmDataCell
% end
% delete(pool);

rqDir = dir('result/RQ2RQ3/*.mat');

diffPercentArea = cell(1,numel(maxPercent));
for i = 1:numel(rqDir)
    reg = load(fullfile(rqDir(i).folder, rqDir(i).name));

    for idx = 1:numel(reg.bmDataCell)
        perIdx = round(reg.bmDataCell{idx}.percentageNum/0.05) + 1;
        if isempty(diffPercentArea{perIdx})
            diffPercentArea{perIdx}.areaPage_20p = [];
            diffPercentArea{perIdx}.areaPage_all = [];
        end
        diffPercentArea{perIdx}.areaPage_20p = cat(3, diffPercentArea{perIdx}.areaPage_20p, reg.bmDataCell{idx}.areaArr(:,:,1));
        diffPercentArea{perIdx}.areaPage_all = cat(3, diffPercentArea{perIdx}.areaPage_all, reg.bmDataCell{idx}.areaArr(:,:,2));
    end
    clear reg
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


ncData_Dstar_mean = reshape(smallData_20p(metIdx,1,:), [numel(pathDir) numel(maxPercent)]);
tkData_Dstar = cat(2, reshape(smallData_20p(metIdx,2,1:numel(pathDir)), [numel(pathDir) 1]), reshape(mediumData_20p(metIdx,2,1:numel(pathDir)), [numel(pathDir) 1]), reshape(largeData_20p(metIdx,2,1:numel(pathDir)), [numel(pathDir) 1]));

tncData_Dstar_s = reshape(smallData_20p(metIdx,3,:), [numel(pathDir) numel(maxPercent)]);
tncData_Dstar_m = reshape(mediumData_20p(metIdx,3,:), [numel(pathDir) numel(maxPercent)]);
tncData_Dstar_l = reshape(largeData_20p(metIdx,3,:), [numel(pathDir) numel(maxPercent)]);
tncData_Dstar_Page = cat(3, tncData_Dstar_s, tncData_Dstar_m, tncData_Dstar_l);
tncData_Dstar_mean = mean(tncData_Dstar_Page, 3);

pdData_Dstar_s = reshape(smallData_20p(metIdx,5,:), [numel(pathDir) numel(maxPercent)]);
pdData_Dstar_m = reshape(mediumData_20p(metIdx,5,:), [numel(pathDir) numel(maxPercent)]);
pdData_Dstar_l = reshape(largeData_20p(metIdx,5,:), [numel(pathDir) numel(maxPercent)]);
pdData_Dstar_Page = cat(3, pdData_Dstar_s, pdData_Dstar_m, pdData_Dstar_l);
pdData_Dstar_mean = mean(pdData_Dstar_Page, 3);

ndData_Dstar_s = reshape(smallData_20p(metIdx,6,:), [numel(pathDir) numel(maxPercent)]);
ndData_Dstar_m = reshape(mediumData_20p(metIdx,6,:), [numel(pathDir) numel(maxPercent)]);
ndData_Dstar_l = reshape(largeData_20p(metIdx,6,:), [numel(pathDir) numel(maxPercent)]);
ndData_Dstar_Page = cat(3, ndData_Dstar_s, ndData_Dstar_m, ndData_Dstar_l);
ndData_Dstar_mean = mean(ndData_Dstar_Page, 3);

miData_Dstar = cat(2, reshape(smallData_20p(metIdx,7,1:numel(pathDir)), [numel(pathDir) 1]), reshape(mediumData_20p(metIdx,7,1:numel(pathDir)), [numel(pathDir) 1]), reshape(largeData_20p(metIdx,7,1:numel(pathDir)), [numel(pathDir) 1]));
mdData_Dstar = cat(2, reshape(smallData_20p(metIdx,8,1:numel(pathDir)), [numel(pathDir) 1]), reshape(mediumData_20p(metIdx,8,1:numel(pathDir)), [numel(pathDir) 1]), reshape(largeData_20p(metIdx,8,1:numel(pathDir)), [numel(pathDir) 1]));
mimdData_met = {};
for lineIdx = 1:size(miData_Dstar,1)
    mimdData_met{end+1} = cat(1, miData_Dstar(lineIdx,:), mdData_Dstar(lineIdx,:));
end

pageArr = cat(3, ncData_Dstar_mean, tncData_Dstar_mean, pdData_Dstar_mean, ndData_Dstar_mean);
bmDataCell = cell(1,4);
for bmIdx = 1:size(pageArr,1)
    bmDataCell{bmIdx} = [];
    for p = 1:size(pageArr, 3)
        bmDataCell{bmIdx} = cat(1, bmDataCell{bmIdx}, pageArr(bmIdx,:,p));
    end
end

tnc_arr = cell(1,10);
for sz = 1:size(tncData_Dstar_Page,1)
    tnc_arr{sz} = [];
    for bm = 1:size(tncData_Dstar_Page(sz,:,:), 3)
        tnc_arr{sz} = cat(1, tnc_arr{sz}, tncData_Dstar_Page(sz, :, bm));
    end  
end
pd_arr = cell(1,10);
for sz = 1:size(pdData_Dstar_Page,1)
    pd_arr{sz} = [];
    for bm = 1:size(pdData_Dstar_Page(sz,:,:), 3)
        pd_arr{sz} = cat(1, pd_arr{sz}, pdData_Dstar_Page(sz, :, bm));
    end  
end
nd_arr = cell(1,10);
for sz = 1:size(ndData_Dstar_Page,1)
    nd_arr{sz} = [];
    for bm = 1:size(ndData_Dstar_Page(sz,:,:), 3)
        nd_arr{sz} = cat(1, nd_arr{sz}, ndData_Dstar_Page(sz, :, bm));
    end  
end
