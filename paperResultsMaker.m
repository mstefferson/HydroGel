
%
% 1: j vs t nu = 0 fig2.1
% 2: j vs t nu = 1 fig2.2
% 3: S vs kd vary nu fig2.3 (also possible fig S ?)
% 4: nu vs kd vary lc fig 3.2
% 5: S vs kd vary lc fig 3.3
% 6: nu vs kd/S vs kd (kHop = 4) fig. 4.3
% 7: nu vs kd/S vs kd (kHop = 12) fig. S5
% 8: nu vs kd/S vs kd (kHop = 40) fig. S6
% 9: nu vs kd/S vs kd (kHop = 120) fig. S6
% 10: S vs kd vary nu linear numeric fig S1.2
% 11: S vs nu vary kd fig S ?
% 12: S vs nu vary kd linear numeric fig S1.4
% 13: initParamsSFromInput gorlich (numeric)
% 14: initParamsSFromInput gorlich2 (numeric)
%
% Current results for paper: [1:13]

function paperResultsMaker( resultsId )
% set things up
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
% figure 2: selectivity vs time, nu = 1
currId = 2;
if any( resultsId == currId )
  paramFile = 'initParamsJvsTnu1';
  saveName = 'figJvsTnu1_data';
  resultsRunPDE(currId, paramFile, plotFlag, storeFlag,...
    saveName, saveExt, dataPath)
end
% figure 3: selectivity vs kd, vary nu
currId = 3;
if any( resultsId == currId )
  paramFile = 'initParamsSvsKd_nu';
  saveName = 'figSvsKdVaryNu_data';
  resultsRunODE(currId, paramFile, plotFlag, storeFlag,...
    saveName, saveExt, dataPath)
end
% 4: nu vs kd,  vary lc Laura's script
currId = 4;
if any( resultsId == currId )
  saveName = 'figNuVsKd_data';
  resultsNuvsKdVaryLpLcAnalytic(currId, saveName, saveExt, dataPath)
end
% figure 5: selectivity vs kd, vary lplc
currId = 5;
if any( resultsId == currId )
  paramFile = 'initParamsSvsKd_lplc';
  saveName = 'figSvsKdVaryLplc_data';
  resultsRunODE(currId, paramFile, plotFlag, storeFlag,...
    saveName, saveExt, dataPath)
end
% 6: parameter input, hopDataTest4
currId = 6;
if any( resultsId == currId )
  lc = [4]; % in nm
  lcStr = num2str( lc, '%d' );
  resultsHopData( currId, plotFlag, storeFlag, dataPath, lc, lcStr )
end
% 7: parameter input, hopDataTest12
currId = 7;
if any( resultsId == currId )
  lc = [12]; % in nm
  lcStr = num2str( lc, '%d' );
  resultsHopData( currId, plotFlag, storeFlag, dataPath, lc, lcStr )
end
% 8: parameter input, hopDataTest40
currId = 8;
if any( resultsId == currId )
  lc = [40]; % in nm
  lcStr = num2str( lc, '%d' );
  resultsHopData( currId, plotFlag, storeFlag, dataPath, lc, lcStr )
end
% 9: parameter input, hopDataTest120
currId = 9;
if any( resultsId == currId )
  lc = [120]; % in nm
  lcStr = num2str( lc, '%d' );
  resultsHopData( currId, plotFlag, storeFlag, dataPath, lc, lcStr )
end
% figure 10: selectivity vs kd, vary nu linear numeric
currId = 10;
if any( resultsId == currId )
  paramFile = 'initParamsSvsKd_nu_linear';
  saveName = 'figSvsKdVaryNuLinearNumeric_data';
  resultsSvsKdLinNumeric(currId, paramFile, plotFlag, storeFlag,...
    saveName, saveExt, dataPath )
end
% figure 11: selectivity vs nu, vary kd
currId = 11;
if any( resultsId == currId )
  paramFile = 'initParamsSvsNu';
  saveName = 'figSvsNu_data';
  resultsRunODE(currId, paramFile, plotFlag, storeFlag,...
    saveName, saveExt, dataPath)
end
% figure 12: selectivity vs nu, vary kd linear numeric
currId = 12;
if any( resultsId == currId )
  paramFile = 'initParamsSvsNu_linear';
  saveName = 'figSvsNuLinearNumeric_data';
  resultsRunODE(currId, paramFile, plotFlag, storeFlag,...
    saveName, saveExt, dataPath)
end
% 13: parameter input, gorlichData
currId = 13;
if any( resultsId == currId )
  loadId = 'gorlichData';
  resultsSelFromExperiment(currId, loadId, storeFlag, saveExt, dataPath)
end
% 14: parameter input, gorlichData2
currId = 14;
if any( resultsId == currId )
  loadId = 'gorlichData2';
  resultsSelFromExperiment(currId, loadId, storeFlag, saveExt, dataPath)
end

%%%% functions %%%
function resultsNuvsKdVaryLpLcAnalytic(currId, saveName, saveExt, dataPath)
tic
fprintf('Starting results %d \n', currId );
%lc = [4, 12, 40, 120, 1e3]; % in nm
lc = [4, 12, 40, 120, 1200]; % in nm
lcMu = lc * 1e-3;
dA = 0.12;
kon = 1e9; % (per Molar sec)
lp = 1e-3; % mum
tetherCalc.lplc = lcMu .* lp;
tetherCalc.kd = 1e-6 * logspace( -2, 3 ); % in molar
[tetherCalc.nu] = ...
  makeTetherDbs(tetherCalc.lplc, tetherCalc.kd, kon, dA);
tetherCalc.nu = tetherCalc.nu.';
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

function resultsSelFromExperiment(currId, loadId, storeFlag,...
  saveExt, dataPath)
tic
fprintf('Starting results %d \n', currId );
paramLoadFile = [ 'initParamsInput'];
pathId = './paperParamInput/';
filename = [pathId loadId];
% getting parameter
[lbox, bt, lScale] = getParamsInput();
fprintf('For scaling parameters: lBox = %g (um) bt = %g (M)\n', lbox, bt)
paramFromLoad = hopParamsToInput( filename, lbox, lScale, bt );
fluxSummary = fluxODEParamIn( storeFlag, 0, [],...
  paramFromLoad.input, paramLoadFile );
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

function resultsSvsKdLinNumeric(currId, paramFile, ...
  plotFlag, storeFlag, saveName, saveExt, dataPath )
tic
fprintf('Starting results %d \n', currId );
fluxSummary  = fluxODE( plotFlag, storeFlag, 0, [], paramFile );
% put linear data into format taken by linear plotting routine
kdScale = 1e6;
lScaleActual = 1e-7;
lScaleWant = 1e-9;
lScale = (lScaleActual / lScaleWant)^2;
[linSummary.kdVec, linSummary.nulc, linSummary.jNorm ] = ...
  getDataFluxSummary( fluxSummary, kdScale, lScale );  % store linear data
savepath = [ dataPath '/' saveName saveExt];
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
paramFileInput = [ 'initParamsInput' ];
loadPathId = './paperParamInput/';
loadId = ['hopData' lcStr];
paramFileRun = [ 'initParamsSvsKd_lplc' lcStr ];
% Run param inputs
loadname = [ loadPathId loadId ];
fprintf('Running %s from param load %s\n', paramFileInput, loadname );
% getting parameter
[lbox, bt, lScale] = getParamsInput();
paramFromLoad = hopParamsToInput( loadname, lbox, lScale, bt );
fluxSummaryInput = fluxODEParamIn( storeFlag, 0, dirname,...
  paramFromLoad.input, paramFileInput );
fprintf('Finished selectivity calc for input params\n')
selectivity.loadName = loadId;
selectivity.val = fluxSummaryInput.jNorm';
selectivity.paramLoad = loadId;
selectivity.paramInput = paramFromLoad.input;
selectivity.paramLoad = paramFromLoad.data;
selectivity.lc = lc;
% put it in a from that useable for plotting
fprintf('Storing selectivity data in hoppingData\n')
hoppingData = makeHoppingData(selectivity);
fprintf('Finished storing selectivity data in hoppingData\n')
hoppingData.lc = lc;
hoppingData.loadId = loadId;
hoppingData.paramLoadFile = paramFileInput;
% calculate diffusion coeffici
run( paramFileRun )
dA = paramMaster.Da;
kon = 1e9; % (per Molar sec)
% For inputs, use (mum) for length
lcMu = lc * 1e-3;
lp = 1e-3; % mum
lclp = lcMu .* lp;
fprintf('Calculating bound diffusion\n')
[hoppingData.nuTether, ~] = makeTetherDbs(lclp, hoppingData.kdVec, kon, dA);
fprintf('Finished calculating bound diffusion\n')
% store file names
fprintf('Starting fluxODE (tether)\n')
fluxSummaryRun  = fluxODE( plotFlag, storeFlag, saveMe, dirname, paramFileRun );
fprintf('Finished fluxODE (tether)\n')
kdScale = 1e6;
lScaleActual = 1e-7;
lScaleWant = 1e-9;
lScale = (lScaleActual / lScaleWant)^2;
% store things
hoppingData.paramFile = paramFileRun;
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
fprintf('Finished results %d, %f min \n', currId, tOut / 60 );

