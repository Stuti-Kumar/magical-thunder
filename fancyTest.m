function tests = fancyTest
tests = functiontests(localfunctions);
end


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