clear;
close all;
clc;
bdclose('all');
cd /Users/ly/Desktop/new-project
addpath(genpath('/Users/ly/Desktop/new-project'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% the path of mutation info data
path = 'result/30-Oct-2023-AFC_FFNN_trainlm_15_15_15_Apr_1_2020_M_spec_2_valFL_layer_1-3';
figname = 'AFC_3_15_spec2';     % the name of generated figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

filelist = dir(fullfile(path, '*.mat'));

rateList = [];
for f = 1:numel(filelist)
    if ~isempty(strfind(filelist(f).name, 'FL_info'))
        continue
    end
    filename = [filelist(f).folder, '/',filelist(f).name];
    load(filename);
    fprintf('Reading file:%s\n', filename)

    rateList(end+1) = sig_success_rate;
end

rateList = sort(rateList);
rateCell = cell(1,10);
rateNumList = zeros(1,10);
for i = 0:9
    idx = find((rateList<((i+1)/10)).*(rateList>=(i/10)));
    rateCell{i+1} = rateList(idx);
    rateNumList(i+1) = numel(rateCell{i+1}); 
end
rateCell{numel(rateCell)} = [rateCell{numel(rateCell)} rateList(find(rateList == 1))];
rateNumList(numel(rateCell)) = numel(rateCell{numel(rateCell)});

f = figure;
x = 1:10;
b = bar(x, rateNumList);
xlabel('Signal Success Rate')
ylabel('Neuron Numbers')
xticklabels(["0~0.1", "0.1~0.2", "0.2~0.3", "0.3~0.4", "0.4~0.5", "0.5~0.6", "0.6~0.7", "0.7~0.8", "0.8~0.9", "0.9~1"]);
yticks(1:100)

[t,s] = title(figname, 'Interpreter', 'none');

xtips = b.XEndPoints;
ytips = b.YEndPoints;
labels = string(b.YData);
text(xtips,ytips,labels,'HorizontalAlignment','center', 'VerticalAlignment','bottom')

% b.CData(:,:) = repmat([.86 .98 .96],12,1);
% b.CData(11:12,:) = repmat([.98 .78 .8],2,1);

print(f, figname, '-djpeg')