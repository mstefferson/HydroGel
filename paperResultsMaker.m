% Id Key
%
% 1: initParamsJvsT
% 2: initParamsSvsKd vary lplc (course and fine)
% 3: initParamsDenProfile 
% 4: initParamsSvsNu (course and fine)
% 5: paramInput selectivity calc
% 6: nu vs Kd (Laura's script)
% 7: outlet reservoir accumulation 
% 8: Selectivity heatmap Kd vs Nu
% 9: Selectivity heatmap Kd vs Lc
% 10: initParamsSvsKd vary nu (course and fine)
%

function paperResultsMaker( resultsId )
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
% figure 1: selectivity vs time
if any( resultsId == 1 )
  currId = 1;
  fprintf('Starting results %d \n', currId );
  storeFlag.storeStdy = 0;
  storeFlag.storeTimeDep = 1;
  paramFile = 'initParamsJvsT';
  saveName = 'figJvsT_data';
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
if any( resultsId == 2 )
  currId = 2;
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
if any( resultsId == 3 )
  currId = 3;
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
if any( resultsId == 4 )
  currId = 4;
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
if any( resultsId == 5 )
  currId = 5;
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
% 6: Laura's script
if any( resultsId == 6 )
  currId = 6;
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
if any( resultsId == 7 )
  currId = 7;
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
if any( resultsId == 8 )
  currId = 8;
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
if any( resultsId ==  9)
  currId = 9;
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
if any( resultsId == 10 )
  currId = 10;
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
end %function
