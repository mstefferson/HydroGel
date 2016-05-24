clear
clc

CurrentDir = pwd;
addpath( genpath( CurrentDir) );

RunMe           = 1;
ParamObj.trial  = 1;
ParamObj.SaveMe = 0;

% Turn things on
ParamObj.NLcoup        = 1;
ParamObj.ChemOnEndPts  = 1;


% "Analysis" subroutines
AnalysisObj.QuickMovie             = 1;  % Time evolv. Movie
AnalysisObj.TrackAccumFromFlux     = 1;  % Track the flux into outlet
AnalysisObj.TrackAccumFromFluxPlot = 1;  % Plot flux vs time
AnalysisObj.PlotMeLastConc         = 1;  % Concentration at end time
AnalysisObj.PlotMeAccum            = 1;  % Concentration at Outlet vs time
AnalysisObj.PlotMeWaveFrontAccum   = 1;  % Wavefront and accum
AnalysisObj.PlotMeLastConcAccum    = 1;  % Conc at end time and accum
AnalysisObj.CheckConservDen        = 1;  % Check if density is conserved
AnalysisObj.ShowRunTime            = 1;  % Display run time

%Spatial grid
ParamObj.Lbox  = 1; % Gel length
Nx    = 128;  % Internal gridpoints
ParamObj.Nx    = floor(Nx*ParamObj.Lbox); % Scale by box. Careful!!!
ParamObj.Lr = 10; % Reservoir length if there is one


%Non Dimensional and Concentration
ParamObj.KDinv = 1e4; % Binding affinity
ParamObj.Koff  = 1e2; % scaled koff
ParamObj.Kon   = ParamObj.KDinv * ParamObj.Koff;  % scaled kon
ParamObj.Da    = 1; % Diffusion of species A (unbound)
ParamObj.Dc    = 1; % Dc/Da
ParamObj.Dnl   = 1; % Dsat/DA. Only used for nonlinear diffusion beta  > 1?
ParamObj.Bt    = 2e-3;  % molar (old: 1e-2) (new: 1e-3)
ParamObj.AL    = 2e-4;  % concentration of inlet
ParamObj.AR    = 0; % concentration of outlet

% Binding flag 0: constant. 1: Square blurr
ParamObj.BindSiteDistFlag = 1; % flag turn on spatially varying binding sites
ParamObj.alpha  = 0.1;  % length scale (frac of box) where binding sites change
% Turn on if diffusion depends on Bt. If Bt varies spatially,
% Diff_A = 0, Diff_C = Max when Bt(x) = Btc.
ParamObj.BtDepDiff  = 0;  % Turn on if diffusion depends on Bt.
ParamObj.Btc   = ParamObj.Bt; % Critial Bt
if ParamObj.BindSiteDistFlag ~= 0
  ParamObj.sigma  = ParamObj.alpha * ParamObj.Lbox ;
else
  ParamObj.BtDepDiff = 0;
  ParamObj.sigma = 0;
end

% time
tfac        = 1;
dt          = tfac*(ParamObj.Lbox/(ParamObj.Nx-1))^2; % time step
t_tot       = 1 * tfac * ParamObj.Lbox^2 /  ParamObj.Da;  % total time
t_rec       = t_tot / 100;  % time interval for recording dynamics
ss_epsilon  = 1e-12;  % steady state condition
NumPlots    = 10; % For the accumulation plot subroutine

% Boundary conditions: 'Dir', 'Vn', 'Res','PBC', 'Mx'
% 'Dir': Fixed Concenctration on left and right
% 'Vn': No flux on left and right
% 'Res': Reservoirs
% 'PBC': Periodic. Don't think this works
% 'Mx': Fixed Concenctration on left and no flux right
ParamObj.A_BC = 'Dir';
ParamObj.C_BC = 'Vn';
fprintf('trial:%d A_BC: %s C_BC: %s\n', ...
  ParamObj.trial,ParamObj.A_BC, ParamObj.C_BC)

% Fix Time issues and build object
[TimeObj] = TimeObjMakerRD(dt,t_tot,t_rec,ss_epsilon,NumPlots);

FileDir = sprintf('RdNx%dA%sC%st%d',...
  ParamObj.Nx,ParamObj.A_BC,ParamObj.C_BC,ParamObj.trial);
Where2SavePath    = sprintf('%s/%s/%s',pwd,'Outputs',FileDir);
% disp( max(dt * (Nx/Lbox)^2,nu * dt * (Nx/Lbox)^2) )

if ParamObj.SaveMe
  diary('RunDiary.txt')
end

% Display everything
  disp(ParamObj); disp(AnalysisObj); disp(TimeObj);
% Run the jewels
if RunMe == 1
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
    movefile('*.avi', Where2SavePath)
  end
  toc
  fprintf('Break = %d Steady = %d\n',DidIBreak,SteadyState)
  %     cd /home/mws/Documents/MATLAB/Research/BG/DDFT/HRddft/Drive/IsoDiffCube
end




