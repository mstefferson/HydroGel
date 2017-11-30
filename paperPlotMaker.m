% Id Key
%
% 1: JvsT
% 2: Nu vs Kd and S vs Kd (course and fine)
% 3: den Profile and S vs Nu (course and fine)
% 4: linear S vs Kd 
% 5: selectivity scatter plot
% 6: outlet res accumulation
% 7: Selectivity heatmap Kd vs Nu
% 8: Selectivity heatmap Kd vs Lc
%

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
  data2load = [paperDataPath 'figJvsT_data.mat'];
  if exist( data2load, 'file'  )
    load( data2load ) 
    makefigJvsT(fluxSummary ); 
  else
    fprintf('No data to run for fig %d. Run paperResultsMaker\n', currId);
  end
  % save it
  if saveFlag
    saveName = ['paperfig' num2str(currId ) '_' saveTag];
    savefig( gcf, saveName )
    saveas( gcf, saveName, saveID )
    movefile( [saveName '*'], paperSavePath )
  end
end

% figure 2: nu vs kd selectivity vs kd
if any( plotId == 2 )
  currId = 2;
  data2load1 = [paperDataPath 'figSvsKd_data.mat'];
  data2load2 = [paperDataPath 'figNuVsKd_data.mat'];
  if exist( data2load1, 'file'  ) && exist( data2load2, 'file' )
    load( data2load1 ) 
    load( data2load2 )
    makefigNuVsKdSvsKd( fluxSummary, tetherCalc ); 
  else
    fprintf('No data to run for fig %d. Run paperResultsMaker\n', currId);
  end
  % save it
  if saveFlag
    saveName = ['paperfig' num2str(currId ) '_' saveTag];
    savefig( gcf, saveName )
    saveas( gcf, saveName, saveID )
    movefile( [saveName '*'], paperSavePath )
  end
end

% figure 3: combine density profile and S vs nu
if any( plotId == 3 )
  currId = 3;
  data2load3 = [paperDataPath 'figDenProfile_data.mat'];
  data2load6 = [paperDataPath 'figSvsNu_data.mat'];
  if exist( data2load3, 'file'  ) && exist( data2load6, 'file' )
    load( data2load3 )
    fluxSummary3 = fluxSummary;
    load( data2load6 )
    fluxSummary6 = fluxSummary;
    makefigDenProfileSvsNu( fluxSummary3, fluxSummary6 ); 
  else
    fprintf('No data to run for fig %d. Run paperResultsMaker\n', currId);
  end
  % save it
  if saveFlag
    saveName = ['paperfig' num2str(currId ) '_' saveTag];
    savefig( gcf, saveName )
    saveas( gcf, saveName, saveID )
    movefile( [saveName '*'], paperSavePath )
  end
end

% figure 4: S vs Kd (linear) for supplements
if any( plotId == 4 )
  currId = 4;
  data2load6 = [paperDataPath 'figSvsKd_data_linear.mat'];
  if exist( data2load6, 'file' )
    load( data2load6 )
    makefigSvsKdLinear( fluxLin ); 
  else
    fprintf('No data to run for fig %d. Run paperResultsMaker\n', currId);
  end
  % save it
  if saveFlag
    saveName = ['paperfig' num2str(currId ) '_' saveTag];
    savefig( gcf, saveName )
    saveas( gcf, saveName, saveID )
    movefile( [saveName '*'], paperSavePath )
  end
end

% figure 5: scatter plot of param input. Not a paper fig
if any( plotId == 5 )
  currId = 5;
  data2load = [paperDataPath 'selectivityFromInput_data.mat'];
  if exist( data2load, 'file' )
    load( data2load )
    makefigScatterSelectivity( selectivity ); 
  else
    fprintf('No data to run for fig %d. Run paperResultsMaker\n', currId);
  end
  % save it
  if saveFlag
    saveName = ['paperfig' num2str(currId ) '_' saveTag];
    savefig( gcf, saveName )
    saveas( gcf, saveName, saveID )
    movefile( [saveName '*'], paperSavePath )
  end
end

% figure 6: outlet accumulation. Not a paper fig
if any( plotId == 6 )
  currId = 6;
  data2load = [paperDataPath 'figResAccum_data.mat'];
  if exist( data2load, 'file' )
    load( data2load )
    makefigAOutletRes( fluxSummary ); 
  else
    fprintf('No data to run for fig %d. Run paperResultsMaker\n', currId);
  end
  % save it
  if saveFlag
    saveName = ['paperfig' num2str(currId ) '_' saveTag];
    savefig( gcf, saveName )
    saveas( gcf, saveName, saveID )
    movefile( [saveName '*'], paperSavePath )
  end
end

% figure 7: seletivity heatmap. Kd and nu
if any( plotId == 7 )
  currId = 7;
  data2load = [paperDataPath 'figSheatmapKdNu_data.mat'];
  if exist( data2load, 'file' )
    load( data2load )
    makefigSheatmap( fluxSummary, 'nu' ); 
  else
    fprintf('No data to run for fig %d. Run paperResultsMaker\n', currId);
  end
  % save it
  if saveFlag
    saveName = ['paperfig' num2str(currId ) '_' saveTag];
    savefig( gcf, saveName )
    saveas( gcf, saveName, saveID )
    movefile( [saveName '*'], paperSavePath )
  end
end

% figure 8: seletivity heatmap. Kd and lplc
if any( plotId == 8 )
  currId = 8;
  data2load = [paperDataPath 'figSheatmapKdLcLp_data.mat'];
  if exist( data2load, 'file' )
    load( data2load )
    makefigSheatmap( fluxSummary, 'lplc' ); 
  else
    fprintf('No data to run for fig %d. Run paperResultsMaker\n', currId);
  end
  % save it
  if saveFlag
    saveName = ['paperfig' num2str(currId ) '_' saveTag];
    savefig( gcf, saveName )
    saveas( gcf, saveName, saveID )
    movefile( [saveName '*'], paperSavePath )
  end
end

