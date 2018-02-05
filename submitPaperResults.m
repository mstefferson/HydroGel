% submitPaperResults.m
% run paperResults for a given runNum
% runNum should be given in script initPaperResults
% E.g:
%% initPaperResults.m
% runNum = [1 2 3]
if exist('initPaperResults','file') == 0
  fprintf('No initPaperResults found. Creating example file to run result 1\n')
  !echo 'runNum = [1]' > initPaperResults.m
end
run('initPaperResults')
for ii = runNum
  fprintf('Going to run results for %d\n', ii)
end

tic
for ii = runNum
  paperResultsMaker(ii)
  fprintf('Ran results %d\n', ii)
end
tOut = toc;
fprintf('All runs: %f min \n', tOut / 60 );
