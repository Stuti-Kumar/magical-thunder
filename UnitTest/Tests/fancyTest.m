classdef (SharedTestFixtures = {AddDemoToolRefFixture}) ... 
    fancyTest < matlab.unittest.TestCase

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
methods(TestClassSetup)
    function pullDependencies(testCase)
        disp(pwd)
%         % Get details about current testing project
% % % % %         testCase.testScriptPath = fileparts(which(mfilename));
% % % % %         addpath(testCase.testScriptPath);
%                 curPrj = currentProject;
%                 testCase.tooltestingPrjRootPath = curPrj.RootFolder;
%                 testCase.demoTTPrj = fullfile(testCase.tooltestingPrjRootPath, testCase.tooltestingPrj);
%        
%         testCase.artifactsPath = fullfile(testCase.tooltestingPrjRootPath, 'Tests', 'Artifacts');
%         testCase.demoPrjName = 'DemoTools.prj';
%         testCase.demoPrjPath = fullfile(testCase.artifactsPath,'DemoTools');
% %         testCase.testPrj = simulinkproject(fullfile(testCase.demoPrjPath,testCase.demoPrjName));        
%         testCase.testPrj = fullfile(testCase.demoPrjPath,testCase.demoPrjName);
%       addReference(curPrj, testCase.testPrj, 'relative');
      disp('Added reference of Demo tools to Tool Test project successfully..')
%        testCase.applyFixture(AddDemoToolRefFixture);
      disp(pwd)
    end
end
    
methods(Test)
function testFanciness(testCase)
s = getFancy;
testCase.assertEqual(s,'pretty fancy');
end

function testMatlabVer1(testCase)
testCase.assumeTrue( verLessThan('matlab','9.10'),'Test version 20b');
releaseInfo = matlabRelease;
testCase.assertEqual(releaseInfo.Release,"R2020b");
end

function testMatlabVer2(testCase)
testCase.assumeTrue( ~verLessThan('matlab','9.13'),'Test Case supported for version R2022b onwards');
releaseInfo = matlabRelease;
testCase.assertEqual(releaseInfo.Release,"R2022b");
end
end

% methods(TestMethodTeardown)
%     function deleteCopies(testCase)
%         bdclose all;
%         
%         try
%             prj = simulinkproject;
%             prj.close;
%         catch
%         end
%         simulinkproject(testCase.demoTTPrj)
%     end
% 
% end
end