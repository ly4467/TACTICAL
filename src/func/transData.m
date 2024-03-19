function transData(folder_path, transData_mode)  
    
    if transData_mode == 1
        fileList = dir(fullfile(folder_path, '*_M_*.mat'));
        newfolderName = 'transData';
        folderDir = dir(folder_path);
        for i = 1: numel(folderDir)
            if folderDir(i).isdir && strcmp(newfolderName, folderDir(i).name)
                return
            end
        end    
        newfolderPath = fullfile(fileList(1).folder, newfolderName);
    
        mkdir(newfolderPath)
        % parfor i = 1:numel(fileList)
        for i = 1:numel(fileList)
            warning('off', 'all');
            reg = load(fullfile(fileList(i).folder, fileList(i).name));
            weightMut = reg.cur_bug;
            sig_success_rate = reg.cur_safety_rate/numel(reg.cur_diagInfo_suite);
            sig_state = cell(1,numel(reg.cur_diagInfo_suite));
            for sig = 1: numel(sig_state)
                sig_state{sig}.Br = reg.cur_diagInfo_suite{sig}.Br;
                sig_state{sig}.rob = reg.cur_diagInfo_suite{sig}.rob;
                sig_state{sig}.state = reg.cur_diagInfo_suite{sig}.state;
                sig_state{sig}.tau_s = reg.cur_diagInfo_suite{sig}.tau_s;
                sig_state{sig}.ic_sig_val = reg.cur_diagInfo_suite{sig}.ic_sig_val;
                sig_state{sig}.oc_sig_val = reg.cur_diagInfo_suite{sig}.oc_sig_val;
    
                nn_hidden_out = {};
                nn_output = [];
                for t = 1:numel(reg.cur_diagInfo_suite{sig}.neuronOut)
                    nnOut = reg.cur_diagInfo_suite{sig}.neuronOut{t};
                    nn_hidden_out = cat(1, nn_hidden_out, nnOut(1:end-1));
                    nn_output = cat(1, nn_output, nnOut{end});
                end
                sig_state{sig}.nn_hidden_out = nn_hidden_out;
                sig_state{sig}.nn_output = nn_output;
            end 
    
            nameReg = fileList(i).name;
            % original
            % newfileName = nameReg(1:strfind(nameReg, '_bug') - 1);

            % new, multiple mutants
            % newfileName = [nameReg(1:strfind(nameReg, '_bug')) nameReg(strfind(nameReg, 'spec'):strfind(nameReg, '_selflag')-1) '.mat'];
            newfileName = nameReg(1:strfind(nameReg, '_selflag') - 1);
            newfile = fullfile(newfolderPath, newfileName);
            % Do not delete one sig_state in "sig_state, sig_state"!
            parsaveMutInfo(newfile, sig_state, sig_state, weightMut, [], sig_success_rate);
            fprintf("File %s transfered\n", newfileName);
            warning('on', 'all');
        end
    
        %% Delete all taus<1 signals
        for i = 1: numel(folderDir)
            if folderDir(i).isdir && strcmp('transDataProcessed', folderDir(i).name)
                return
            end
        end
    
        newfolderName = fullfile(folder_path, 'transDataProcessed');
        oldfolderName = newfolderPath;
        mkdir(newfolderName)
        fileList = dir(fullfile(oldfolderName, '*_M_*.mat'));
        for f = 1:numel(fileList)
            curFile = fullfile(fileList(f).folder, fileList(f).name);
            [~,name,~] = fileparts(curFile);
            reg = load(curFile);
    
            new_sig_state = {};
            robList = [];
            oritausList = [];   % For testing
            for sig = 1:numel(reg.sig_state)
                oritausList(end+1) = reg.sig_state{sig}.tau_s;
                if reg.sig_state{sig}.tau_s>=1
                    new_sig_state{end+1} = reg.sig_state{sig};
                    robList(end+1) = reg.sig_state{sig}.rob;
                end
            end
            realsuccessRate = 1-(sum(robList<0)/numel(new_sig_state));
            mutate = (realsuccessRate >= 0.1 && realsuccessRate <= 0.9);
    
            if ~mutate
                newfileName = [name, '_mutate_0.mat'];
                newfile = fullfile(oldfolderName, newfileName);
                movefile(curFile, newfile);
            else
                newfileName = [name, '_mutate_1.mat'];
                newfile = fullfile(newfolderName, newfileName);
                movefile(curFile, newfile);
            end
            fprintf("File %s preprocess complete!\n", name);
            parsaveMutInfo(newfile, new_sig_state, reg.sig_state, reg.weightMut, mutate, realsuccessRate);
        end
    
        % %% Transfer no mutation file into covfl file
        % fileList = dir(fullfile(folder_path, '*.mat'));
        % for f = 1:numel(fileList)
        %     if isempty(strfind(fileList(f).name, '_M_'))
        %         fileOriName = fileList(f).name;
        %         fileOriPath = fullfile(fileList(f).folder, fileList(f).name);
        %     end
        % end
        % warning('off', 'all');
        % oriData = load(fileOriPath);
        % warning('on', 'all');
        % sig_state = cell(1,numel(oriData.ori_diagInfo_suite));
        % for sig = 1: numel(oriData.ori_diagInfo_suite)
        %     sig_state{sig}.Br = oriData.ori_diagInfo_suite{sig}.Br;
        %     sig_state{sig}.rob = oriData.ori_diagInfo_suite{sig}.rob;
        %     sig_state{sig}.state = oriData.ori_diagInfo_suite{sig}.state;
        %     sig_state{sig}.tau_s = oriData.ori_diagInfo_suite{sig}.tau_s;
        %     sig_state{sig}.ic_sig_val = oriData.ori_diagInfo_suite{sig}.ic_sig_val;
        %     sig_state{sig}.oc_sig_val = oriData.ori_diagInfo_suite{sig}.oc_sig_val;
        % 
        % 
        %     nn_hidden_out = {};
        %     nn_output = [];
        %     for t = 1:numel(oriData.ori_diagInfo_suite{sig}.neuronOut)
        %         nnOut = oriData.ori_diagInfo_suite{sig}.neuronOut{t};
        %         nn_hidden_out = cat(1, nn_hidden_out, nnOut(1:end-1));
        %         nn_output = cat(1, nn_output, nnOut{end});
        %     end
        %     sig_state{sig}.nn_hidden_out = nn_hidden_out;
        %     sig_state{sig}.nn_output = nn_output;
        % end
        % newOriFileName = fileOriName(1:strfind(fileOriName, '_spec')-1);
        % filename = fullfile(fullfile(folder_path, 'transDataProcessed'), [newOriFileName, '_nomutation.mat']);
        % save(filename, "sig_state");
    
    elseif transData_mode == 2
        fileList = dir(fullfile(folder_path, '*_M_*.mat'));
        newfolderName = fullfile(folder_path, 'transDataProcessed');
        mkdir(newfolderName)
        for f = 1:numel(fileList)
            fm = fileList(f).name;
            if str2num(fm(strfind(fm, 'mutate_')+7))
                movefile(fullfile(folder_path, fileList(f).name), fullfile(newfolderName, fileList(f).name));
            end
        end

        oriFile = dir(fullfile(folder_path, '*_nomutation.mat'));
        if ~isempty(oriFile)
            oriFilePath = fullfile(oriFile(1).folder, oriFile(1).name);
            movefile(oriFilePath, fullfile(newfolderName, oriFile(1).name));
        end

    end
end






