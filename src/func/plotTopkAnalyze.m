function areaArr = plotTopkAnalyze(savepath, plotmode, topkData, spsMetric, covMetric, bmName, netNeurons)
    
    if plotmode == 1
        topkRateCell = {};
        figCell = {};
        x = 0:netNeurons;
        areaTopkNum = {x(1:find(x == 0.2)), x};
        areaArr = zeros(numel(spsMetric), numel(covMetric)+1, numel(areaTopkNum));
              

        for sps = 1:numel(spsMetric)
            topkRateCell{end+1} = reshape(topkData(sps,:,:), [numel(covMetric)+1 netNeurons]);
            topkRateCell{sps} = cat(2, zeros(numel(covMetric)+1, 1), topkRateCell{sps});
            curveDataPage = reshape(topkRateCell{sps}',[1 size(topkRateCell{sps},2) numel(covMetric)+1]);
        
            figCell{end+1} = figure;
            figure(figCell{sps})
            covCurveCell = cell(1,(numel(covMetric)+1));

            ncData = curveDataPage(:,:,1);
            % 'LineWidth', 1.5, 'MarkerSize', 6
            covCurveCell{1} = plot(x, ncData, '-*', 'Color', '#B22222', 'LineWidth', 1.5, 'MarkerSize', 6);
            hold('on')
        
            tkData = curveDataPage(:,:,2);
            covCurveCell{2} = plot(x, tkData, '-.square', 'Color', [0.48235 0.40784 0.93333], 'LineWidth', 1.5, 'MarkerSize', 6);
            hold('on')
        
            tncData = curveDataPage(:,:,3);
            covCurveCell{3} = plot(x, tncData, '--diamond', 'Color', [0.11765 0.56741 1], 'LineWidth', 1.5, 'MarkerSize', 6);
            hold('on')
        
            ttkData = curveDataPage(:,:,4);
            covCurveCell{4} = plot(x, ttkData, '-^', 'Color', '#2E8B57', 'LineWidth', 1.5, 'MarkerSize', 6);
            hold('on')
        
            pdData = curveDataPage(:,:,5);
            covCurveCell{5} = plot(x, pdData, '--o', 'Color', '#FFA500', 'LineWidth', 1.5, 'MarkerSize', 6);
            hold('on')
        
            ndData = curveDataPage(:,:,6);
            covCurveCell{6} = plot(x, ndData, '-.o', 'Color', '#DC143C', 'LineWidth', 1.5, 'MarkerSize', 6);
            hold('on')
        
            miData = curveDataPage(:,:,7);
            covCurveCell{7} = plot(x, miData, '-^', 'Color', '#8B4513', 'LineWidth', 1.5, 'MarkerSize', 6);
            hold('on')
        
            mdData = curveDataPage(:,:,8);
            covCurveCell{8} = plot(x, mdData, '-x', 'Color', '#696969', 'LineWidth', 1.5, 'MarkerSize', 6);
            hold('on')
        
            randData = curveDataPage(:,:,9);
            covCurveCell{9} = plot(x, randData, ':x', 'LineWidth', 1.5, 'MarkerSize', 6);
            hold('off')

            for perIdx = 1:numel(areaTopkNum)
                areaArr(sps, 1, perIdx) = trapz(areaTopkNum{perIdx}, ncData(1:numel(areaTopkNum{perIdx})) );
                areaArr(sps, 2, perIdx) = trapz(areaTopkNum{perIdx}, tkData(1:numel(areaTopkNum{perIdx})) );
                areaArr(sps, 3, perIdx) = trapz(areaTopkNum{perIdx}, tncData(1:numel(areaTopkNum{perIdx})) );
                areaArr(sps, 4, perIdx) = trapz(areaTopkNum{perIdx}, ttkData(1:numel(areaTopkNum{perIdx})) );
                areaArr(sps, 5, perIdx) = trapz(areaTopkNum{perIdx}, pdData(1:numel(areaTopkNum{perIdx})) );
                areaArr(sps, 6, perIdx) = trapz(areaTopkNum{perIdx}, ndData(1:numel(areaTopkNum{perIdx})) );
                areaArr(sps, 7, perIdx) = trapz(areaTopkNum{perIdx}, miData(1:numel(areaTopkNum{perIdx})) );
                areaArr(sps, 8, perIdx) = trapz(areaTopkNum{perIdx}, mdData(1:numel(areaTopkNum{perIdx})) );
                areaArr(sps, 9, perIdx) = trapz(areaTopkNum{perIdx}, randData(1:numel(areaTopkNum{perIdx})) );
            end

            if strcmp(bmName(1:4), 'WT#1')
                xticks(0:2:netNeurons);
            else
                xticks(0:5:netNeurons);
            end

            yticks(0:0.2:1);
            xlim([0 netNeurons]);
            ylim([0 1]);
            yticklabels(0:20:100);
            set(gca,'FontSize',15);

            xlabel('s (#suspicious neurons)','FontSize',18, 'FontName','Times New Roman');
            ylabel('detection rate DR','FontSize',18, 'FontName','Times New Roman');
            
            lgd = legend('INA\qquad', 'ITK\qquad', 'PNA\qquad', 'PTK\qquad', 'PD\qquad', 'ND\qquad', 'MI\qquad', 'MD\qquad', 'Random');
            lgd.Box = 'off';
            set(lgd,'FontName','Times New Roman','FontSize',15 ,'FontWeight','normal', ...
                    'TextColor','black','orientation','horizontal', 'Interpreter', 'latex', ...
                    'Location', 'southeast', 'Visible', 'on', 'NumColumns', 1); 
            lgd.Visible = "on";
            
            bm = bmName(1:strfind(bmName, '#')-1);
            spec = str2num(bmName(strfind(bmName, '}^{')+3));
            regname = sprintf('%s#%s_spec%d', bm, bmName(strfind(bmName, '#')+1), spec);
            titleName = ['$\mathbf{', bm, '\#', bmName(strfind(bmName, '#')+1), '{-}\varphi_{', num2str(spec), '}}$'];
            title(titleName, 'Interpreter','latex', 'FontSize', 18, 'FontName','Times New Roman');       
            
            figFilename = sprintf('%s_%s', regname, spsMetric{sps});
            fig = gcf;
            fig.PaperPositionMode = 'auto';
            fig_pos = fig.PaperPosition;
            fig.PaperSize = [fig_pos(3), fig_pos(4)];
            exportgraphics(fig, fullfile(savepath, [figFilename, '.pdf']));
            savefig(figCell{sps}, fullfile(savepath, figFilename));
        end
        close all;
    % elseif plotmode == 2
    %     curveDataPage = [];
    %     for ana = 1:numel(topkData)
    %         reg = reshape(topkData{ana}(2,:,:), [numel(covMetric)+1 netNeurons]);
    %         reg = cat(2, zeros(numel(covMetric)+1, 1), reg);
    % 
    %         curveDataPage = cat(1, curveDataPage, reshape(reg',[1 size(reg,2) numel(covMetric)+1])); 
    %     end
    % 
    %     fig = figure;
    %     figure(fig)
    %     t = tiledlayout(3,3);
    %     ax = cell(1, numel(covMetric));
    %     for cov = 1:numel(covMetric)
    %         ax{cov} = nexttile;
    % 
    %         covCurveCell = cell(1,(numel(topkData)+1));
    %         x = 0:netNeurons;
    %         data_s = curveDataPage(1,:,cov);
    %         covCurveCell{1} = plot(ax{cov}, x, data_s, '-*', 'Color', '#B22222');
    %         hold('on')
    % 
    %         data_m = curveDataPage(2,:,cov);
    %         covCurveCell{2} = plot(ax{cov}, x, data_m, '-.square', 'Color', [0.48235 0.40784 0.93333]);
    %         hold('on')
    % 
    %         data_l = curveDataPage(3,:,cov);
    %         covCurveCell{3} = plot(ax{cov}, x, data_l, '-.o', 'Color', [0.11765 0.56741 1]);
    %         hold('on')
    % 
    %         data_rand = curveDataPage(1,:,end);
    %         covCurveCell{4} = plot(ax{cov}, x, data_rand, '--diamond', 'Color', [0.11765 0.56741 1]);
    %         hold('off')
    % 
    %         xticks(0:1:netNeurons);
    %         yticks(0:0.1:1);
    %         xlim([0 netNeurons])
    %         ylim([0 1])
    %         xlabel('Topk Number');
    %         ylabel('Fault Localization Rate')
    % 
    %         lgd = legend("actParam_s", "actParam_m", "actParam_l", "Interpreter", "none");
    %         lgd.FontSize = 12;
    %         lgd.Box = 'off';
    %         lgd.Location = 'southeast';
    % 
    %         figTitle = sprintf('Coverage criteria: %s', covMetric{cov});
    %         title(ax{cov}, figTitle, 'FontSize', 16, 'FontWeight', 'bold')  
    %         title(t, "Different Action Parameters (Ochiai)", 'FontSize', 16, 'FontWeight', 'bold')
    %     end
    %     figFilename = sprintf('diffActParam_spsMetric_Ochiai');
    %     fig = gcf;
    %     fig.PaperPositionMode = 'auto';
    %     fig_pos = fig.PaperPosition;
    %     fig.PaperSize = [fig_pos(3), fig_pos(4)];    
    %     exportgraphics(fig, fullfile(savepath, [figFilename, '.pdf']));
    %     savefig(fig, fullfile(savepath, figFilename));
    %     areaArr = [];
    %     close all;
    % else
    %     error(sprintf("plotmode=%d error!", plotmode))
    end
end