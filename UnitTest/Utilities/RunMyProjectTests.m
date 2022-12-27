function RunMyProjectTests(varargin)
%RunMyProjectTests Runs all the tests defined in the project

diary on
datestr(now)
if verLessThan('matlab', '9.5')
    [numPassed,numFailed] = RunToolTests_17b;
    disp(['Total passed cases: ' num2str(numPassed)])
    disp(['Total failed cases: ' num2str(numFailed)])
else
    RunToolTests(varargin{:})
end
datestr(now)
diary off
end

