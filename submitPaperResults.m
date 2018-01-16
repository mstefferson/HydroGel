% submitPaperResults.m
% run paperResults for a given runNum
% runNum should be given in script initPaperResults
% E.g:
%% initPaperResults.m
%% runNum = [2 3 4]
%
run('initPaperResults')
for ii = runNum
  fprintf('Going to run results for %d\n', ii)
end

tic
for ii = runNum
  paperResultsMaker(ii)
  fprintf('Ran fig %d\n', ii)
end
tOut = toc;
fprintf('All runs: %f min \n', tOut / 60 );

