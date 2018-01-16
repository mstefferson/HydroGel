% runHydroGel
% Description: Executable. Runs initParams then main rountine.
% Fix Time issues and build object

function recObj = runHydrogel(graphicsFlag)
% Add path
addpath( genpath( pwd ) );
if nargin == 0
  graphicsFlag = 0;
end
if graphicsFlag == 0
  fprintf('No graphics\n')
end
% Latex font
set(0,'defaulttextinterpreter','latex')
% Add paths and see where we are
addpath( genpath('./src') )
if ~exist('./runfiles','dir'); mkdir('runfiles'); end
Time = datestr(now);
currentdir=pwd;
fprintf('In dir %s\n',currentdir);
fprintf('Starting RunHydroGel: %s\n', Time)
% Initparams
fprintf('Initiating parameters\n');
if exist( 'initParams.m','file')
  initParams;
else
  cpParams
  initParams
end
% Copy master parameters input object
paramObj = paramMaster;
timeObj = timeMaster;
flagsObj = flags;
% Build timeObj
[timeObj] = TimeObjMakerRD(timeObj.dt,timeObj.t_tot,...
  timeObj.t_rec,timeObj.ss_epsilon);
% set-up params
[paramObj, kinParams] = paramInputMaster( paramObj, koffVary );
% Turn off graphics in flag is zero
if graphicsFlag == 0 || flags.SaveMe == 0
  analysisFlags.QuickMovie           = 0;  % Time evolv. Movie
  analysisFlags.PlotAccumFlux        = 0;  % Plot flux vs time
  analysisFlags.PlotMeLastConc       = 0;  % Concentration at end time
  analysisFlags.PlotMeAccum          = 0;  % Concentration at Outlet vs time
  analysisFlags.PlotMeWaveFrontAccum = 0;  % Wavefront and accum
  analysisFlags.PlotMeLastConcAccum  = 0;  % Conc at end time and accum
end
% For some reason, param_mat gets "sliced". Create vectors to get arround
paramNuLlp  = kinParams.nuLlp;
paramKonBt  = kinParams.konBt;
paramKoffInds = kinParams.koffInds;
paramBt   = kinParams.Bt;
numRuns = kinParams.numRuns;
% Display everything
fprintf('trial:%d A_BC: %s C_BC: %s\n', ...
  paramObj.trial,paramObj.A_BC, paramObj.C_BC)
disp(flags); disp(paramObj); disp(analysisFlags); disp(timeObj);
fprintf('Executing %d runs \n\n', numRuns);
% pulls and some variables flags out here
SaveMe = flags.SaveMe;
boundDiffStr = paramObj.DbParam{1};
Nx = paramObj.Nx; A_BC = paramObj.A_BC; C_BC = paramObj.C_BC;
NLcoup = flags.NLcoup; trial = paramObj.trial;
% Loops over all run
fprintf('Starting loop over runs\n');
ticID = tic;
if numRuns > 1 && flags.ParforFlag
  recObj = 0;
  parobj = gcp;
  numWorkers = parobj.NumWorkers;
  fprintf('I have hired %d workers\n',parobj.NumWorkers);
  % Turn off graphics
  fprintf('Using parfor: turning off graphics\n')
  analysisFlags.QuickMovie           = 0;  % Time evolv. Movie
  analysisFlags.PlotAccumFlux        = 0;  % Plot flux vs time
  analysisFlags.PlotMeLastConc       = 0;  % Concentration at end time
  analysisFlags.PlotMeAccum          = 0;  % Concentration at Outlet vs time
  analysisFlags.PlotMeWaveFrontAccum = 0;  % Wavefront and accum
  analysisFlags.PlotMeLastConcAccum  = 0;  % Conc at end time and accum
else
  fprintf('Not using parfor\n')
  numWorkers = 0;
end
parfor (ii=1:numRuns, numWorkers)
  % Assign parameters
  paramvec = [ paramNuLlp(ii) paramKonBt(ii) paramKoffInds(ii) paramBt(ii) ];
  % Name it
  dirname = sprintf('HG_N%d_A%sC%sNL%d_%s%.1g_konBt%d_koff%d_bt%.1g_t%.2d',...
      Nx, A_BC, C_BC, NLcoup, boundDiffStr,...
      paramvec(1), paramvec(2), paramvec(3), paramvec(4), trial);
  filename = [dirname '.mat'];
  where2SavePath = [pwd '/runfiles/' dirname];
  fprintf('\nStarting %s \n', filename);
  %Run main code
    [recObj] = ChemDiffMain(filename, paramObj, timeObj, flagsObj, ...
      analysisFlags, paramvec ); 
  fprintf('Finished %s \n', filename);
  % Move things to runfiles
  if SaveMe
    if exist(where2SavePath,'dir')
      fprintf('You are trying to rewrite data. Renaming \n')
      where2SavePath = [pwd '/runfiles/' ...
        datestr(now,'yyyymmdd') '_' dirname '_' num2str( randi(1000) )];
    end
    fprintf('Saving at %s \n', where2SavePath);
    mkdir(where2SavePath)
    movefile(filename, where2SavePath)
    if ~isempty( dir( ['*' filename '*.avi'] ) )
      movefile(['*' dirname '*.avi'], where2SavePath);
    end
    if ~isempty( dir( ['*' dirname '*.fig'] ) )
      movefile(['*' filename '*.fig'], where2SavePath);
    end
    if ~isempty( dir( ['*' dirname '*.jpg '] ) )
      movefile(['*' filename '*.jpg'], where2SavePath);
    end
  end
end % parfor
% Print time info
runTime = toc(ticID);
dateTime =  datestr(now);
fprintf('Ending RunHydroGel: %s\n', dateTime)
runHr = floor( runTime / 3600); runTime = runTime - runHr*3600;
runMin = floor( runTime / 60);  runTime = runTime - runMin*60;
runSec = floor(runTime);
fprintf('RunTime: %.2d:%.2d:%.2d (hr:min:sec)\n', runHr, runMin,runSec);
fprintf('Finished RunHardRod: %s\n', dateTime);
end
