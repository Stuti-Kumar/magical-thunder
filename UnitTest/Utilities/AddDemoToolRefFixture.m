classdef AddDemoToolRefFixture < matlab.unittest.fixtures.Fixture
    % Unpublished Work (c) 2021-2022 Deere & Company
    % All Worldwide Rights Reserved. THIS MATERIAL IS THE PROPERTY OF DEERE & COMPANY.
    % ALL USE, ALTERATIONS, DISCLOSURE, DISSEMINATION AND/OR REPRODUCTION NOT SPECIFICALLY AUTHORIZED BY DEERE & COMPANY IS PROHIBITED.
    properties
        artifactsEmbToolsPath
    end
    properties (Access = private)
        embToolsPrj
        embToolTestingPrj
    end
    
    properties (Constant)
        ToolTestingPrjName = 'DemoToolTest.prj';
    end
    
    methods
        function setup(fixture)
            try
                p = simulinkproject;
                if ~strcmp(p.Name, 'DemoToolTest')
                    fixture.embToolTestingPrj = simulinkproject(fullfile(fileparts(fileparts(which(mfilename))),fixture.ToolTestingPrjName));
                else
                    fixture.embToolTestingPrj = p;
                end
            catch
                fixture.embToolTestingPrj = simulinkproject(fullfile(fileparts(fileparts(which(mfilename))),fixture.ToolTestingPrjName));
            end
            
            fixture.artifactsEmbToolsPath = fullfile(fileparts(fileparts(which(mfilename))), 'Tests', 'Artifacts', 'DemoTools');
            
            prj = fixture.ToolTestingPrjName;
            prj = p;
            references = prj.ProjectReferences;
            refNmaes = arrayfun(@(y) y.Project.Name, references, 'UniformOutput', false);
            existingEmbRefIdx = find(strcmp(refNmaes,'DemoTools'));
            
            while ~isempty(existingEmbRefIdx)
                removeReference(fixture.embToolTestingPrj,prj.ProjectReferences(existingEmbRefIdx(1)).Project.RootFolder);
                references = prj.ProjectReferences;
                refNmaes = arrayfun(@(y) y.Project.Name, references, 'UniformOutput', false);
                existingEmbRefIdx = find(strcmp(refNmaes,'DemoTools'));
            end
            
            try
                addReference(fixture.embToolTestingPrj, fixture.artifactsEmbToolsPath, 'relative');
                disp('Added reference of Artifacts/DemoTools successfully..')
            catch
                disp('Could not add reference of Artifacts/DemoTools')
            end
            
        end
        function teardown(fixture)
            prj = fixture.embToolTestingPrj;
            references = prj.ProjectReferences;
            refNmaes = arrayfun(@(y) y.Project.Name, references, 'UniformOutput', false);
            existingEmbRefIdx = find(strcmp(refNmaes,'DemoTools'));
            if ~isempty(existingEmbRefIdx)
                try
                    removeReference(fixture.embToolTestingPrj, fixture.artifactsEmbToolsPath)
                    disp('Removed reference of Artifacts/DemoTools successfully..')
                catch
                    disp('Could not remove reference of Artifacts/DemoTools..')
                end
            end
        end
    end
end
