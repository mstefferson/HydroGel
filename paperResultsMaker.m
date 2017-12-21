% Id Key
%
% 1: initParamsJvsT  nu 0
% 2: initParamsSvsKd vary lplc
% 3: initParamsDenProfile
% 4: initParamsSvsNu 
% 5: paramInput selectivity calc
% 6: nu vs Kd 
% 7: outlet reservoir accumulation
% 8: Selectivity heatmap Kd vs Nu
% 9: Selectivity heatmap Kd vs Lc
% 10: initParamsSvsKd vary nu
% 11: initParamsSvsKd linear vary lplc (analytic)
% 12: initParamsSvsKd linear vary lplc (numeric)
% 13: initParamsJvsT  nu 1
% 14: initParamsSFromInput gorlich (numeric)
% 15: initParamsSFromInput gorlich2 (numeric)
% 16: initParamsSFromInput hopDataTest (numeric)
% 17: initParamsSFromInput hopData100 (numeric)
% 18: initParamsSFromInput hopData200 (numeric)
% 19: initParamsSFromInput hopData500 (numeric)
% 20: initParamsSFromInput hopData100Hop0 (numeric)
% 21: initParamsSvsNu_linear
% 22: initParamsSvsKd vary nu linear
%
% Current results for paper: [1 2 3 10 11 12 13 14 15 17 18 19]

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
% turn off/on store
storeFlag.storeStdy = 0;
storeFlag.storeTimeDep = 1;
% turn store off/on based on run
dataPath = 'paperData';
if ~exist( dataPath,'dir' )
  mkdir( dataPath )
end
% figure 1: selectivity vs time, nu = 0
currId = 1;
if any( resultsId == currId )
  paramFile = 'initParamsJvsTnu0';
  saveName = 'figJvsTnu0_data';
  resultsRunPDE(currId, paramFile, plotFlag, storeFlag,...
    saveName, saveExt, dataPath)
end
% figure 2: selectivity vs kd, vary lplc
currId = 2;
if any( resultsId == currId )
  paramFile = 'initParamsSvsKd_lplc';
  saveName = 'figSvsKdVaryLplc_data';
  resultsRunODE(currId, paramFile, plotFlag, storeFlag,...
    saveName, saveExt, dataPath)
end
% figure 3: density profiles
currId = 3;
if any( resultsId == currId )
  storeFlagTemp = storeFlag;
  storeFlagTemp.storeStdy = 1;
  paramFile = 'initParamsDenProfile';
  saveName = 'figDenProfile_data';
  resultsRunODE(currId, paramFile, plotFlag, storeFlagTemp,...
    saveName, saveExt, dataPath)
end
% figure 4: initParamsSvsNu vary kd
currId = 4;
if any( resultsId == currId )
  paramFile = 'initParamsSvsNu';
  saveName = 'figSvsNu_data';
  resultsRunODE(currId, paramFile, plotFlag, storeFlag,...
    saveName, saveExt, dataPath)
end
% 5: parameter input.
currId = 5;
if any( resultsId == currId )
  tic
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
  tOut = toc;
  fprintf('Finished results %d, %f min \n', currId, tOut / 60 );
end
% 6: nu vs kd, Laura's script
currId = 6;
if any( resultsId == currId )
  tic
  fprintf('Starting results %d \n', currId );
  lc = [10, 30, 100, 300, 1000, 1e4]; % in nm
  tetherCalc.kd = 1e-6 * logspace( -2, 3 ); % in molar
  [tetherCalc.nu, ~,tetherCalc.lplc] = makeTetherDBs(lc, tetherCalc.kd);
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
  tOut = toc;
  fprintf('Finished results %d, %f min \n', currId, tOut / 60 );
end
% 7: Reservior accumulation
currId = 7;
if any( resultsId == currId )
  storeFlag.storeStdy = 1;
  paramFile = 'initParamsOutletResAccum';
  saveName = 'figResAccum_data';
  resultsRunPDE(currId, paramFile, plotFlag, storeFlag,...
    saveName, saveExt, dataPath)
  storeFlag.storeStdy = 0;
end
% 8: Selectivity heat map, Kd vs Nu
currId = 8;
if any( resultsId == currId )
  paramFile = 'initParamsSheatmapKdNu';
  saveName = 'figSheatmapKdNu_data';
  resultsRunODE(currId, paramFile, plotFlag, storeFlag,...
    saveName, saveExt, dataPath)
end
% 9: Selectivity heat map, Kd vs lclp
currId = 9;
if any( resultsId == currId )
  paramFile = 'initParamsSheatmapKdLclp';
  saveName = 'figSheatmapKdLcLp_data';
  resultsRunODE(currId, paramFile, plotFlag, storeFlag,...
    saveName, saveExt, dataPath)
end
% figure 10: selectivity vs kd, vary nu
currId = 10;
if any( resultsId == currId )
  paramFile = 'initParamsSvsKd_nu';
  saveName = 'figSvsKdVaryNu_data';
  resultsRunODE(currId, paramFile, plotFlag, storeFlag,...
    saveName, saveExt, dataPath)
end
% figure 11: selectivity vs kd linear analytic, vary lplc
currId = 11;
if any( resultsId == currId )
  tic
  fprintf('Starting results %d \n', currId );
  saveName = 'figSvsKdVaryLplcLinearAnalytic_data';
  initParamsSvsKd_analytic();
  [linSummary.kdVec, linSummary.nulc, linSummary.jNorm] = ...
    linearSelVsKD(kd_range, lc_values,0);
  savepath = [ dataPath '/' saveName saveExt];
  if exist( savepath, 'file' )
    fprintf('file exists. renaming file\n');
    saveName = [ saveName datestr(now,'yyyymmdd_HH.MM') ];
  end
  fullName = [saveName saveExt];
  save( fullName, 'linSummary' )
  movefile( fullName, dataPath );
  tOut = toc;
  fprintf('Finished results %d, %f min \n', currId, tOut / 60 );
end
% figure 12: selectivity vs kd linear numeric, vary lplc
currId = 12;
if any( resultsId == currId )
  paramFile = 'initParamsSvsKd_lplc_linear';
  saveName = 'figSvsKdVaryLplcLinearNumeric_data';
  resultsSvsKdLinNumeric(currId, paramFile, saveName, plotFlag, storeFlag )
end
% figure 13: selectivity vs time, nu = 1
currId = 13;
if any( resultsId == currId )
  paramFile = 'initParamsJvsTnu1';
  saveName = 'figJvsTnu1_data';
  resultsRunPDE(currId, paramFile, plotFlag, storeFlag,...
    saveName, saveExt, dataPath)
end
% 14: parameter input, gorlichData
currId = 14;
if any( resultsId == currId )
  loadId = 'gorlichData';
  resultsSelFromExperiment(currId, loadId, storeFlag, saveExt, dataPath)
end
% 15: parameter input, gorlichData2
currId = 15;
if any( resultsId == currId )
  loadId = 'gorlichData2';
  resultsSelFromExperiment(currId, loadId, storeFlag, saveExt, dataPath)
end
% 16: parameter input, hopDataTest
currId = 16;
if any( resultsId == currId )
  lc = [100]; % in nm
  lcStr = 'Test';
  resultsHopData( currId, plotFlag, storeFlag, dataPath, lc, lcStr )
end
% 17: parameter input, hopDataTest100
currId = 17;
if any( resultsId == currId )
  lc = [100]; % in nm
  lcStr = num2str( lc, '%d' );
  resultsHopData( currId, plotFlag, storeFlag, dataPath, lc, lcStr )
end
% 18: parameter input, hopDataTest200
currId = 18;
if any( resultsId == currId )
  lc = [200]; % in nm
  lcStr = num2str( lc, '%d' );
  resultsHopData( currId, plotFlag, storeFlag, dataPath, lc, lcStr )
end

% 19: parameter input, hopDataTest500
currId = 19;
if any( resultsId == currId )
  lc = [500]; % in nm
  lcStr = num2str( lc, '%d' );
  resultsHopData( currId, plotFlag, storeFlag, dataPath, lc, lcStr )
end
% 20: parameter input, hopDataTest100Hop0
currId = 20;
if any( resultsId == currId )
  lc = [100]; % in nm
  lcStr = [ num2str( lc, '%d' ) 'Hop0' ];
  resultsHopData( currId, plotFlag, storeFlag, dataPath, lc, lcStr )
end

% figure 21: initParamsSvsNu_linear
currId = 21;
if any( resultsId == currId )
  paramFile = 'initParamsSvsNu_linear';
  saveName = 'figSvsNuLinearNumeric_data';
  resultsRunODE(currId, paramFile, plotFlag, storeFlag,...
    saveName, saveExt, dataPath)
end
% figure 22: selectivity vs kd, vary nu linear numeric
currId = 22;
if any( resultsId == currId )
 paramFile = 'initParamsSvsKd_nu_linear';
 saveName = 'figSvsKdVaryNuLinearNumeric_data';
 resultsSvsKdLinNumeric(currId, paramFile, saveName, plotFlag, storeFlag )
end

%%%% functions %%%
function resultsSelFromExperiment(currId, loadId, storeFlag,...
  saveExt, dataPath)
  tic
  fprintf('Starting results %d \n', currId );
  fileId = 'initParamsSFromInput';
  pathId = './paperParamInput/';
  filename = [ pathId loadId ];
  paramFromLoad = poreExperimentParamsToInputs( filename );
  fluxSummary = fluxODEParamIn( storeFlag, 0, [],...
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
  tOut = toc;
  fprintf('Finished results %d, %f min \n', currId, tOut / 60 );

function resultsRunPDE(currId, paramFile, plotFlag, storeFlag,...
  saveName, saveExt, dataPath)
  tic
  fprintf('Starting results %d \n', currId );
  fluxSummary  = fluxPDE( plotFlag, storeFlag, 0, [], paramFile );
  savepath = [ dataPath '/' saveName saveExt];
  if exist( savepath, 'file' )
    fprintf('file exists. renaming file\n');
    saveName = [ saveName datestr(now,'yyyymmdd_HH.MM') ];
  end
  fullName = [saveName saveExt];
  save( fullName, 'fluxSummary' )
  movefile( fullName, dataPath );
  tOut = toc;
  fprintf('Finished results %d, %f min \n', currId, tOut / 60 );

function resultsRunODE(currId, paramFile, plotFlag, storeFlag,...
  saveName, saveExt, dataPath)
  tic
  fprintf('Starting results %d \n', currId );
  fluxSummary  = fluxODE( plotFlag, storeFlag, 0, [], paramFile );
  savepath = [ dataPath '/' saveName saveExt];
  if exist( savepath, 'file' )
    fprintf('file exists. renaming file\n');
    saveName = [ saveName datestr(now,'yyyymmdd_HH.MM') ];
  end
  fullName = [saveName saveExt];
  save( fullName, 'fluxSummary' )
  movefile( fullName, dataPath );
  tOut = toc;
  fprintf('Finished results %d, %f min \n', currId, tOut / 60 );

function resultsSvdKdLinNumeric(currId, paramFile, saveName, dataPath,...
    plotFlag, storeFlag )
  tic
  fprintf('Starting results %d \n', currId );
  fluxSummary  = fluxODE( plotFlag, storeFlag, 0, dirname, paramFile );
  % put linear data into format taken by linear plotting routine
  kdScale = 1e6;
  lScaleActual = 1e-7;
  lScaleWant = 1e-9;
  lScale = (lScaleActual / lScaleWant)^2;
  [linSummary.kdVec, linSummary.nulc, linSummary.jNorm ] = ...
    getDataFluxSummary( fluxSummary, kdScale, lScale );  % store linear data
  savepath = [ dataPath '/' saveName saveExt];  savepath = [ dataPath '/' saveName saveExt];
  if exist( savepath, 'file' )
    fprintf('file exists. renaming file\n');
    saveName = [ saveName datestr(now,'yyyymmdd_HH.MM') ];
  end
  fullName = [saveName saveExt];
  save( fullName, 'fluxSummary', 'linSummary' )
  movefile( fullName, dataPath );
  tOut = toc;
  fprintf('Finished results %d, %f min \n', currId, tOut / 60 );

function resultsHopData( ...
  currId, plotFlag, storeFlag, dataPath, lcVal, lcStr )
tic
fprintf('Starting results %d \n', currId );
% turn off saving stuff
saveMe = 0;
dirname = 'blah';
saveExt = '.mat';
lc = lcVal; % in nm
storeFlag.storeStdy = 0;
% names
paramLoadFile = [ 'initParamsSFromInput'   ];
pathId = './paperParamInput/';
loadId = ['hopData' lcStr];
paramFile = [ 'initParamsSvsKd_lplc' lcStr ];
% Run param inputs
fprintf('Running %s\n', loadId );
filename = [ pathId loadId ];
paramFromLoad = poreExperimentParamsToInputs( filename );
fluxSummaryInput = fluxODEParamIn( storeFlag, 0, dirname,...
  paramFromLoad.input, paramLoadFile );
fprintf('Finished paramInput\n')
selectivity.loadName = loadId;
selectivity.val = fluxSummaryInput.jNorm';
selectivity.paramLoad = loadId;
selectivity.paramInput = paramFromLoad.input;
selectivity.paramLoad = paramFromLoad.data;
selectivity.lc = lc;
% put it in a from that useable for plotting
hoppingData = makeHoppingData(selectivity);
hoppingData.lc = lc;
% calculate diffusion coeffici
[hoppingData.nuTether, ~, ~] =...
  makeTetherDBs(lc, hoppingData.kdVec);
fprintf('Finished calculating bound diffusion\n')
% store file names
hoppingData.loadId = loadId;
hoppingData.paramLoadFile = paramLoadFile;
hoppingData.paramFile = paramFile;
fluxSummaryRun  = fluxODE( plotFlag, storeFlag, saveMe, dirname, paramFile );
fprintf('Finished fluxODE (tether)\n')
kdScale = 1e6;
lScaleActual = 1e-7;
lScaleWant = 1e-9;
lScale = (lScaleActual / lScaleWant)^2;
hoppingData.lcUnscaled = fluxSummaryRun.kinParams.p1Vec;
[hoppingData.kdVecScaled, hoppingData.lcScaled, hoppingData.selTether] = ...
  getDataFluxSummary( fluxSummaryRun, kdScale, lScale );  % get data
hoppingData.kdVecScaled = hoppingData.kdVecScaled.';
saveName = [ 'hoppingData_' loadId '_data'];
savepath = [ dataPath '/' saveName saveExt];
if exist( savepath, 'file' )
  fprintf('file exists. renaming file\n');
  saveName = [ saveName datestr(now,'yyyymmdd_HH.MM') ];
end
fullName = [saveName saveExt];
save( fullName, 'fluxSummaryInput', 'fluxSummaryRun',...
  'selectivity', 'hoppingData' )
movefile( fullName, dataPath );
tOut = toc;
fprintf('Finished results %d, %f sec \n', currId, tOut);

