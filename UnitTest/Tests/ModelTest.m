classdef ModelTest < matlab.unittest.TestCase

    properties
        tooltestingPrjRootPath
        artifactsPath
        demoTTPrj
        tempFolderName
        tempFolderPath
        testScriptPath
        examplePrjPath
        demoPrjName
        demoPrjPath
        testPrj
        ModelPrjPath
        workFolder
    end
    
    properties(Constant)
        tooltestingPrj = 'DemoToolTest.prj';
        DemoToolPrj = 'DemoTools';
        ModelPrj = 'TestProject.prj';
        ModelName = 'Calculator.slx';
        ExeName = 'Calculator.exe';
        SimulinkTestFile = 'testfile.mldatx';
    end


methods(TestMethodSetup)
    function pullDependencies(testCase)
        disp(pwd)
        %         % Get details about current testing project
        testCase.testScriptPath = fileparts(which(mfilename));
        
        curPrj = currentProject;
        testCase.tooltestingPrjRootPath = curPrj.RootFolder;
        testCase.demoTTPrj = fullfile(testCase.tooltestingPrjRootPath, testCase.tooltestingPrj);
        %
        testCase.artifactsPath = fullfile(testCase.tooltestingPrjRootPath, 'Tests', 'Artifacts');
        testCase.ModelPrjPath = fullfile(testCase.artifactsPath,'TestProject');
        disp(pwd)
    end
    function createTempFolder(testCase)
        count = 0;
        while(count<100)
            testCase.tempFolderName = ['Temp' num2str(randi(1000))];
            testCase.tempFolderPath = fullfile(testCase.artifactsPath,testCase.tempFolderName);
            if ~exist(testCase.tempFolderPath,'dir')
                mkdir(testCase.tempFolderPath)
                copyDir(testCase.ModelPrjPath,testCase.tempFolderPath);
                break
            end
            count = count+1;
        end
    end
end
    
methods(Test)
    function buildModel(testCase)
%         testCase.tempModelPrjPath = fullfile(testCase.tempFolderPath);
        testCase.workFolder = fullfile(testCase.tempFolderPath, 'work');
        simulinkproject(fullfile(testCase.tempFolderPath,testCase.ModelPrj));
        addpath(testCase.testScriptPath);
        
        eval(['rtwbuild(''',regexprep(testCase.ModelName,'.slx',''),''');'])%Building the model
        verifyEqual(testCase, num2str(isfile(fullfile(testCase.workFolder,testCase.ExeName))),'1','code gen not successful');
    end

    function simulateModel(testCase)
        simulinkproject(fullfile(testCase.tempFolderPath,testCase.ModelPrj));
        addpath(testCase.testScriptPath);
        result = runtests(testCase.SimulinkTestFile);
        rt = table(result);
        PassedData = rt.Passed == 1;% Check if all test cases are passed
        testCase.verifyTrue(all(PassedData),1)
    end
% function checkPath(testCase)
% mypath = which(mfilename); 
% testCase.assertNotEqual(mypath,'Not on MATLAB path')
% end
end

methods(TestMethodTeardown)
    function deleteCopies(testCase)
        bdclose all;
        
        try
            prj = simulinkproject;
            prj.close;
        catch
        end
        simulinkproject(testCase.demoTTPrj)
        removeDir(testCase.tempFolderPath,5)% Delete temp folder
    end

end
end