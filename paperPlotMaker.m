% Id Key
%
% 1: JvsT, nu 0
% 2: Nu vs Kd and S vs Kd (course and fine)
% 3: den Profile and S vs Nu (course and fine)
% 4: linear S vs Kd (analytic)
% 5: selectivity scatter plot
% 6: outlet res accumulation
% 7: Selectivity heatmap Kd vs Nu
% 8: Selectivity heatmap Kd vs Lc
% 9: S vs Kd vary  nu (course and fine)
% 10: S vs Kd vary lplc (course and fine)
% 11: Nu vs Kd
% 12: linear S vs Kd (numeric)
% 13: den Profile
% 14: JvsT, nu 1
% 15: bound diff vs kd and selectivity vs kd 100
% 16: bound diff vs kd and selectivity vs kd 200
% 17: bound diff vs kd and selectivity vs kd 500
%
% Current plots for paper: [1 4 9 10 11 13 14 15 16 17]
%
% draft5: [1 4 11 13 14 15 16 17]

function paperPlotMaker( plotId, saveFlag, saveTag )
if nargin == 1
  saveFlag = 0;
elseif nargin == 2
  saveTag = '';
end
addpath(genpath('src'))
% paper data path
saveID = 'png';
paperDataPath = 'paperData/';
paperSavePath = 'paperFigs/';
if saveFlag == 1
  if ~exist( paperSavePath, 'dir'  )
    mkdir( paperSavePath )
  end
end
% figure 1: selectivity vs time nu = 0
currId = 1;
if any( plotId == currId )
  data2load = [paperDataPath 'figJvsTnu0_data.mat'];
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
currId = 2;
if any( plotId == currId )
  data2load1 = [paperDataPath 'figSvsKdVaryLplc_data.mat'];
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
currId = 3;
if any( plotId == currId )
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
% figure 4: S vs Kd (linear, analytic) for supplements
currId = 4;
if any( plotId == currId )
  data2load = [paperDataPath 'figSvsKdVaryLplcLinearAnalytic_data.mat'];
  if exist( data2load, 'file' )
    load( data2load )
    makefigSvsKdLinear( linSummary );
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
currId = 5;
if any( plotId == currId )
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
currId = 6;
if any( plotId == currId )
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
currId = 7;
if any( plotId == currId )
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
currId = 8;
if any( plotId == currId )
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
% figure 9: selectivity vs kd, vary nu
currId = 9;
if any( plotId == currId )
  data2load1 = [paperDataPath 'figSvsKdVaryNu_data.mat'];
  if exist( data2load1, 'file'  )
    load( data2load1 )
    makefigSvsKd( fluxSummary, 'nu' );
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
% figure 10: selectivity vs kd, vary lplc
currId = 10;
if any( plotId == 10 )
  data2load1 = [paperDataPath 'figSvsKdVaryLplc_data.mat'];
  if exist( data2load1, 'file'  )
    load( data2load1 )
    makefigSvsKd( fluxSummary, 'lplc' );
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
% figure 11: nu vs kd, vary lplc
currId = 11;
if any( plotId == currId )
  data2load1 = [paperDataPath 'figNuVsKd_data.mat'];
  if exist( data2load1, 'file'  )
    load( data2load1 )
    makefigNuVsKd( tetherCalc.kd, tetherCalc.lplc, tetherCalc.nu );
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
% figure 12: S vs Kd (linear, numeric) for supplements
currId = 12;
if any( plotId == currId )
  data2load = [paperDataPath 'figSvsKdVaryLplcLinearNumeric_data.mat'];
  if exist( data2load, 'file' )
    load( data2load )
    makefigSvsKdLinear( linSummary );
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
% figure 13: density profile
currId = 13;
if any( plotId == currId )
  data2load = [paperDataPath 'figDenProfile_data.mat'];
  if exist( data2load, 'file'  )
    load( data2load )
    makefigDenProfile( fluxSummary );
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
% figure 14: selectivity vs time nu = 1
currId = 14;
if any( plotId == currId )
  data2load = [paperDataPath 'figJvsTnu1_data.mat'];
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
% figure 15: nu vs Kd, S vs Kd (kHop) 100
currId = 15;
if any( plotId == currId )
  lc = 100;
  plotHopData( currId, lc, paperDataPath, saveFlag, paperSavePath,...
    saveTag, saveID )
end
% figure 16: nu vs Kd, S vs Kd (kHop) 200
currId = 16;
if any( plotId == currId )
  lc = 200;
  plotHopData( currId, lc, paperDataPath, saveFlag, paperSavePath,...
    saveTag, saveID )
end

% figure 17: nu vs Kd, S vs Kd (kHop) 500
currId = 17;
if any( plotId == currId )
  lc = 500;
  plotHopData( currId, lc, paperDataPath, saveFlag, paperSavePath,...
    saveTag, saveID )
end


function plotHopData( currId, lc, paperDataPath, ...
  saveFlag, paperSavePath, saveTag, saveID )
lcStr = num2str( lc, '%d' ) ;
hoppingFileId = [ 'hopData' lcStr];
hoppingFile = [ 'hoppingData_' hoppingFileId '_data.mat' ];
data2load = [paperDataPath hoppingFile];
if exist( data2load, 'file'  )
  load( data2load )
  makefigNuSvsKdKhop( hoppingData );
else
  fprintf('No data to run for fig %d. Run paperResultsMaker\n', currId);
end
% save it
if saveFlag
  saveName = ['paperfig' num2str(currId ) '_' lcStr '_' saveTag];
  savefig( gcf, saveName )
  saveas( gcf, saveName, saveID )
  movefile( [saveName '*'], paperSavePath )
end

