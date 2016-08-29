% RunHydroGel 
% Description: Executable. Runs InitParams then main rountine.
% Fix Time issues and build object

% Add paths and see where we are
addpath('./Subroutines');
if ~exist('./Outputs','dir'); mkdir('Outputs'); end;
Time = datestr(now);
currentdir=pwd;
fprintf('In dir %s\n',currentdir);

fprintf('Starting RunHydroGel: %s\n', Time)

% Initparams
fprintf('Initiating parameters\n');
if exist( 'InitParams.m','file'); 
  InitParams;
else
  cpParams
  InitParams
end

% Build TimeObj
[TimeObj] = TimeObjMakerRD(dt,t_tot,t_rec,ss_epsilon,NumPlots);

% Display everything
fprintf('trial:%d A_BC: %s C_BC: %s\n', ...
ParamObj.trial,ParamObj.A_BC, ParamObj.C_BC)
disp(ParamObj); disp(AnalysisObj); disp(TimeObj);

tic
fprintf('Starting run \n')
filename = sprintf('HG_N%d_A%sC%sNL%d_koff%d_konBt%d_t%.2d',...
  ParamObj.Nx, ParamObj.A_BC, ParamObj.C_BC, ParamObj.NLcoup,...
  ParamObj.Koff, ParamObj.Kon .* ParamObj.Bt, ParamObj.trial);
Where2SavePath    = sprintf('%s/%s/%s',pwd,'Outputs',filename);

pVec(1) = ParamObj.Kon;
pVec(2) = ParamObj.Koff;
pVec(3) = ParamObj.Bt;
pVec(4) = ParamObj.Dc / ParamObj.Da;
[RecObj] = ChemDiffMain(filename, ParamObj, TimeObj, AnalysisObj, pVec);
fprintf('Finished run\n')
fprintf('Break = %d Steady = %d\n',RecObj.DidIBreak,RecObj.SteadyState)

% Move things to Outputs
if ParamObj.SaveMe
  mkdir(Where2SavePath)
  movefile([filename '.mat'], Where2SavePath)
  if ~isempty( dir( ['*' filename '*.avi'] ) );  
    movefile(['*' filename '*.avi'], Where2SavePath); 
  end;
  if ~isempty( dir( ['*' filename '*.fig'] ) );  
    movefile(['*' filename '*.fig'], Where2SavePath); 
  end;
  if ~isempty( dir( ['*' filename '*.jpg '] ) );  
    movefile(['*' filename '*.jpg'], Where2SavePath); 
  end;
end
toc
runtime = datestr(now);
fprintf('Ending RunHydroGel: %s\n', runtime)

