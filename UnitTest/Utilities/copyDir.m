%%
% Unpublished Work (c) 2021 Deere & Company
function copyFlag = copyDir(srcPath, dstPath)
copyFlag = false;
try
    copyfile(srcPath, dstPath);
    copyFlag = true;
catch
    % assuming windows system as copyfile will fail for windows
    % only due to long path issue
    if ispc
        try
            i = 1;
            while i<=5
                [status,~] = system(strcat('robocopy', " ", srcPath, " ", dstPath, ' /E'));
                if ~status
                    copyFlag = true;
                    break
                end
                i = i+1;
            end
        catch
            disp('copfile failed. Please debug any workaround looking into failure reason.')
        end
    else
        disp('copfile failed. Please debug any workaround looking into failure reason.')
    end
end
end