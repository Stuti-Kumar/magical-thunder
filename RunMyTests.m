restoredefaultpath
disp('Step 1')
cd('UnitTest'); 
% addpath('Tests');
disp('Step 2')
prj = simulinkproject('DemoToolTest.prj');
disp('Step 3')
RunToolTests