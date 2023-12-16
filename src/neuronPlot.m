clear;
close all;
clc;
bdclose('all');
cd /Users/ly/Desktop/new-project
addpath(genpath('/Users/ly/Desktop/new-project'));

path = 'src/spectacle_val/SC_4_10_spec1_spectacleData';
nnStru = [10 10 10 10];
path = fullfile(path, 'transDataProcessed');

pool = gcp('nocreate');
if ~isempty(pool)
     delete(pool);
end
pool = parpool([2 10]);

savefigPath = fullfile(path, 'neuronoutFig');
mkdir(savefigPath);
filelist = dir(fullfile(path, '*_M_*.mat'));
plotSignum = 3;

parfor f = 1:numel(filelist)
    [bm, ~, layer, idx, j, ~] = readFileName(fullfile(filelist(f).folder, filelist(f).name));
    regData = load(fullfile(filelist(f).folder, filelist(f).name));

    figCell = {};
    figNum = fix(numel(regData.sig_stateAll)/16);
    if figNum > 2
        figNum = 2
    end
    for figidx = 1:figNum
        figCell{end+1} = figure;
        figure(figCell{figidx})

        t = tiledlayout(4,4);
        sigRange = [num2str(16*figidx-15), '-', num2str(16*figidx)];
        figTitle = sprintf('Mutated Benchmark: %s,  Layer%d,  Index%d,  signal%s', bm, layer, idx, sigRange);
        title(t, figTitle, 'FontSize', 16, 'FontWeight', 'bold', 'Interpreter', 'none')

        ax = {};
        for sig = (16*figidx-15):(16*figidx)
            endtime = int32((regData.sig_stateAll{sig}.tau_s / 0.1) + 1);
            outval = zeros(1, endtime);
            for time = 1:endtime
                outval(time) = regData.sig_stateAll{sig}.nn_hidden_out{time,layer}(idx);
            end

            axidx = sig+16-figidx*16;
            ax{end+1} = nexttile(axidx);
            x = 1:endtime;

            neuronOut = plot(ax{axidx}, x, outval);
            titleName = ['Signal.', num2str(sig), '  taus: ', num2str(regData.sig_stateAll{sig}.tau_s), ',  rob:', num2str(regData.sig_stateAll{sig}.rob)];
            title(ax{axidx}, titleName, 'FontSize', 16, 'FontWeight', 'bold', 'Interpreter', 'none');
            lgd = legend(ax{axidx}, 'neuron output');
            lgd.FontSize = 12;
            lgd.Box = 'off';
            lgd.Location = 'southeast';
        end

        figFilename = sprintf( [filelist(f).name(1:end-4), '_sig_%s', '_fig%d'],  sigRange, figidx);
        savefig(figCell{figidx}, fullfile(savefigPath, figFilename));
        % close figCell{figidx};
    end

    if layer <= numel(nnStru-1)
        neuronsfigCell = cell(1,numel(nnStru));
        for li = layer:numel(nnStru)
            neuronsfigCell{li} = {};
            for sig = 1:plotSignum
                neuronsfigCell{li}{end+1} = figure;
        
                figure(neuronsfigCell{li}{sig})
                t = tiledlayout(4,4);
                figTitle = sprintf('Mutated Benchmark: %s, Layer%d, Index%d, signal%d', bm, li, idx, sig);
                subfigTitle = sprintf('All Layer%d neurons output, taus:%.1f, rob:%.1f', li, regData.sig_stateAll{sig}.tau_s, regData.sig_stateAll{sig}.rob);
                title(t, figTitle, subfigTitle, 'FontSize', 16, 'FontWeight', 'bold', 'Interpreter', 'none')
        
                endtime = int32((regData.sig_stateAll{sig}.tau_s / 0.1) + 1);
                outval = zeros(numel(regData.sig_stateAll{sig}.nn_hidden_out{1,li}), endtime);
                neuronAx = {};
                for time = 1: endtime
                    outval(:,time) = regData.sig_stateAll{sig}.nn_hidden_out{time,li};
                end
        
                for neuron = 1:numel(regData.sig_stateAll{sig}.nn_hidden_out{1,li})
                    neuronAx{end+1} = nexttile(neuron);
                    x = 1:endtime;
                    y = outval(neuron,:);
        
                    neuronOut = plot(neuronAx{neuron}, x, y);
                    titleName = ['Layer', num2str(li), ' neuron', num2str(neuron)];
                    title(neuronAx{neuron}, titleName, 'FontSize', 16, 'FontWeight', 'bold', 'Interpreter', 'none');
                    lgd = legend(neuronAx{neuron}, 'neuron output');
                    lgd.FontSize = 12;
                    lgd.Box = 'off';
                    lgd.Location = 'southeast';
                end
                figFilename = sprintf( [filelist(f).name(1:end-4), '_allLayer%d_sig_%d'], li, sig);
                savefig(neuronsfigCell{li}{sig}, fullfile(savefigPath, figFilename));
                fprintf('%s complete!\n', figFilename);
                % close neuronsfigCell{sig};
            end
        end
    else
        neuronsfigCell = {};
        for sig = 1:plotSignum
            neuronsfigCell{end+1} = figure;
    
            figure(neuronsfigCell{sig})
            t = tiledlayout(4,4);
            figTitle = sprintf('Mutated Benchmark: %s, Layer%d, Index%d, signal%d', bm, layer, idx, sig);
            subfigTitle = sprintf('All Layer%d neurons output, taus:%.1f, rob:%.1f', layer, regData.sig_stateAll{sig}.tau_s, regData.sig_stateAll{sig}.rob);
            title(t, figTitle, subfigTitle, 'FontSize', 16, 'FontWeight', 'bold', 'Interpreter', 'none')
    
            endtime = int32((regData.sig_stateAll{sig}.tau_s / 0.1) + 1);
            outval = zeros(numel(regData.sig_stateAll{sig}.nn_hidden_out{1,layer}), endtime);
            neuronAx = {};
            for time = 1: endtime
                outval(:,time) = regData.sig_stateAll{sig}.nn_hidden_out{time,layer};
            end
    
            for neuron = 1:numel(regData.sig_stateAll{sig}.nn_hidden_out{1,layer})
                neuronAx{end+1} = nexttile(neuron);
                x = 1:endtime;
                y = outval(neuron,:);
    
                neuronOut = plot(neuronAx{neuron}, x, y);
                titleName = ['Layer', num2str(layer), ' neuron', num2str(neuron)];
                title(neuronAx{neuron}, titleName, 'FontSize', 16, 'FontWeight', 'bold', 'Interpreter', 'none');
                lgd = legend(neuronAx{neuron}, 'neuron output');
                lgd.FontSize = 12;
                lgd.Box = 'off';
                lgd.Location = 'southeast';
            end
            figFilename = sprintf( [filelist(f).name(1:end-4), '_allLayer%d_sig_%d'], layer, sig);
            savefig(neuronsfigCell{sig}, fullfile(savefigPath, figFilename));
            % close neuronsfigCell{sig};
        end
    end
end


%% Original neuron output plotting codes, Do not delete!
savefigPath = fullfile(path, 'neuronoutFigNoMut');
mkdir(savefigPath);

fileNoMut = dir(fullfile(path, '*_nomutation.mat'));
regData = load(fullfile(fileNoMut(1).folder, fileNoMut(1).name));
layerNum = size(regData.sig_state{1}.nn_hidden_out, 2);
figCellNoMut = cell(1,layerNum);
plotSignum = 32;

parfor layerIdx = 1:layerNum
    figCellNoMut{layerIdx} = {};
    for sig = 1:plotSignum
        figCellNoMut{layerIdx}{end+1} = figure;
        figure(figCellNoMut{layerIdx}{sig})

        t = tiledlayout(4,4);
        figTitle = sprintf('No mutation original neuron output  Layer%d, Signal%d', layerIdx, sig);
        title(t, figTitle, 'FontSize', 16, 'FontWeight', 'bold', 'Interpreter', 'none')     

        endtime = int32((regData.sig_state{sig}.tau_s / 0.1) + 1);
        outval = zeros(numel(regData.sig_state{sig}.nn_hidden_out{1,layerIdx}), endtime);
        neuronAx = {};
        for time = 1: endtime
            outval(:,time) = regData.sig_state{sig}.nn_hidden_out{time,layerIdx};
        end

        for neuron = 1:numel(regData.sig_state{sig}.nn_hidden_out{1,layerIdx})
            neuronAx{end+1} = nexttile(neuron);
            x = 1:endtime;
            y = outval(neuron,:);

            neuronOut = plot(neuronAx{neuron}, x, y);
            titleName = ['Layer', num2str(layerIdx), ' neuron', num2str(neuron)];
            title(neuronAx{neuron}, titleName, 'FontSize', 16, 'FontWeight', 'bold', 'Interpreter', 'none');
            lgd = legend(neuronAx{neuron}, 'neuron output');
            lgd.FontSize = 12;
            lgd.Box = 'off';
            lgd.Location = 'southeast';
        end
        figFilename = sprintf( [fileNoMut(1).name(1:end-4), '_layer%d_sig%d'], layerIdx, sig);
        savefig(figCellNoMut{layerIdx}{sig}, fullfile(savefigPath, figFilename))
        fprintf('Layer%d, Signal%d complete!\n', layerIdx, sig);
        % close figCellNoMut{layerIdx}{sig}
    end
end



    


