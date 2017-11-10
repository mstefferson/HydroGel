function paperPlotMaker( plotId, saveFlag, saveTag )
if nargin == 1
  saveFlag = 0;
elseif nargin == 2
  saveTag = '';
end
% paper data path
paperDataPath = 'paperData/';
if saveFlag == 1
  paperSavePath = 'paperFigs/';
  saveID = 'png';
  if ~exist( paperSavePath, 'dir'  )
    mkdir( paperSavePath )
  end
end

% figure 1: selectivity vs time nu = 0
if any( plotId == 1 )
  currId = 1;
  data2load = [paperDataPath 'fig1_data.mat'];
  if exist( data2load, 'file'  )
    load( data2load ) 
    makefig1( fluxSummary ); 
  else
    fprintf('No data to run for fig 1. Run paperResultsMaker\n');
  end
  % save it
  if saveFlag
    saveName = ['paperfig' num2str(currId ) '_' saveTag];
    savefig( gcf, saveName )
    saveas( gcf, saveName, saveID )
    movefile( [saveName '*'], paperSavePath )
  end
end

% figure 2: selectivity vs kd
if any( plotId == 2 )
  currId = 2;
  data2load = [paperDataPath 'fig2_data.mat'];
  if exist( data2load, 'file'  )
    load( data2load ) 
    load( [paperDataPath 'fig2_data_linear.mat']) 
    makefig2( fluxSummary, fluxLin ); 
  else
    fprintf('No data to run for fig 2. Run paperResultsMaker\n');
  end
  % save it
  if saveFlag
    saveName = ['paperfig' num2str(currId ) '_' saveTag];
    savefig( gcf, saveName )
    saveas( gcf, saveName, saveID )
    movefile( [saveName '*'], paperSavePath )
  end
end
% figure 3: density profiles
if any( plotId == 3 )
  fatWays = 0;
  currId = 3;
  data2load = [paperDataPath 'fig3_data.mat'];
  if exist( data2load, 'file'  )
    load( data2load ) 
    makefig3( fluxSummary, fatWays ); 
  else
    fprintf('No data to run for fig 3. Run paperResultsMaker\n');
  end
  % save it
  if saveFlag
    saveName = ['paperfig' num2str(currId ) '_' saveTag];
    savefig( gcf, saveName )
    saveas( gcf, saveName, saveID )
    movefile( [saveName '*'], paperSavePath )
  end
end
% figure 4: koff mult
if any( plotId == 4 )
  currId = 4;
  data2load = [paperDataPath 'fig4_data.mat'];
  if exist( data2load, 'file'  )
    load( data2load ) 
    makefig4( fluxSummary ); 
  else
    fprintf('No data to run for fig 4. Run paperResultsMaker\n');
  end
  % save it
  if saveFlag
    saveName = ['paperfig' num2str(currId ) '_' saveTag];
    savefig( gcf, saveName )
    saveas( gcf, saveName, saveID )
    movefile( [saveName '*'], paperSavePath )
  end
end
% figure 6: selectivity vs nu
if any( plotId == 6 )
  currId = 6;
  data2load = [paperDataPath 'fig6_data.mat'];
  if exist( data2load, 'file'  )
    load( data2load ) 
    makefig6( fluxSummary ); 
  else
    fprintf('No data to run for fig 6. Run paperResultsMaker\n');
  end
  % save it
  if saveFlag
    saveName = ['paperfig' num2str(currId ) '_' saveTag];
    savefig( gcf, saveName )
    saveas( gcf, saveName, saveID )
    movefile( [saveName '*'], paperSavePath )
  end
end

% figure 7: stability
if any( plotId == 7 )
  currId = 7;
  data2load = [paperDataPath 'figStabilityTest_data.mat'];
  if exist( data2load, 'file'  )
    load( data2load ) 
    makefig7( fluxSummary ); 
  else
    fprintf('No data to run for fig 6. Run paperResultsMaker\n');
  end
end

% figure 11: selectivity vs time nu = 1
if any( plotId == 11 )
  currId = 11;
  data2load = [paperDataPath 'fig1_nu1_data.mat'];
  if exist( data2load, 'file'  )
    load( data2load ) 
    makefig1( fluxSummary ); 
  else
    fprintf('No data to run for fig 1. Run paperResultsMaker\n');
  end
  % save it
  if saveFlag
    saveName = ['paperfig' num2str(currId ) '_' saveTag];
    savefig( gcf, saveName )
    saveas( gcf, saveName, saveID )
    movefile( [saveName '*'], paperSavePath )
  end
end

% figure 36: combine figure 3 and 6
if any( plotId == 36 )
  currId = 36;
  data2load3 = [paperDataPath 'fig3_data.mat'];
  data2load6 = [paperDataPath 'fig6_data.mat'];
  if exist( data2load3, 'file'  ) && exist( data2load6, 'file' )
    load( data2load3 )
    fluxSummary3 = fluxSummary;
    load( data2load6 )
    fluxSummary6 = fluxSummary;
    makefig36( fluxSummary3, fluxSummary6 ); 
  else
    fprintf('No data to run for fig 6. Run paperResultsMaker\n');
  end
  % save it
  if saveFlag
    saveName = ['paperfig' num2str(currId ) '_' saveTag];
    savefig( gcf, saveName )
    saveas( gcf, saveName, saveID )
    movefile( [saveName '*'], paperSavePath )
  end
end

