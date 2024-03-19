function thresholdArr = autoSelect_multi(folder_path, maxPercent)

    fileDir = dir(fullfile(folder_path, '*.mat'));
    maxvalCell = cell(1, numel(fileDir)-1);
    parfor fileIdx = 1:numel(fileDir)
    % for fileIdx = 1:numel(fileDir)
        if ~contains(fileDir(fileIdx).name, '_nomutation')
            nameStr = fileDir(fileIdx).name;
            bugNum = str2num(nameStr(strfind(nameStr, 'bug_')+4 : strfind(nameStr, '_spec')-1 ));
            % [~, ~, li, i, j, ~] = readFileName(fullfile(fileDir(fileIdx).folder, fileDir(fileIdx).name));
            D = load(fullfile(fileDir(fileIdx).folder, fileDir(fileIdx).name));
    
            nnoutMat = [];
            maxReg = [];
            for sigIdx = 1:numel(D.sig_state)
                for t = 1:size(D.sig_state{sigIdx}.nn_hidden_out, 1)
                    nnoutMat = cat(3, nnoutMat, cell2mat(D.sig_state{sigIdx}.nn_hidden_out(t,:)));
                end
                maxReg = cat(3, maxReg, max(nnoutMat, [], 3));
            end
            maxvalCell{fileIdx}.bugNum = bugNum;
            maxvalCell{fileIdx}.maxNum = max(max(maxReg, [], 3), [], 'all');
            maxvalCell{fileIdx}.weightMut = D.weightMut;
            fprintf('Multiple mutant file no.%d already read!\n', bugNum);
        end
    end

    thresholdArr = [];
    for i = 1:numel(maxvalCell)
        multipleNum = size(maxvalCell{i}.weightMut, 1);
        reg = repmat(maxPercent*maxvalCell{i}.maxNum, [multipleNum 1]);
        reg = cat(2, maxvalCell{i}.weightMut, reg, repmat(maxvalCell{i}.bugNum, [multipleNum 1]));
        thresholdArr = cat(1, thresholdArr, reg);
    end
end