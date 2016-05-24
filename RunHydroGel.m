% RunHydroGel 
% Description: Executable. Runs InitParams then main rountine.
% Fix Time issues and build object

% Add paths and see where we are
addpath('./Subroutines');
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

FileDir = sprintf('RdNx%dA%sC%st%d',...
  ParamObj.Nx,ParamObj.A_BC,ParamObj.C_BC,ParamObj.trial);
Where2SavePath    = sprintf('%s/%s/%s',pwd,'Outputs',FileDir);
% disp( max(dt * (Nx/Lbox)^2,nu * dt * (Nx/Lbox)^2) )

if ParamObj.SaveMe
  diary('RunDiary.txt')
end

% Display everything
fprintf('trial:%d A_BC: %s C_BC: %s\n', ...
ParamObj.trial,ParamObj.A_BC, ParamObj.C_BC)
disp(ParamObj); disp(AnalysisObj); disp(TimeObj);

tic
fprintf('Starting run \n')
[A_rec,C_rec,DidIBreak,SteadyState] = ChemDiffMain(ParamObj,TimeObj,AnalysisObj);
fprintf('Finished run\n')

% Move things to Outputs
if ParamObj.SaveMe
  diary off
  mkdir(Where2SavePath)
  movefile('*.mat', Where2SavePath)
  movefile('*.txt', Where2SavePath)
  if AnalysisObj.QuickMovie; movefile('*.avi', Where2SavePath); end;
  if AnalysisObj.TrackAccumFromFluxPlot; movefile('*.fig',Where2SavePath); end;
end
toc
fprintf('Break = %d Steady = %d\n',DidIBreak,SteadyState)
%     cd /home/mws/Documents/MATLAB/Research/BG/DDFT/HRddft/Drive/IsoDiffCube
Time = datestr(now);
fprintf('Ending RunHydroGel: %s\n', Time)

