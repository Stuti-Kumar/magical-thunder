%% create copy of Source folder inside Tests/Artifacts/ControlsModels and add reference
utilityPath = fileparts(which(mfilename));
srcPath = fullfile(fileparts(fileparts(utilityPath)), 'Source');
dstPath = fullfile(fileparts(utilityPath), 'Tests', 'Artifacts', 'DemoTools');

if ~exist(dstPath, 'dir')
    mkdir(dstPath)
end

copyFlag = copyDir(srcPath, dstPath);

if copyFlag
    disp('Copied Source folder in Artifacts/DemoTools successfully..')
else
    disp('Could not copy Source folder in Artifacts/DemoTools.. Some tests may fail..')
end