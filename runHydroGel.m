% runHydroGel
% Description: Executable. Runs initParams then main rountine.
% Fix Time issues and build object

function RecObj = runHydroGel()
% Latex font
set(0,'defaulttextinterpreter','latex')
% Add paths and see where we are
addpath( genpath('./src') )
if ~exist('./runfiles','dir'); mkdir('runfiles'); end;
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
% Display everything
fprintf('trial:%d A_BC: %s C_BC: %s\n', ...
  paramObj.trial,paramObj.A_BC, paramObj.C_BC)
disp(flags); disp(paramObj); disp(analysisFlags); disp(timeObj);
% Make paramMat
fprintf('Building parameter mat \n');
[paramMat, numRuns] = MakeParamMat( paramObj, flagsObj );
fprintf('Executing %d runs \n\n', numRuns);
% For some reason, param_mat gets "sliced". Create vectors to get arround
paramNuLlp     = paramMat(1,:); paramKoff = paramMat(2,:);
paramKonBt  = paramMat(3,:); paramBt   = paramMat(4,:);
% pulls and some variables flags out here
SaveMe = flags.SaveMe;
boundDiff = flags.BoundTetherDiff;
Nx = paramObj.Nx; A_BC = paramObj.A_BC; C_BC = paramObj.C_BC; 
NLcoup = flags.NLcoup; trial = paramObj.trial;
% Loops over all run
fprintf('Starting loop over runs\n');
ticID = tic;
if numRuns > 1
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
    paramvec = [ paramNuLlp(ii) paramKoff(ii) paramKonBt(ii) paramBt(ii) ];
    % Name it
    if boundDiff
      filename = sprintf('HG_N%d_A%sC%sNL%d_Llp%.1g_koff%d_konBt%d_bt%.1g_t%.2d',...
        Nx, A_BC, C_BC, NLcoup,...
        paramvec(1), paramvec(2), paramvec(3), paramvec(4), trial);
    else
      filename = sprintf('HG_N%d_A%sC%sNL%d_nu%.1g_koff%d_konBt%d_bt%.1g_t%.2d',...
        Nx, A_BC, C_BC, NLcoup,...
        paramvec(1), paramvec(2), paramvec(3), paramvec(4), trial);
    end
    Where2SavePath    = sprintf('%s/%s/%s',pwd,'runfiles',filename);
    fprintf('\nStarting %s \n', filename);
    % Run main code
    [~] = ChemDiffMain(filename, paramObj, timeObj, flagsObj, analysisFlags, paramvec);
    fprintf('Finished %s \n', filename);
    % Move things to runfiles
    if SaveMe
      mkdir(Where2SavePath)
      movefile([filename '.mat'], Where2SavePath)
      if ~isempty( dir( ['*' filename '*.avi'] ) )
        movefile(['*' filename '*.avi'], Where2SavePath);
      end;
      if ~isempty( dir( ['*' filename '*.fig'] ) )
        movefile(['*' filename '*.fig'], Where2SavePath);
      end;
      if ~isempty( dir( ['*' filename '*.jpg '] ) )
        movefile(['*' filename '*.jpg'], Where2SavePath);
      end;
    end
  end % parfor
else
  % Assign parameters
  paramvec = [ paramNuLlp(1) paramKoff(1) paramKonBt(1) paramBt(1) ];
  % Name it
  if boundDiff
    filename = sprintf('HG_N%d_A%sC%sNL%d_Llp%.1g_koff%d_konBt%d_bt%.1g_t%.2d',...
      Nx, A_BC, C_BC, NLcoup,...
      paramvec(1), paramvec(2), paramvec(3), paramvec(4), trial);
  else
    filename = sprintf('HG_N%d_A%sC%sNL%d_nu%.1g_koff%d_konBt%d_bt%.1g_t%.2d',...
      Nx, A_BC, C_BC, NLcoup,...
      paramvec(1), paramvec(2), paramvec(3), paramvec(4), trial);
  end
  Where2SavePath    = sprintf('%s/%s/%s',pwd,'runfiles',filename);
  fprintf('\nStarting %s \n', filename);
  % Run main code
  [RecObj] = ChemDiffMain(filename, paramObj, timeObj, flags, analysisFlags, paramvec);
  fprintf('Finished %s \n', filename);
  % Move things to runfiles
  if SaveMe
    mkdir(Where2SavePath)
    movefile([filename '.mat'], Where2SavePath)
    if ~isempty( dir( ['*' filename '*.avi'] ) )
      movefile(['*' filename '*.avi'], Where2SavePath);
    end;
    if ~isempty( dir( ['*' filename '*.fig'] ) )
      movefile(['*' filename '*.fig'], Where2SavePath);
    end;
    if ~isempty( dir( ['*' filename '*.jpg '] ) )
      movefile(['*' filename '*.jpg'], Where2SavePath);
    end;
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
