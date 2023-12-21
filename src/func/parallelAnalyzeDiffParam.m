function parallelAnalyzeDiffParam(bmCell, bmInfo, maxPercent, dataFolder, transData_mode, randTimes)
    
    % manual configs
    if ~isempty(bmInfo)

        % get the path of each benchmark
        bmName = bmInfo{1};
        nnStru = bmInfo{4}{1};
        bm = bmName(1:strfind(bmName, '#')-1);
        spec = str2num(bmName(strfind(bmName, '}^{')+3));
        bmFolderName = sprintf('%s_%d_%d_spec%d', bm, numel(nnStru), nnStru(1), spec);
        bmPath = fullfile(dataFolder, bmFolderName);

        % data preprocess 
        transData(bmPath, transData_mode);
        bmPath = fullfile(bmPath, 'transDataProcessed'); 
        % thresholdArr = autoSelect(bmPath, maxPercent);
        
        actParam = bmInfo{2};
        actParam{3} = bmInfo{4}{3}(find('sml'==bmInfo{2}{3}(1)));       % tnctime
        actParam{5} = bmInfo{4}{4}(find('sml'==bmInfo{2}{5}(1)));        % pdtime
        actParam{6} = bmInfo{4}{4}(find('sml'==bmInfo{2}{6}(1)));        % ndtime
        actParam{7} = bmInfo{4}{5}(find('sml'==bmInfo{2}{7}));       % mitime
        actParam{8} = bmInfo{4}{5}(find('sml'==bmInfo{2}{8}));       % mdtime
        actParam{2} = bmInfo{4}{2}(find('sml'==bmInfo{2}{2}));       % tk_num      
        actParam{4} = [bmInfo{4}{3}(find('sml'==bmInfo{2}{4}(1))) bmInfo{4}{2}(find('sml'==bmInfo{2}{4}(2)))];    % ttk_time ttk_num
        actParam{end+1} = [bmInfo{2}{1} bmInfo{2}{3}(2) bmInfo{2}{5}(2) bmInfo{2}{6}(2)];
        
        thresholdArr = [];
        % analyzing
        diffTopkAnalyze(bmPath, {bmInfo{3}}, {actParam}, randTimes, nnStru, bmName, thresholdArr, 0);
    else
        for bmIdx = 1:numel(bmCell)
            
            % goto the next benchmark when this benchmark is not ready
            bmInfo = bmCell{bmIdx};
            if isempty(bmInfo)
                continue
            end
    
            % get the path of each benchmark
            bmName = bmInfo{1};
            nnStru = bmInfo{2};
            bm = bmName(1:strfind(bmName, '#')-1);
            spec = str2num(bmName(strfind(bmName, '}^{')+3));
            bmFolderName = sprintf('%s_%d_%d_spec%d', bm, numel(nnStru), nnStru(1), spec);
            bmPath = fullfile(dataFolder, bmFolderName);
            
            % data preprocess 
            transData(bmPath, transData_mode);
            bmPath = fullfile(bmPath, 'transDataProcessed');
            
            % construct parameters and file name
            actParam = {};
            fileconfig = {};
            % original codes
            thresholdArr = autoSelect(bmPath, maxPercent);
            for thIdx = 1:numel(maxPercent)
                % if numel(bmInfo{3}) == 3
                %     for j = 1:3
                %         actParam{end+1} = {['auto'],[bmInfo{3}(j)],[bmInfo{4}(j)],[bmInfo{4}(j), bmInfo{3}(j)],[bmInfo{5}(j)],[bmInfo{5}(j)],[bmInfo{6}(j)],[bmInfo{6}(j)]};
                %         fileconfig{end+1} = sprintf('_NC_auto_TK_%d_TNC_%d auto_TTK_%d %d_PDND_%d auto_MIMD_%d_percent_%.2f', bmInfo{3}(j), bmInfo{4}(j), bmInfo{4}(j), bmInfo{3}(j), bmInfo{5}(j), bmInfo{6}(j), maxPercent(thIdx));
                %     end
                % elseif numel(bmInfo{3}) == 1
                %     actParam{end+1} = {['auto'],[bmInfo{3}],[bmInfo{4}],[bmInfo{4}, bmInfo{3}],[bmInfo{5}],[bmInfo{5}],[bmInfo{6}],[bmInfo{6}]};
                %     fileconfig{end+1} = sprintf('_NC_auto_TK_%d_TNC_%d auto_TTK_%d %d_PDND_%d auto_MIMD_%d_percent_%.2f', bmInfo{3}, bmInfo{4}, bmInfo{4}, bmInfo{3}, bmInfo{5}, bmInfo{6}, maxPercent(thIdx));
                % else
                %     error('Please check your actParam')
                % end 

                for j = 1:3
                    if thIdx == 1
                        for k = 1:3
                            actParam{end+1} = {['auto'],[bmInfo{3}(j)],[bmInfo{4}(j)],[bmInfo{4}(j), bmInfo{3}(j)],[bmInfo{5}(j)],[bmInfo{5}(j)],[bmInfo{6}(j)],[bmInfo{6}(j)]};
                            fileconfig{end+1} = sprintf('_onlyTTK_%d %d_percent_%.2f', bmInfo{4}(j), bmInfo{3}(k), maxPercent(thIdx));
                        end
                    end
                    actParam{end+1} = {['auto'],[bmInfo{3}(j)],[bmInfo{4}(j)],[bmInfo{4}(j), bmInfo{3}(j)],[bmInfo{5}(j)],[bmInfo{5}(j)],[bmInfo{6}(j)],[bmInfo{6}(j)]};
                    fileconfig{end+1} = sprintf('_NC_auto_TK_%d_TNC_%d auto_TTK_%d %d_PDND_%d auto_MIMD_%d_percent_%.2f', bmInfo{3}(j), bmInfo{4}(j), bmInfo{4}(j), bmInfo{3}(j), bmInfo{5}(j), bmInfo{6}(j), maxPercent(thIdx));
                end                
            end
            
            % analyzing
            diffTopkAnalyze(bmPath, fileconfig, actParam, randTimes, nnStru, bmName, thresholdArr, 1);
        end
    end
   
end