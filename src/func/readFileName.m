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