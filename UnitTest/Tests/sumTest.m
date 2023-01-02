classdef sumTest < matlab.unittest.TestCase

    properties
        tooltestingPrjRootPath
        artifactsPath
        demoTTPrj
        embToolsSourcePath
        tempFolderPath
        testScriptPath
        examplePrjPath
        demoPrjName
        demoPrjPath
        testPrj
    end
    
    properties(Constant)
        tooltestingPrj = 'DemoToolTest.prj';
        DemoToolPrj = 'DemoTools';
    end

% function tests = fancyTest
% tests = functiontests(localfunctions);
% end
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
        testCase.demoPrjName = 'DemoTools.prj';
        testCase.demoPrjPath = fullfile(testCase.artifactsPath,'DemoTools');
        testCase.testPrj = simulinkproject(fullfile(testCase.demoPrjPath,testCase.demoPrjName));        
        addpath(testCase.testScriptPath);
        disp(pwd)
    end
end
    
methods(Test)
function testCalculation(testCase)
s = Sum(10,20);
testCase.assertEqual(s,30);
end

function checkPath(testCase)
mypath = which(mfilename); 
testCase.assertNotEqual(mypath,'Not on MATLAB path')
end
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
    end

end
end