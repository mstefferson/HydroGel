% Master Parameter template. Tracked by git. Don't edit unless 
% adding a parameter.

CurrentDir = pwd;
addpath( genpath( CurrentDir) );

paramMaster.trial  = 1;

% Turn things on
flags.SaveMe = 1;
flags.NLcoup        = 1;
flags.ChemOnEndPts  = 1;
flags.BindSiteDistFlag = 0; % flag turn on spatially varying binding sites
flags.BtDepDiff  = 0;  % Turn on if diffusion depends on Bt.

% "Analysis" subroutines
analysisFlags.QuickMovie             = 1;  % Time evolv. Movie
analysisFlags.TrackAccumFromFlux     = 1;  % Track the flux into outlet
analysisFlags.TrackAccumFromFluxPlot = 1;  % Plot flux vs time
analysisFlags.PlotMeLastConc         = 1;  % Concentration at end time
analysisFlags.PlotMeAccum            = 0;  % Concentration at Outlet vs time
analysisFlags.PlotMeWaveFrontAccum   = 0;  % Wavefront and accum
analysisFlags.PlotMeLastConcAccum    = 0;  % Conc at end time and accum
analysisFlags.CheckConservDen        = 0;  % Check if density is conserved
analysisFlags.ShowRunTime            = 1;  % Display run time

%Spatial grid
paramMaster.Lbox  = 1; % Gel length
Nx    = 128;  % Internal gridpoints
paramMaster.Nx    = floor(Nx*paramMaster.Lbox); % Scale by box. Careful!!!
paramMaster.Lr = 10; % Reservoir length if there is one

%Non Dimensional and Concentration
paramMaster.Da     = 1; % Diffusion of species A (unbound). Sets time scale
paramMaster.nu     = [1]; % vec Dc/Da aka nu 
paramMaster.Koff   = [1e2]; % vec koff (time scale)
paramMaster.KonBt  = [1e2 1e2];  % vec konBt (time scale)
paramMaster.Bt     = [1e-3 2-4];  % vec molar (old: 1e-2) (new: 1e-3)
paramMaster.Dnl    = 1; % Dsat/DA. Only used for nonlinear diffusion beta  > 1?
paramMaster.AL     = 2e-4;  % concentration of inlet
paramMaster.AR     = 0; % concentration of outlet

% time
tfac        = 1;
dtfac       = 1;
dt          = dtfac *(paramMaster.Lbox/(paramMaster.Nx))^2; % time step
t_tot       = tfac * paramMaster.Lbox^2 /  paramMaster.Da;  % total time
t_rec       = t_tot / 100;  % time interval for recording dynamics
ss_epsilon  = 1e-8;  % steady state condition
NumPlots    = 10; % For the accumulation plot subroutine

% Build timeObj
[timeMaster] = TimeObjMakerRD(dt,t_tot,t_rec,ss_epsilon,NumPlots);
% Binding flag 0: constant. 1: Square blurr
paramMaster.alpha  = 0.1;  % length scale (frac of box) where binding sites change
% Turn on if diffusion depends on Bt. If Bt varies spatially,
% Diff_A = 0, Diff_C = Max when Bt(x) = Btc.
paramMaster.Btc   = paramMaster.Bt; % Critial Bt
if flags.BindSiteDistFlag ~= 0
  paramMaster.sigma  = paramMaster.alpha * paramMaster.Lbox ;
else
  flags.BtDepDiff = 0;
  paramMaster.sigma = 0;
end

% Boundary conditions: 'Dir', 'Vn', 'Res','PBC', 'Mx'
% 'Dir': Fixed Concenctration on left and right
% 'Vn': No flux on left and right
% 'Res': Reservoirs
% 'PBC': Periodic. Don't think this works
% 'Mx': Fixed Concenctration on left and no flux right
paramMaster.A_BC = 'Dir';
paramMaster.C_BC = 'Vn';
