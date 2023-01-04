%%   Remove Project Folders from Path
% Use Simulink Project API to get the current project:
if isequal(version('-release'),'2012b')
    p=Simulink.ModelManagement.Project.CurrentProject;
    prjRoot=p.getRootFolder;
else
    p = simulinkproject;
    prjRoot = p.RootFolder;
end

%%  Reset Matlab Cache Folder - for generated files
Simulink.fileGenControl('reset', 'keepPreviousPath', true);

%%	Clean up
clear projpath p prjRoot toolfolder writefile fname ii alltools
clear gtiHome gtiRemoveList pathList

% Unpublished Work (c) 2021 Deere & Company
