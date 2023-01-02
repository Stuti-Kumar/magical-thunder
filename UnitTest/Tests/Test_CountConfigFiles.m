classdef Test_CountConfigFiles < matlab.unittest.TestCase   
    %   RESTRICTIONS:
    %   Copyright (c) Deere & Company, as an unpublished work.
    %   THIS SOFTWARE AND/OR MATERIAL IS THE PROPERTY OF DEERE & COMPANY.
    %   ALL USE, DISCLOSURE, AND/OR REPRODUCTION NOT SPECIFICALLY AUTHORIZED BY
    %   DEERE & COMPANY IS PROHIBITED.

    properties
        matlabVer
        configSetFolderPath
        prjRoot
        demoTTPrj
    end

    properties (Constant)
        configFiles = {'FixedStepConfig.mat', 'VariableStepConfig.mat'};
        tooltestingPrj = 'DemoToolTest.prj';
    end

    methods(TestClassSetup)
        function testCheckAllCOnfigFiles(testCase)
            allConfigFiles = dir(strcat(testCase.configSetFolderPath, '\*.mat'));
            allConfigFileNames = {allConfigFiles.name}
            a = numel(contains(allConfigFileNames, testCase.configFiles))
            testCase.verifyEqual(numel(contains(allConfigFileNames, testCase.configFiles)), 2);
        end  
    end

    methods(Test)
        % check if all config files are present or not
        function testCheckAllCOnfigFiles(testCase)
            allConfigFiles = dir(strcat(testCase.configSetFolderPath, '\*.mat'));
            allConfigFileNames = {allConfigFiles.name};
            testCase.verifyEqual(numel(contains(allConfigFileNames, testCase.configFiles)), 2);
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