% Id Key
%
% 1: j vs t nu = 0 fig2.1
% 2: j vs t nu = 1 fig2.2
% 3: S vs kd vary nu fig2.3
% 4: nu vs kd vary lc fig 3.2
% 5: S vs kd vary lc fig 3.3
% 6: nu vs kd/S vs kd (kHop = 100) fig. 4.3
% 7: nu vs kd/S vs kd (kHop = 200) fig. S5
% 8: nu vs kd/S vs kd (kHop = 500) fig. S6
% 9: S vs kd vary nu supplement scale change fig S1
% 10: S vs kd vary nu linear numeric fig S1
% 11: S vs nu vary kd fig S1
% 12: S vs nu vary kd linear numeric fig S1
% 13: density profile fig S ?
%
% Current results for paper: [1:13]

function paperPlotMaker( plotId, saveFlag, saveTag )
if nargin == 1
  saveFlag = 0;
  saveTag = '';
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
% set some things here. Should be [] you don't want to override
yLimOverride = 100; % for selectivity
yLimOverrideLin = 250; % for selectivity
% figure 1: selectivity vs time nu = 0 fig. 2.1
currId = 1;
if any( plotId == currId )
  data2load = [paperDataPath 'figJvsTnu0_data.mat'];
  plotJvsT( currId, data2load, saveFlag, saveTag, saveID, paperSavePath) 
end
% figure 2: selectivity vs time nu = 1 fig. 2.2
currId = 2;
if any( plotId == currId )
  data2load = [paperDataPath 'figJvsTnu1_data.mat'];
  plotJvsT( currId, data2load, saveFlag, saveTag, saveID, paperSavePath) 
end
% figure 3: selectivity vs kd, vary nu fig 2.3
currId = 3;
if any( plotId == currId )
  data2load = [paperDataPath 'figSvsKdVaryNu_data.mat'];
  plotSvsKd( currId, data2load, 'nu', saveFlag, saveTag,...
    saveID, paperSavePath, yLimOverride )
end
% figure 4: nu vs kd, vary lplc fig. 3.2
currId = 4;
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
    saveAndMove( currId, saveTag, saveID, paperSavePath )
  end
end
% figure 5: selectivity vs kd, vary lplc fig 3.3
currId = 5;
if any( plotId == 10 )
  data2load = [paperDataPath 'figSvsKdVaryLplc_data.mat'];
  plotSvsKd( currId, data2load, 'lplc', saveFlag, ...
    saveTag, saveID, paperSavePath, yLimOverride )
end
% figure 6: nu vs Kd, S vs Kd (kHop) 100 fig 4.3
currId = 6;
if any( plotId == currId )
  lc = 100;
  plotHopData( currId, lc, paperDataPath, saveFlag, paperSavePath,...
    saveTag, saveID )
end
% figure 7: nu vs Kd, S vs Kd (kHop) 200 fig S5
currId = 7;
if any( plotId == currId )
  lc = 200;
  plotHopData( currId, lc, paperDataPath, saveFlag, paperSavePath,...
    saveTag, saveID )
end
% figure 8: nu vs Kd, S vs Kd (kHop) 500 fig S6
currId = 8;
if any( plotId == currId )
  lc = 500;
  plotHopData( currId, lc, paperDataPath, saveFlag, paperSavePath,...
    saveTag, saveID )
end
% figure 9: S vs Kd vary nu numeric fig S1
currId = 9;
if any( plotId == currId )
  data2load = [paperDataPath 'figSvsKdVaryNu_data.mat'];
  dBtype = 'nu';
  plotSvsKd( currId, data2load, dBtype, saveFlag, saveTag, saveID, ...
    paperSavePath, yLimOverride )
end
% figure 10: S vs Kd vary nu linear, numeric fig S1
currId = 10;
if any( plotId == currId )
  data2load = [paperDataPath 'figSvsKdVaryNuLinearNumeric_data.mat'];
  dBtype = 'nu';
  plotSvsKdLinear( currId, data2load, dBtype, saveFlag, saveTag, saveID,...
    paperSavePath, yLimOverrideLin)
end
% figure 11: S vs nu, vary kD fig S1
currId = 11;
if any( plotId == currId )
  data2load = [paperDataPath 'figSvsNu_data.mat'];
  plotSvsNuVaryKd( currId, data2load, saveFlag, saveTag, saveID,...
    paperSavePath )
end
% figure 12: S vs nu, vary kD linear fig S1
currId = 12;
if any( plotId == currId )
  data2load = [paperDataPath 'figSvsNuLinearNumeric_data.mat'];
  plotSvsNuVaryKd( currId, data2load, saveFlag, saveTag, saveID,...
    paperSavePath )
end
% figure 13: density profile fig S?
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
    saveAndMove( currId, saveTag, saveID, paperSavePath )
  end
end

%%%%%%%%% Plot functions %%%%%%%%%%%%%%
function plotSvsKd( currId, data2load, dbtype, saveFlag, saveTag, saveID, paperSavePath, yLim )
  if nargin < 8
    yLim = [];
  end
  if exist( data2load, 'file'  )
    load( data2load )
    makefigSvsKd( fluxSummary, dbtype, yLim );
  else
    fprintf('No data to run for fig %d. Run paperResultsMaker\n', currId);
  end
  % save it
  if saveFlag
    saveAndMove( currId, saveTag, saveID, paperSavePath )
  end

function plotJvsT( currId, data2load, saveFlag, saveTag, saveID, paperSavePath)
  cutOffTime = 0.051; % seconds
  if exist( data2load, 'file'  )
    load( data2load )
    makefigJvsT( fluxSummary, cutOffTime );
  else
    fprintf('No data to run for fig %d. Run paperResultsMaker\n', currId);
  end
  % save it
  if saveFlag
    saveAndMove( currId, saveTag, saveID, paperSavePath )
  end

function plotSvsKdLinear( currId, data2load, dbtype, saveFlag, saveTag, saveID, ...
  paperSavePath, yLimOverride )
  if exist( data2load, 'file' )
    load( data2load )
    makefigSvsKdLinear( linSummary, dbtype, yLimOverride );
  else
    fprintf('No data to run for fig %d. Run paperResultsMaker\n', currId);
  end
  % save it
  if saveFlag
    saveAndMove( currId, saveTag, saveID, paperSavePath )
  end

function plotSvsNuVaryKd( currId, data2load, saveFlag, saveTag, saveID, paperSavePath, yLimOverride )
  if exist( data2load, 'file'  )
    load( data2load )
    makefigSvsNu( fluxSummary, yLimOverride );
  else
    fprintf('No data to run for fig %d. Run paperResultsMaker\n', currId);
  end
  % save it
  if saveFlag
    saveAndMove( currId, saveTag, saveID, paperSavePath )
  end

function plotHopData( currId, lc, paperDataPath, ...
  saveFlag, paperSavePath, saveTag, saveID )
lcStr = num2str( lc, '%d' ) ;
hoppingFileId = [ 'hopData' lcStr];
hoppingFile = [ 'hoppingData_' hoppingFileId '_data.mat' ];
data2load = [paperDataPath hoppingFile];
saveTag = [ lcStr '_' saveTag ]; 
if exist( data2load, 'file'  )
  load( data2load )
  makefigNuSvsKdKhop( hoppingData );
else
  fprintf('No data to run for fig %d. Run paperResultsMaker\n', currId);
end
% save it
if saveFlag
  saveAndMove( currId, saveTag, saveID, paperSavePath )
end

function plotSHeatMapKdNu( currId, data2load, dbtype, ...
  saveFlag, paperSavePath, saveTag, saveID )
  if exist( data2load, 'file' )
    load( data2load )
    makefigSheatmap( fluxSummary, dbtype );
  else
    fprintf('No data to run for fig %d. Run paperResultsMaker\n', currId);
  end
  % save it
  if saveFlag
    saveAndMove( currId, saveTag, saveID, paperSavePath )
  end

function saveAndMove( currId, saveTag, saveID, paperSavePath )
  saveName = ['paperfig' num2str(currId ) '_' saveTag];
  savefig( gcf, saveName )
  saveas( gcf, saveName, saveID )
  movefile( [saveName '*'], paperSavePath )

