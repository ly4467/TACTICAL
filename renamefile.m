path = '/Users/ly/Desktop/TACTICAL/result/mut2/WT_3_15_spec5_mut2/transDataProcessed/*.mat';
spec = 5;


fileDir = dir(path);
for i = 1:numel(fileDir)
    fileName = fileDir(i).name;
    specPos = strfind(fileName, 'spec_')+5;
    newName = [fileName(1:specPos-1), num2str(spec), fileName(specPos+1:end)];
    movefile(fullfile(fileDir(i).folder, fileName), fullfile(fileDir(i).folder, newName))
end