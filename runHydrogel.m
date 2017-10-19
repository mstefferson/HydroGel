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
% hard code rand ind power to prevent directory overriding
randSavePow = 4;
% Copy master parameters input object
paramObj = paramMaster;
timeObj = timeMaster;
flagsObj = flags;
% if Nx is too large, reset to something reasonable
if paramObj.Nx > 256; paramObj.Nx = 128; end
% Get correct kinetic params
[~, kinParams] =  kineticParams( paramObj.KonBt, paramObj.Koff, paramObj.Ka, paramObj.Bt );
paramObj.KonBt = kinParams.konBt;
paramObj.Koff = kinParams.koff;
paramObj.Ka = kinParams.kA;
paramObj.Bt = kinParams.Bt;
paramObj.fixedVar = kinParams.fixedVar;
if strcmp( kinParams.fixedVar, 'kA')
  paramObj.kinVar1 = paramObj.KonBt;
  paramObj.kinVar2 = paramObj.Koff;
elseif strcmp( kinParams.fixedVar, 'koff')
  paramObj.kinVar1 = paramObj.KonBt;
  paramObj.kinVar2 = paramObj.Ka;
else % 'konBt'
  paramObj.kinVar1 = paramObj.Koff;
  paramObj.kinVar2 = paramObj.Ka;
end
% Turn off graphics in flag is zero
if graphicsFlag == 0 || flags.SaveMe == 0
  analysisFlags.QuickMovie           = 0;  % Time evolv. Movie
  analysisFlags.PlotAccumFlux        = 0;  % Plot flux vs time
  analysisFlags.PlotMeLastConc       = 0;  % Concentration at end time
  analysisFlags.PlotMeAccum          = 0;  % Concentration at Outlet vs time
  analysisFlags.PlotMeWaveFrontAccum = 0;  % Wavefront and accum
  analysisFlags.PlotMeLastConcAccum  = 0;  % Conc at end time and accum
end
% Display everything
fprintf('trial:%d A_BC: %s C_BC: %s\n', ...
  paramObj.trial,paramObj.A_BC, paramObj.C_BC)
disp(flags); disp(paramObj); disp(analysisFlags); disp(timeObj);
% Make paramMat
fprintf('Building parameter mat \n');
[paramMat, numRuns] = MakeParamMat( paramObj, flagsObj );
fprintf('Executing %d runs \n\n', numRuns);
% For some reason, param_mat gets "sliced". Create vectors to get arround
paramNuLlp  = paramMat(1,:);
paramKonBt  = paramMat(2,:);
paramKoff = paramMat(3,:);
paramBt   = paramMat(4,:);
% pulls and some variables flags out here
SaveMe = flags.SaveMe;
boundDiff = flags.BoundTetherDiff;
Nx = paramObj.Nx; A_BC = paramObj.A_BC; C_BC = paramObj.C_BC;
NLcoup = flags.NLcoup; trial = paramObj.trial;
% Loops over all run
fprintf('Starting loop over runs\n');
ticID = tic;
if numRuns > 1
  recObj = 0;
  parobj = gcp;
  fprintf('I have hired %d workers\n',parobj.NumWorkers);
  % Turn off graphics
  fprintf('Using parfor: turning off graphics\n')
  analysisFlags.QuickMovie = 0; analysisFlags.TrackAccumFromFluxPlot = 0;
  analysisFlags.PlotMeLastConc = 0; analysisFlags.PlotMeAccum = 0;
  analysisFlags.PlotMeWaveFrontAccum = 0; analysisFlags.PlotMeLastConcAccum = 0;
  analysisFlags.CheckConservDen = 0; analysisFlags.ShowRunTime = 0;
  parfor ii = 1:numRuns
    % Assign parameters
    paramvec = [ paramNuLlp(ii) paramKonBt(ii) paramKoff(ii) paramBt(ii) ];
    % Name it
    if boundDiff
      dirname = sprintf('HG_N%d_A%sC%sNL%d_Llp%.1g_konBt%d_koff%d_bt%.1g_t%.2d',...
        Nx, A_BC, C_BC, NLcoup,...
        paramvec(1), paramvec(2), paramvec(3), paramvec(4), trial);
    else
      dirname = sprintf('HG_N%d_A%sC%sNL%d_nu%.1g_konBt%d_koff%d_bt%.1g_t%.2d',...
        Nx, A_BC, C_BC, NLcoup,...
        paramvec(1), paramvec(2), paramvec(3), paramvec(4), trial);
    end
    filename = [dirname '.mat'];
    where2SavePath    = sprintf('%s/%s/%s',pwd,'runfiles',dirname);
    fprintf('\nStarting %s \n', filename);
    % Run main code
    [recObj] = ChemDiffMain(filename, paramObj, timeObj, flagsObj, ...
      analysisFlags, paramvec, koffVary);
    fprintf('Finished %s \n', filename);
    % Move things to runfiles
    if SaveMe
      if exist(where2SavePath,'dir')
        fprintf('You are trying to rewrite data. Renaming \n')
        rng('shuffle');
        where2SavePath = [where2SavePath '_' ...
        num2str( randi(10^randSavePow), ['%.' num2str(randSavePow+1) 'd'] ) ];
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
else
  ii = 1;
  % Assign parameters
  paramvec = [ paramNuLlp(ii) paramKonBt(ii) paramKoff(ii) paramBt(ii) ];
  % Name it
  if boundDiff
    dirname = sprintf('HG_N%d_A%sC%sNL%d_Llp%.1g_konBt%d_koff%d_bt%.1g_t%.2d',...
      Nx, A_BC, C_BC, NLcoup,...
      paramvec(1), paramvec(2), paramvec(3), paramvec(4), trial);
  else
    dirname = sprintf('HG_N%d_A%sC%sNL%d_nu%.1g_konBt%d_koff%d_bt%.1g_t%.2d',...
      Nx, A_BC, C_BC, NLcoup,...
      paramvec(1), paramvec(2), paramvec(3), paramvec(4), trial);
  end
  filename = [dirname '.mat'];
  where2SavePath    = sprintf('%s/%s/%s',pwd,'runfiles',dirname);
  fprintf('\nStarting %s \n', filename);
  % Run main code
  [recObj] = ChemDiffMain(filename, paramObj, timeObj, flagsObj, analysisFlags, paramvec,...
    koffVary);
  fprintf('Finished %s \n', filename);
  % Move things to runfiles
  if SaveMe
    if exist(where2SavePath,'dir')
      fprintf('You are trying to rewrite data. Renaming \n')
      rng('shuffle');
      where2SavePath = [where2SavePath '_' ...
        num2str( randi(10^randSavePow), ['%.' num2str(randSavePow+1) 'd'] ) ];
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
end % numRuns > 1
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
