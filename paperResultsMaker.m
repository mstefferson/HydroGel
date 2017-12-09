% Id Key
%
% 1: initParamsJvsT  nu 0
% 2: initParamsSvsKd vary lplc 
% 3: initParamsDenProfile 
% 4: initParamsSvsNu (course and fine)
% 5: paramInput selectivity calc
% 6: nu vs Kd (Laura's script)
% 7: outlet reservoir accumulation 
% 8: Selectivity heatmap Kd vs Nu
% 9: Selectivity heatmap Kd vs Lc
% 10: initParamsSvsKd vary nu 
% 11: initParamsSvsKd linear vary lplc (analytic)
% 12: initParamsSvsKd linear vary lplc (numeric)
% 13: initParamsJvsT  nu 0
% 14: initParamsSFromInput gorlich (numeric)
% 15: initParamsSFromInput gorlich2 (numeric)
% 16: initParamsSFromInput hopData100 (numeric)
% 17: initParamsSFromInput hopData200 (numeric)
% 18: initParamsSFromInput hopData500 (numeric)
%
% Current results for paper: [1 2 3 10 11 12 13 14]

function paperResultsMaker( resultsId )
addpath(genpath('src'))
addpath('paperInits/')
% turn off  saving
saveMe = 0;
dirname = 'blah';
saveExt = '.mat';
% turn off all plot flags
plotFlag.plotMapFlux = 0;
plotFlag.plotSteady = 0;
plotFlag.plotVsT = 0;
plotFlag.plotMapFluxSlope = 0;
plotFlag.plotMapFluxTime = 0;
% turn store off/on based on run

dataPath = 'paperData';
if ~exist( dataPath,'dir' ) 
  mkdir( dataPath )
end
% figure 1: selectivity vs time, nu = 0
currId = 1;
if any( resultsId == currId )
  fprintf('Starting results %d \n', currId );
  storeFlag.storeStdy = 0;
  storeFlag.storeTimeDep = 1;
  paramFile = 'initParamsJvsTnu0';
  saveName = 'figJvsTnu0_data';
  fluxSummary  = fluxPDE( plotFlag, storeFlag, saveMe, dirname, paramFile );
  savepath = [ dataPath '/' saveName saveExt];
  if exist( savepath, 'file' )
    fprintf('file exists. renaming file\n');
    saveName = [ saveName datestr(now,'yyyymmdd_HH.MM') ];
  end
  fullName = [saveName saveExt];
  save( fullName, 'fluxSummary' )
  movefile( fullName, dataPath );
  fprintf('Finished results %d \n', currId );
end
% figure 2: selectivity vs kd, vary lplc
currId = 2;
if any( resultsId == currId )
  fprintf('Starting results %d \n', currId );
  storeFlag.storeStdy = 0;
  paramFile = 'initParamsSvsKd_lplc';
  saveName = 'figSvsKdVaryLplc_data';
  fluxSummary  = fluxODE( plotFlag, storeFlag, saveMe, dirname, paramFile );
  savepath = [ dataPath '/' saveName saveExt];
  if exist( savepath, 'file' )
    fprintf('file exists. renaming file\n');
    saveName = [ saveName datestr(now,'yyyymmdd_HH.MM') ];
  end
  fullName = [saveName saveExt];
  save( fullName, 'fluxSummary' )
  movefile( fullName, dataPath );
  fprintf('Finished results %d \n', currId );
end
% figure 3: density profiles
currId = 3;
if any( resultsId == currId )
  fprintf('Starting results %d \n', currId );
  storeFlag.storeStdy = 1;
  paramFile = 'initParamsDenProfile';
  saveName = 'figDenProfile_data';
  fluxSummary  = fluxODE( plotFlag, storeFlag, saveMe, dirname, paramFile );
  savepath = [ dataPath '/' saveName saveExt];
  if exist( savepath, 'file' )
    fprintf('file exists. renaming file\n');
    saveName = [ saveName datestr(now,'yyyymmdd_HH.MM') ];
  end
  fullName = [saveName saveExt];
  save( fullName, 'fluxSummary' )
  movefile( fullName, dataPath );
  fprintf('Finished results %d \n', currId );
end
% figure 4: initParamsSvsNu (course and fine)
currId = 4;
if any( resultsId == currId )
  fprintf('Starting results %d \n', currId );
  storeFlag.storeStdy = 0;
  paramFile = 'initParamsSvsNu';
  saveName = 'figSvsNu_data';
  fluxSummary  = fluxODE( plotFlag, storeFlag, saveMe, dirname, paramFile );
  savepath = [ dataPath '/' saveName saveExt];
  if exist( savepath, 'file' )
    fprintf('file exists. renaming file\n');
    saveName = [ saveName datestr(now,'yyyymmdd_HH.MM') ];
  end
  fullName = [saveName saveExt];
  save( fullName, 'fluxSummary' )
  movefile( fullName, dataPath );
  fprintf('Finished results %d \n', currId );
end
% 5: parameter input. 
currId = 5;
if any( resultsId == currId )
  fprintf('Starting results %d \n', currId );
  loadId = '20171110_param.mat';
  fileId = 'initParamsSFromInput';
  load( ['paperParamInput/' loadId ]);
  tau = 0.01;
  bt = 1e-3;
  kon = 1e9; % unscaled
  numRuns = size( param, 1 );
  paramInpt = zeros( numRuns, 4 );
  paramInpt(:,1) = param(:,1);
  paramInpt(:,2) = kon * bt * tau;
  paramInpt(:,3) = param(:,2) * tau;
  paramInpt(:,4) = bt;
  fluxSummary = fluxODEParamIn(paramInpt, fileId);
  selectivity.val = fluxSummary.jNorm;
  selectivity.paramLoad = param;
  selectivity.paramInpt = paramInpt;
  saveName = 'selectivityFromInput_data';
  savepath = [ dataPath '/' saveName saveExt];
  if exist( savepath, 'file' )
    fprintf('file exists. renaming file\n');
    saveName = [ saveName datestr(now,'yyyymmdd_HH.MM') ];
  end
  fullName = [saveName saveExt];
  save( fullName, 'fluxSummary','selectivity' )
  movefile( fullName, dataPath );
  fprintf('Finished results %d \n', currId );
end
% 6: nu vs kd, Laura's script
currId = 6;
if any( resultsId == currId )
  fprintf('Starting results %d \n', currId );
  [tetherCalc.nu, tetherCalc.kd,tetherCalc.lplc] = makeTetherDBs;
  tetherCalc.nu = tetherCalc.nu.';
  saveName = 'figNuVsKd_data';
  savepath = [ dataPath '/' saveName saveExt];
  if exist( savepath, 'file' )
    fprintf('file exists. renaming file\n');
    saveName = [ saveName datestr(now,'yyyymmdd_HH.MM') ];
  end
  fullName = [saveName saveExt];
  save( fullName, 'tetherCalc' )
  movefile( fullName, dataPath );
  fprintf('Finished results %d \n', currId );
end
% 7: Reservior accumulation
currId = 7;
if any( resultsId == currId )
  fprintf('Starting results %d \n', currId );
  storeFlag.storeStdy = 1;
  storeFlag.storeTimeDep = 1;
  paramFile = 'initParamsOutletResAccum';
  saveName = 'figResAccum_data';
  fluxSummary  = fluxPDE( plotFlag, storeFlag, saveMe, dirname, paramFile );
  savepath = [ dataPath '/' saveName saveExt];
  if exist( savepath, 'file' )
    fprintf('file exists. renaming file\n');
    saveName = [ saveName datestr(now,'yyyymmdd_HH.MM') ];
  end
  fullName = [saveName saveExt];
  save( fullName, 'fluxSummary' )
  movefile( fullName, dataPath );
  fprintf('Finished results %d \n', currId );
end
% 8: Selectivity heat map, Kd vs Nu
currId = 8;
if any( resultsId == currId )
  fprintf('Starting results %d \n', currId );
  storeFlag.storeStdy = 0;
  paramFile = 'initParamsSheatmapKdNu';
  saveName = 'figSheatmapKdNu_data';
  fluxSummary  = fluxODE( plotFlag, storeFlag, saveMe, dirname, paramFile );
  savepath = [ dataPath '/' saveName saveExt];
  if exist( savepath, 'file' )
    fprintf('file exists. renaming file\n');
    saveName = [ saveName datestr(now,'yyyymmdd_HH.MM') ];
  end
  fullName = [saveName saveExt];
  save( fullName, 'fluxSummary' )
  movefile( fullName, dataPath );
  fprintf('Finished results %d \n', currId );
end
% 9: Selectivity heat map, Kd vs lclp
currId = 9;
if any( resultsId == currId )
  fprintf('Starting results %d \n', currId );
  storeFlag.storeStdy = 0;
  paramFile = 'initParamsSheatmapKdLclp';
  saveName = 'figSheatmapKdLcLp_data';
  fluxSummary  = fluxODE( plotFlag, storeFlag, saveMe, dirname, paramFile );
  savepath = [ dataPath '/' saveName saveExt];
  if exist( savepath, 'file' )
    fprintf('file exists. renaming file\n');
    saveName = [ saveName datestr(now,'yyyymmdd_HH.MM') ];
  end
  fullName = [saveName saveExt];
  save( fullName, 'fluxSummary' )
  movefile( fullName, dataPath );
  fprintf('Finished results %d \n', currId );
end
% figure 10: selectivity vs kd, vary nu
currId = 10;
if any( resultsId == currId )
  fprintf('Starting results %d \n', currId );
  storeFlag.storeStdy = 0;
  paramFile = 'initParamsSvsKd_nu';
  saveName = 'figSvsKdVaryNu_data';
  fluxSummary  = fluxODE( plotFlag, storeFlag, saveMe, dirname, paramFile );
  savepath = [ dataPath '/' saveName saveExt];
  if exist( savepath, 'file' )
    fprintf('file exists. renaming file\n');
    saveName = [ saveName datestr(now,'yyyymmdd_HH.MM') ];
  end
  fullName = [saveName saveExt];
  save( fullName, 'fluxSummary' )
  movefile( fullName, dataPath );
  fprintf('Finished results %d \n', currId );
end
% figure 11: selectivity vs kd linear analytic, vary lplc 
currId = 11;
if any( resultsId == currId )
  fprintf('Starting results %d \n', currId );
  storeFlag.storeStdy = 0;
  saveName = 'figSvsKdVaryLplcLinearAnalytic_data';
  initParamsSvsKdAnalytic();
  [linSummary.kdVec, linSummary.lc, linSummary.jNorm] = ...
    linearSelVsKD(kd_range, lc_values,0);
  savepath = [ dataPath '/' saveName saveExt];
  if exist( savepath, 'file' )
    fprintf('file exists. renaming file\n');
    saveName = [ saveName datestr(now,'yyyymmdd_HH.MM') ];
  end
  fullName = [saveName saveExt];
  save( fullName, 'linSummary' )
  movefile( fullName, dataPath );
  fprintf('Finished results %d \n', currId );
end
% figure 12: selectivity vs kd linear numeric, vary lplc
currId = 12;
if any( resultsId == currId )
  fprintf('Starting results %d \n', currId );
  storeFlag.storeStdy = 0;
  paramFile = 'initParamsSvsKd_lplc_linear';
  saveName = 'figSvsKdVaryLplcLinearNumeric_data';
  fluxSummary  = fluxODE( plotFlag, storeFlag, saveMe, dirname, paramFile );
  % put linear data into format taken by linear plotting routine
  kdScale = 1e6;
  lScaleActual = 1e-7;
  lScaleWant = 1e-9;
  lScale = (lScaleActual / lScaleWant)^2;
  [linSummary.kdVec, linSummary.lc, linSummary.jNorm ] = ...
    getDataFluxSummary( fluxSummary, kdScale, lScale );  % store linear data
  savepath = [ dataPath '/' saveName saveExt];
  if exist( savepath, 'file' )
    fprintf('file exists. renaming file\n');
    saveName = [ saveName datestr(now,'yyyymmdd_HH.MM') ];
  end
  fullName = [saveName saveExt];
  save( fullName, 'fluxSummary', 'linSummary' )
  movefile( fullName, dataPath );
  fprintf('Finished results %d \n', currId );
end 
% figure 13: selectivity vs time, nu = 1
currId = 13;
if any( resultsId == currId )
  fprintf('Starting results %d \n', currId );
  storeFlag.storeStdy = 0;
  storeFlag.storeTimeDep = 1;
  paramFile = 'initParamsJvsTnu1';
  saveName = 'figJvsTnu1_data';
  fluxSummary  = fluxPDE( plotFlag, storeFlag, saveMe, dirname, paramFile );
  savepath = [ dataPath '/' saveName saveExt];
  if exist( savepath, 'file' )
    fprintf('file exists. renaming file\n');
    saveName = [ saveName datestr(now,'yyyymmdd_HH.MM') ];
  end
  fullName = [saveName saveExt];
  save( fullName, 'fluxSummary' )
  movefile( fullName, dataPath );
  fprintf('Finished results %d \n', currId );
end
% 14: parameter input, gorlichData
currId = 14;
if any( resultsId == currId )
  storeFlag.storeStdy = 0;
  fprintf('Starting results %d \n', currId );
  fileId = 'initParamsSFromInput';
  pathId = './paperParamInput/';
  loadId = 'gorlichData';
  filename = [ pathId loadId ];
  paramFromLoad = poreExperimentParamsToInputs( filename );
  fluxSummary = fluxODEParamIn( plotFlag, storeFlag, 0, dirname,...
    paramFromLoad.input, fileId );
  selectivity.val = fluxSummary.jNorm';
  selectivity.paramLoad = loadId;
  selectivity.paramInput = paramFromLoad.input;
  selectivity.paramLoad = paramFromLoad.data;
  saveName = [ 'selectivityFromInput_' loadId '_data'];
  savepath = [ dataPath '/' saveName saveExt];
  if exist( savepath, 'file' )
    fprintf('file exists. renaming file\n');
    saveName = [ saveName datestr(now,'yyyymmdd_HH.MM') ];
  end
  fullName = [saveName saveExt];
  save( fullName, 'fluxSummary','selectivity' )
  movefile( fullName, dataPath );
  fprintf('Finished results %d \n', currId );
end

% 15: parameter input, gorlichData2
currId = 15;
if any( resultsId == currId )
  storeFlag.storeStdy = 0;
  fprintf('Starting results %d \n', currId );
  fileId = 'initParamsSFromInput';
  pathId = './paperParamInput/';
  loadId = 'gorlichData2';
  filename = [ pathId loadId ];
  paramFromLoad = poreExperimentParamsToInputs( filename );
  fluxSummary = fluxODEParamIn( plotFlag, storeFlag, 0, dirname,...
    paramFromLoad.input, fileId );
  selectivity.val = fluxSummary.jNorm';
  selectivity.paramLoad = loadId;
  selectivity.paramInput = paramFromLoad.input;
  selectivity.paramLoad = paramFromLoad.data;
  saveName = [ 'selectivityFromInput_' loadId '_data'];
  savepath = [ dataPath '/' saveName saveExt];
  if exist( savepath, 'file' )
    fprintf('file exists. renaming file\n');
    saveName = [ saveName datestr(now,'yyyymmdd_HH.MM') ];
  end
  fullName = [saveName saveExt];
  save( fullName, 'fluxSummary','selectivity' )
  movefile( fullName, dataPath );
  fprintf('Finished results %d \n', currId );
end

% 16: parameter input, hopData100
currId = 16;
if any( resultsId == currId )
  storeFlag.storeStdy = 0;
  fprintf('Starting results %d \n', currId );
  fileId = 'initParamsSFromInput';
  pathId = './paperParamInput/';
  loadId = 'hopData100';
  filename = [ pathId loadId ];
  paramFromLoad = poreExperimentParamsToInputs( filename );
  fluxSummary = fluxODEParamIn( plotFlag, storeFlag, 0, dirname,...
    paramFromLoad.input, fileId );
  selectivity.val = fluxSummary.jNorm';
  selectivity.paramLoad = loadId;
  selectivity.paramInput = paramFromLoad.input;
  selectivity.paramLoad = paramFromLoad.data;
  saveName = [ 'selectivityFromInput_' loadId '_data'];
  savepath = [ dataPath '/' saveName saveExt];
  if exist( savepath, 'file' )
    fprintf('file exists. renaming file\n');
    saveName = [ saveName datestr(now,'yyyymmdd_HH.MM') ];
  end
  fullName = [saveName saveExt];
  save( fullName, 'fluxSummary','selectivity' )
  movefile( fullName, dataPath );
  fprintf('Finished results %d \n', currId );
end

% 17: parameter input, hopData200
currId = 17;
if any( resultsId == currId )
  storeFlag.storeStdy = 0;
  fprintf('Starting results %d \n', currId );
  fileId = 'initParamsSFromInput';
  pathId = './paperParamInput/';
  loadId = 'hopData200';
  filename = [ pathId loadId ];
  paramFromLoad = poreExperimentParamsToInputs( filename );
  fluxSummary = fluxODEParamIn( plotFlag, storeFlag, 0, dirname,...
    paramFromLoad.input, fileId );
  selectivity.val = fluxSummary.jNorm';
  selectivity.paramLoad = loadId;
  selectivity.paramInput = paramFromLoad.input;
  selectivity.paramLoad = paramFromLoad.data;
  saveName = [ 'selectivityFromInput_' loadId '_data'];
  savepath = [ dataPath '/' saveName saveExt];
  if exist( savepath, 'file' )
    fprintf('file exists. renaming file\n');
    saveName = [ saveName datestr(now,'yyyymmdd_HH.MM') ];
  end
  fullName = [saveName saveExt];
  save( fullName, 'fluxSummary','selectivity' )
  movefile( fullName, dataPath );
  fprintf('Finished results %d \n', currId );
end

% 18: parameter input, hopData500
currId = 18;
if any( resultsId == currId )
  storeFlag.storeStdy = 0;
  fprintf('Starting results %d \n', currId );
  fileId = 'initParamsSFromInput';
  pathId = './paperParamInput/';
  loadId = 'hopData500';
  filename = [ pathId loadId ];
  paramFromLoad = poreExperimentParamsToInputs( filename );
  fluxSummary = fluxODEParamIn( plotFlag, storeFlag, 0, dirname,...
    paramFromLoad.input, fileId );
  selectivity.val = fluxSummary.jNorm';
  selectivity.paramLoad = loadId;
  selectivity.paramInput = paramFromLoad.input;
  selectivity.paramLoad = paramFromLoad.data;
  saveName = [ 'selectivityFromInput_' loadId '_data'];
  savepath = [ dataPath '/' saveName saveExt];
  if exist( savepath, 'file' )
    fprintf('file exists. renaming file\n');
    saveName = [ saveName datestr(now,'yyyymmdd_HH.MM') ];
  end
  fullName = [saveName saveExt];
  save( fullName, 'fluxSummary','selectivity' )
  movefile( fullName, dataPath );
  fprintf('Finished results %d \n', currId );
end
