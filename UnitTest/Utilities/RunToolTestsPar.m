%RunToolTests - Run required tool tests in the form of test suits
%function RunToolTests(varargin)
%
%   Inputs:
%                varargin =
%                varargin{1} = Test Package Name
%                varargin{2} = Frequncy
%
%
%   Examples
%       RunToolTests('Utility/CreateNewModel')
%       RunToolTests('Utility/CreateNewModel', 'Daily')
%       RunToolTests('Utility/CreateNewModel', 'Daily/Weekly')
%       RunToolTests('Utility', 'Daily')
%       RunToolTests('Utility')
%       RunToolTests('all', 'Daily')
%       RunToolTests() - It will run all tests
%
%
%   See also findProjectFiles.

%   RESTRICTIONS:
%   Copyright (c) Deere & Company, as an unpublished work.
%   THIS SOFTWARE AND/OR MATERIAL IS THE PROPERTY OF DEERE & COMPANY.
%   ALL USE, DISCLOSURE, AND/OR REPRODUCTION NOT SPECIFICALLY AUTHORIZED BY
%   DEERE & COMPANY IS PROHIBITED.
function RunToolTests(varargin)
if verLessThan('matlab', '9.5')
    [numPassed,numFailed] = RunToolTests_17b;
    disp(['Total passed cases: ' num2str(numPassed)])
    disp(['Total failed cases: ' num2str(numFailed)])
    return
end

import matlab.unittest.plugins.CodeCoveragePlugin
import matlab.unittest.plugins.codecoverage.CoberturaFormat

enterpriseRepoPath = fileparts(fileparts(fileparts(which(mfilename))));

% try
%     prj=simulinkproject;
%     prj.close;
% catch 
% end

% if ispc
%     for i = 'A':'Z'
%         tempFolderPath = [i ':'];
%         status = system(['subst ' tempFolderPath ' ' enterpriseRepoPath]);
%         if ~status
%             cd(tempFolderPath)
%             break
%         elseif status && (i == 'Z')
%             tempFolderPath = enterpriseRepoPath;
%         end
%     end
% else
%     tempFolderPath = enterpriseRepoPath;
%     status = true;
% end

% currPath = pwd;
% utilitiesPath = fullfile(tempFolderPath, 'UnitTests', 'Utilities');
% unitTestsPath = fileparts(utilitiesPath);
% srcPath = fullfile(fileparts(unitTestsPath),'Source');
% testingRepoPath = fullfile(unitTestsPath, 'Tests', 'ExampleMBSDProject');
% artifactEntToolsPath = fullfile(unitTestsPath,'Tests', 'Artifacts', 'EnterpriseTools');
% toolTestingPrj = fullfile(unitTestsPath, 'EnterpriseToolTestAutomation.prj');
% artifactEmbToolsPath = fullfile(unitTestsPath,'Tests', 'Artifacts', 'ControlsModels', 'EmbeddedTools');
% examplePrjEmbPath = fullfile(testingRepoPath, 'ControlsModels', 'EmbeddedTools');
% 
% addpath(utilitiesPath);
% 
% cd(testingRepoPath);
% 
% [tag, ~] = findTagFromSrcJSON(srcPath);
% 
% [latestDistTagFound,~, ~] = updateVersionInPkgJSON('@deere-embedded/mbsd.embedded-tools',tag);
% if ~latestDistTagFound
%     disp(['Could not install ' tag ' tag for Embedded Tools so Aborting tests..!!'])
%     return
% end
% 
% system('npm install');
% 
% removeDir(artifactEmbToolsPath, 5);
% mkdir(artifactEmbToolsPath);
% copyDir(examplePrjEmbPath,artifactEmbToolsPath);
% 
% removeDir(artifactEntToolsPath,5);
% mkdir(artifactEntToolsPath);
% copyFlag = copyDir(srcPath,artifactEntToolsPath);
% 
% if ~copyFlag
%     disp('Could not copy EnterpriseTools from Source to Artifacts so Aborting tests..!!')
%     return
% end
% 
% cd(currPath)

prj = simulinkproject;
rootFolder = prj.RootFolder;
testsFolderPath = 'Tests';
testSuites = [];
frequencyTestFiles = [];


% %
% if isa(prj,'slproject.ProjectManager')
%     [~,PreTest,~]=findProjectFiles(prj,'Automation','PreTest');
% else
%     [~,PreTest,~]=findProjectFiles('Automation','PreTest');
% end
% RunFiles(PreTest);

%% if no arguement is passed - assume that all test suites need to be run
cd(rootFolder);

if(nargin<1)
    %     testSuites = matlab.unittest.TestSuite.fromPackage(testsFolderPath, 'IncludingSubpackages', true);
    testSuites = matlab.unittest.TestSuite.fromFolder(testsFolderPath, 'IncludingSubfolders', true);
    
    % run only selected test suites with particular label/labels of frequency
else
    testSuitesList = varargin{1};
    
    if(strcmpi(testSuitesList,'all'))
        %         testSuites = matlab.unittest.TestSuite.fromPackage(testsFolderPath, 'IncludingSubpackages', true);
        testSuites = matlab.unittest.TestSuite.fromFolder(testsFolderPath, 'IncludingSubfolders', true);
    else
        testSuitesList = strsplit(testSuitesList,'/');
        for subFldrCnt = 1:length(testSuitesList)
            %             testSuites = [testSuites matlab.unittest.TestSuite.fromPackage([testsFolderPath '.' testSuitesList{subFldrCnt}])];
            testSuites = [testSuites matlab.unittest.TestSuite.fromFolder([testsFolderPath filesep testSuitesList{subFldrCnt}])];
        end
    end
    
    if(nargin>1) % frequency code - Daily/Weekly
        frequencyList = varargin{2};
        frequencyList = strsplit(frequencyList,'/');
        
        
        for frqCnt = 1:length(frequencyList)
            frequencyTestFiles = [frequencyTestFiles findProjectFiles('Frequency',frequencyList{frqCnt})'];
        end
        
        frequencyTestFiles = unique(frequencyTestFiles); % assuming that multiple labels are allowed for frequency
        
        if ~isempty(frequencyTestFiles)
            testSuites = filterTestSuite(testSuites,frequencyTestFiles);
        end
        
    end
end



%%
if ~isempty(testSuites)
    
    srlFiles = {'sumTest','Test_CountConfigFiles'};
    prllFiles = {'fancyTest','ModelTest'}; 
    
%     if ismember('TestCreateDD',prllFiles)
%         prllFiles = prllFiles(~strcmp(prllFiles,'TestCreateDD'));
%         srlFiles = [srlFiles;'TestCreateDD'];
%     end
%     
%     if verLessThan('matlab', '9.7')
%         for iTestFile = {'Test_Emb32WrapperCreation','Test_Emb32WrapperCreation_EOL','Test_Emb32WrapperCreation_GUI'}
%             prllFiles = prllFiles(~strcmp(prllFiles,iTestFile));
%             srlFiles = srlFiles(~strcmp(srlFiles,iTestFile));
%         end
%     end
%     
%     prllFiles = prllFiles(~strcmp(prllFiles,'Test_ImportExportSBData'));
%     srlFiles = srlFiles(~strcmp(srlFiles,'Test_ImportExportSBData'));
    
    testSuiteSrl = filterTestSuite(testSuites,srlFiles);
    
    testSuitePrll = filterTestSuite(testSuites,prllFiles);    
%     
%     srlResult = {};
%     prllResult = {};
%         
%     codeFilePaths = configureFilesToCover(artifactEntToolsPath);
    
    if(~isempty(testSuiteSrl))
        runner1 = matlab.unittest.TestRunner.withTextOutput();
        
        runner1.addPlugin(matlab.unittest.plugins.TestRunProgressPlugin.withVerbosity(1))
        runner1.addPlugin(matlab.unittest.plugins.DiagnosticsRecordingPlugin);
        
        junit_report_serial=fullfile(prj.RootFolder,'TestSuitesSerial_TestReport.xml');
        xmlPlugin = matlab.unittest.plugins.XMLPlugin.producingJUnitFormat(junit_report_serial);
        runner1.addPlugin(xmlPlugin);
        
        coverage_report_serial = fullfile(prj.RootFolder,'TestSuitesSerial_Coverage.xml');
        coberturaReportFormat = CoberturaFormat(coverage_report_serial);
%         runner1.addPlugin(CodeCoveragePlugin.forFile(codeFilePaths, 'Producing', coberturaReportFormat));
        
        if ~verLessThan('matlab', '9.7') % html report is not supported in versions less than 2019b
            if(nargin<1)
                coverage_html_report_serial = fullfile(prj.RootFolder,'CodeCoverageForAllSerial');
            else
                args = strsplit(varargin{1},'/');
                coverage_html_report_serial = fullfile(prj.RootFolder, ['CodeCoverageFor' args{:} 'Serial']);
            end
            htmlReportFormat = matlab.unittest.plugins.codecoverage.CoverageReport(coverage_html_report_serial);
%             runner1.addPlugin(CodeCoveragePlugin.forFile(codeFilePaths, 'Producing', htmlReportFormat));
        end
        
        try
            disp('Starting serial execution')
            tic
            srlResult = run(runner1,testSuiteSrl);
            disp('Serial execution completed')
            toc
        catch
            disp('Error occured in serial execution')
            srlResult = {};
        end
    end
    
    if(~isempty(testSuitePrll))
        runner = matlab.unittest.TestRunner.withTextOutput();
        
%         runner.addPlugin(matlab.unittest.plugins.TestRunProgressPlugin.withVerbosity(1))
%         runner.addPlugin(matlab.unittest.plugins.DiagnosticsRecordingPlugin);
%         
%         junit_report_parallel=fullfile(prj.RootFolder,'TestSuitesParallel_TestReport.xml');
%         xmlPlugin = matlab.unittest.plugins.XMLPlugin.producingJUnitFormat(junit_report_parallel);
%         runner.addPlugin(xmlPlugin);
%         
%         coverage_report_parallel = fullfile(prj.RootFolder,'TestSuitesParallel_Coverage.xml');
%         coberturaReportFormat = CoberturaFormat(coverage_report_parallel);
% %         runner.addPlugin(CodeCoveragePlugin.forFile(codeFilePaths, 'Producing', coberturaReportFormat));
%         
%         if ~verLessThan('matlab', '9.7')
%             if(nargin<1)
%                 coverage_html_report_parallel = fullfile(prj.RootFolder, 'CodeCoverageForAllPrll');
%             else
%                 args = strsplit(varargin{1},'/');
%                 coverage_html_report_parallel = fullfile(prj.RootFolder, ['CodeCoverageFor' args{:} 'Prll']);
%             end
%             htmlReportFormat = matlab.unittest.plugins.codecoverage.CoverageReport(coverage_html_report_parallel);
% %             runner.addPlugin(CodeCoveragePlugin.forFile(codeFilePaths, 'Producing', htmlReportFormat));
%         end
%         suite = matlab.unittest.TestSuite.fromClass(?fancyTest)
%         prllResult1 = runInParallel(runner,suite);
%         suite = matlab.unittest.TestSuite.fromClass(?ModelTest)
%         prllResult = runInParallel(runner,suite);
        prllResult = runInParallel(runner,testSuitePrll);
    end
    [srlResult prllResult]
    assignin('base','ans',[srlResult prllResult])
else
    disp('No Test Suites available to run');
end


%%
% if isa(prj,'slproject.ProjectManager')
%     [~,PostTest,~]=findProjectFiles(prj,'Automation','PostTest');
% else
%     [~,PostTest,~]=findProjectFiles('Automation','PostTest');
% end
% RunFiles(PostTest);
%%

%%
% if ispc && ~status
%     simulinkproject(fullfile(enterpriseRepoPath, 'UnitTests', 'EnterpriseToolTestAutomation.prj'))
%     system(['subst ' tempFolderPath ' /d']);
% end



end
%%
function RunFiles(myFiles)
for idx=1:length(myFiles)
    [~,fileRun] = fileparts(myFiles{idx});
    evalin('base',fileRun);
end
end

%%
function filteredTS = filterTestSuite(ts,filterFiles)

if ~verLessThan('matlab', '9.4')
    testClasses = cellfun(@(x) char(x),{ts.TestClass},'UniformOutput',false);
       testClasses = testClasses(~cellfun(@isempty, testClasses));
else
    testClasses = cellfun(@(x) x.Name,{ts.TestClass},'UniformOutput',false);
end

intersectFiles = intersect(testClasses,filterFiles);
intersectIndRptd = ismember(testClasses,intersectFiles);
filteredTS = ts(intersectIndRptd);

end

%%

function codeFilePaths = configureFilesToCover(entToolsPath)
% files in enterprise Tools
codeFilePaths      = filePathsFromFolder(entToolsPath);

% dependencies
dataFrameworkPaths = filePathsFromFolder(fullfile(entToolsPath, 'Analysis'));
calibrationPaths   = filePathsFromFolder(fullfile(entToolsPath, 'Calibration'));
entUtilsPath       = filePathsFromFolder(fullfile(entToolsPath, 'Support','Utilities'));
licenseDataPath    = filePathsFromFolder(fullfile(entToolsPath, 'Support','LicenseData'));
excludePaths = [dataFrameworkPaths, calibrationPaths, entUtilsPath, licenseDataPath];

% exclude dependencies from the file list
codeFilePaths(ismember(codeFilePaths, excludePaths)) = [];
end

function codeFilePaths = filePathsFromFolder(folderPath)
dirOut = dir(fullfile(folderPath, '**', '*.m'));
codeFilePaths = string({dirOut.folder}) + filesep + string({dirOut.name});
end

% Unpublished Work (c) 2021 Deere & Company