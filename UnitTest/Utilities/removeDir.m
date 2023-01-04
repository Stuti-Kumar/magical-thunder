%%
% Unpublished Work (c) 2021 Deere & Company
function status = removeDir(dirToRemove, sleepCount)
if nargin < 2
    sleepCount = 1;
end
if exist(dirToRemove, 'dir')
    warning('off');
    rmpath(genpath(dirToRemove));
    warning('on');
    try %#ok<TRYNC>
        status = 0;
        for tempCnt=1:sleepCount
            fclose('all');
            try
                status=rmdir(dirToRemove,'s');
            catch
                if ispc
                    % trying windows rmdir function as many times windows
                    % throwing error while deleting folder. It will only
                    % run ifMATLAB rmdir fails
                    try
                        status = system(['rmdir /s /q ' dirToRemove]);
                        status = ~status;
                    catch
                    end
                end
            end
            if status==1
                break
            end
            pause(0.1*tempCnt)
        end
        if ~status
            disp(['RMDIR: Unable to remove dir-> ' dirToRemove]);
        end
    end
else
    status = 1;
end
end