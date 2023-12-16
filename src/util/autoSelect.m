function thresholdArr = autoSelect(folder_path, maxPercent)

    fileDir = dir(fullfile(folder_path, '*.mat'));
    maxvalCell = cell(1, numel(fileDir)-1);
    % parfor fileIdx = 1:numel(fileDir)
    for fileIdx = 1:numel(fileDir)
        if ~contains(fileDir(fileIdx).name, '_nomutation')
            [~, ~, li, i, j, ~] = readFileName(fullfile(fileDir(fileIdx).folder, fileDir(fileIdx).name));
            D = load(fullfile(fileDir(fileIdx).folder, fileDir(fileIdx).name));
    
            nnoutMat = [];
            maxReg = [];
            for sigIdx = 1:numel(D.sig_state)
                for t = 1:size(D.sig_state{sigIdx}.nn_hidden_out, 1)
                    nnoutMat = cat(3, nnoutMat, cell2mat(D.sig_state{sigIdx}.nn_hidden_out(t,:)));
                end
                maxReg = cat(3, maxReg, max(nnoutMat, [], 3));
            end
            maxvalCell{fileIdx} = [li i j max(max(maxReg, [], 3), [], 'all')];
            fprintf('%s Mutant %d_%d_%d already read!\n', folder_path, li, i, j);
        end
    end

    thresholdArr = [];
    for i = 1:numel(maxvalCell)
        reg = [maxvalCell{i}(1) maxvalCell{i}(2) maxvalCell{i}(3)];
        reg = cat(2, reg, maxPercent*maxvalCell{i}(4));
        thresholdArr = cat(1, thresholdArr, reg);
    end
end