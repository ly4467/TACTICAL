function [bm, spec, li, i, j, mutate] = readFileName(filename)
    
    [~, filenameNoPath, ~] = fileparts(filename);
    
    specpos = strfind(filenameNoPath, '_spec');
    idxstartpos = strfind(filenameNoPath, '_M_') + 3;
    idxendpos = specpos - 1;
    % idxendpos = strfind(filenameNoPath, '_bug') - 1;
    weightInfo = filenameNoPath(idxstartpos:idxendpos);
    lineIdx = strfind(weightInfo, '_');

    bm = filenameNoPath(1 : (specpos - 1));
    spec = str2num(filenameNoPath(specpos + 6));

    li = str2num(weightInfo(1:lineIdx(1)-1));
    i = str2num(weightInfo(lineIdx(1)+1:lineIdx(2)-1));
    j = str2num(weightInfo(lineIdx(2)+1:end));

    mutateIdx = strfind(filenameNoPath, 'mutate_')+7;
    mutate = str2num(filenameNoPath(mutateIdx));
end


% filenameNoPath = 'AFC_FFNN_trainlm_15_15_15_Apr_1_2020_M_2_1_3_spec_1_bug_2_selflag_0_size_100_mode_allpass_wselmode_all_budget_20_bcr_0.1_Sim_Log'