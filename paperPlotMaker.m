% Id Key
%
% 1: j vs t nu = 0 fig2.1
% 2: j vs t nu = 1 fig2.2
% 3: S vs kd vary nu fig2.3
% 4: nu vs kd vary lc fig 3.2
% 5: S vs kd vary lc fig 3.3
% 6: nu vs kd/S vs kd (kHop = 4) fig. 4.3
% 7: nu vs kd/S vs kd (kHop = 12) fig. S5
% 8: nu vs kd/S vs kd (kHop = 40) fig. S6
% 9: nu vs kd/S vs kd (kHop = 120) fig. S6
% 10: S vs kd vary nu linear numeric fig S1
% 11: S vs nu vary kd fig S1
% 12: S vs nu vary kd linear numeric fig S1
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
yLimOverride = [250]; % for selectivity
yLimOverrideLin = [350]; % for selectivity
yLimOverrideHop = [250];
cutOffTime = Inf; % seconds
% figure 1: selectivity vs time nu = 0 fig. 2.1
currId = 1;
if any( plotId == currId )
  data2load = [paperDataPath 'figJvsTnu0_data.mat'];
  plotJvsT( currId, data2load, saveFlag, saveTag, saveID, ...
    paperSavePath, cutOffTime)
end
% figure 2: selectivity vs time nu = 1 fig. 2.2
currId = 2;
if any( plotId == currId )
  data2load = [paperDataPath 'figJvsTnu1_data.mat'];
  plotJvsT( currId, data2load, saveFlag, saveTag, saveID,...
    paperSavePath, cutOffTime)
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
    % save it
    if saveFlag
      saveAndMove( currId, saveTag, saveID, paperSavePath )
    end
  else
    fprintf('No data to run for fig %d. Run paperResultsMaker\n', currId);
  end
end
% figure 5: selectivity vs kd, vary lplc fig 3.3
currId = 5;
if any( plotId == currId )
  data2load = [paperDataPath 'figSvsKdVaryLplc_data.mat'];
  nulplcFile4Color = [paperDataPath 'figNuVsKd_data.mat'];
  load( nulplcFile4Color );
  nulplcColor{1} = tetherCalc.lplc;
  nulplcColor{2} = 'log';
  wantedColors = ...
    getPlotLineColors( nulplcColor{1}, 'log', 'pmkmp' );
  wantedColors = wantedColors(1:4,:);
  plotSvsKd( currId, data2load, 'lplc', saveFlag, ...
    saveTag, saveID, paperSavePath, yLimOverride, wantedColors)
end
% figure 6: nu vs Kd, S vs Kd (kHop) 4 fig 4.3
currId = 6;
if any( plotId == currId )
  lc = 4;
  plotHopData( currId, lc, paperDataPath, saveFlag, paperSavePath,...
    saveTag, saveID, yLimOverrideHop )
end
% figure 7: nu vs Kd, S vs Kd (kHop) 12 fig S5
currId = 7;
if any( plotId == currId )
  lc = 12;
  plotHopData( currId, lc, paperDataPath, saveFlag, paperSavePath,...
    saveTag, saveID, yLimOverrideHop  )
end
% figure 8: nu vs Kd, S vs Kd (kHop) 40 fig S6
currId = 8;
if any( plotId == currId )
  lc = 40;
  plotHopData( currId, lc, paperDataPath, saveFlag, paperSavePath,...
    saveTag, saveID, yLimOverrideHop  )
end
% figure 8: nu vs Kd, S vs Kd (kHop) 120 fig S6
currId = 9;
if any( plotId == currId )
  lc = 120;
  plotHopData( currId, lc, paperDataPath, saveFlag, paperSavePath,...
    saveTag, saveID, yLimOverrideHop  )
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
    paperSavePath, yLimOverrideLin )
end
% figure 12: S vs nu, vary kD linear fig S1
currId = 12;
if any( plotId == currId )
  data2load = [paperDataPath 'figSvsNuLinearNumeric_data.mat'];
  plotSvsNuVaryKd( currId, data2load, saveFlag, saveTag, saveID,...
    paperSavePath, yLimOverrideLin )
end
%%%%%%%%% Plot functions %%%%%%%%%%%%%%
function plotSvsKd( currId, data2load, dbtype, saveFlag, saveTag, saveID, ...
  paperSavePath, yLim, wantedColors )
if nargin < 8
  yLim = [];
  wantedColors = [];
elseif nargin < 9
  wantedColors = [];
end
if exist( data2load, 'file'  )
  load( data2load )
  if isempty( wantedColors )
    makefigSvsKd( fluxSummary, dbtype, yLim );
  else
    makefigSvsKd( fluxSummary, dbtype, yLim, wantedColors );
  end
  % save it
  if saveFlag
    saveAndMove( currId, saveTag, saveID, paperSavePath )
  end
else
  fprintf('No data to run for fig %d. Run paperResultsMaker\n', currId);
end

function plotJvsT( currId, data2load, saveFlag, saveTag, saveID, ...
  paperSavePath, cutOffTime)
if exist( data2load, 'file'  )
  load( data2load )
  makefigJvsT( fluxSummary, cutOffTime );
  % save it
  if saveFlag
    saveAndMove( currId, saveTag, saveID, paperSavePath )
  end
else
  fprintf('No data to run for fig %d. Run paperResultsMaker\n', currId);
end

function plotSvsKdLinear( currId, data2load, dbtype, saveFlag, saveTag, saveID, ...
  paperSavePath, yLimOverride )
if exist( data2load, 'file' )
  load( data2load )
  makefigSvsKdLinear( linSummary, dbtype, yLimOverride );
  % save it
  if saveFlag
    saveAndMove( currId, saveTag, saveID, paperSavePath )
  end
else
  fprintf('No data to run for fig %d. Run paperResultsMaker\n', currId);
end

function plotSvsNuVaryKd( currId, data2load, saveFlag, saveTag, saveID,...
  paperSavePath, yLimOverride )
if exist( data2load, 'file'  )
  load( data2load )
  makefigSvsNu( fluxSummary, yLimOverride );
  % save it
  if saveFlag
    saveAndMove( currId, saveTag, saveID, paperSavePath )
  end
else
  fprintf('No data to run for fig %d. Run paperResultsMaker\n', currId);
end

function plotHopData( currId, lc, paperDataPath, ...
  saveFlag, paperSavePath, saveTag, saveID, yLimOverride )
lcStr = num2str( lc, '%d' ) ;
hoppingFileId = [ 'hopData' lcStr];
hoppingFile = [ 'hoppingData_' hoppingFileId '_data.mat' ];
data2load = [paperDataPath hoppingFile];
saveTag = [ lcStr '_' saveTag ];
if exist( data2load, 'file'  )
  load( data2load )
  makefigNuSvsKdKhop( hoppingData, yLimOverride );
  % save it
  if saveFlag
    saveAndMove( currId, saveTag, saveID, paperSavePath )
  end
else
  fprintf('No data to run for fig %d. Run paperResultsMaker\n', currId);
end

function plotSHeatMapKdNu( currId, data2load, dbtype, ...
  saveFlag, paperSavePath, saveTag, saveID )
if exist( data2load, 'file' )
  load( data2load )
  makefigSheatmap( fluxSummary, dbtype );
  % save it
  if saveFlag
    saveAndMove( currId, saveTag, saveID, paperSavePath )
  end
else
  fprintf('No data to run for fig %d. Run paperResultsMaker\n', currId);
end

function saveAndMove( currId, saveTag, saveID, paperSavePath )
saveName = ['paperfig' num2str(currId ) '_' saveTag];
savefig( gcf, saveName )
saveas( gcf, saveName, saveID )
movefile( [saveName '*'], paperSavePath )

