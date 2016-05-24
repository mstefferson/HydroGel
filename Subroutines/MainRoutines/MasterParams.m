% Master Parameter template. Tracked by git. Don't edit unless 
% adding a parameter.

CurrentDir = pwd;
addpath( genpath( CurrentDir) );

ParamObj.trial  = 1;
ParamObj.SaveMe = 1;

% Turn things on
ParamObj.NLcoup        = 1;
ParamObj.ChemOnEndPts  = 1;


% "Analysis" subroutines
AnalysisObj.QuickMovie             = 1;  % Time evolv. Movie
AnalysisObj.TrackAccumFromFlux     = 1;  % Track the flux into outlet
AnalysisObj.TrackAccumFromFluxPlot = 1;  % Plot flux vs time
AnalysisObj.PlotMeLastConc         = 0;  % Concentration at end time
AnalysisObj.PlotMeAccum            = 0;  % Concentration at Outlet vs time
AnalysisObj.PlotMeWaveFrontAccum   = 0;  % Wavefront and accum
AnalysisObj.PlotMeLastConcAccum    = 0;  % Conc at end time and accum
AnalysisObj.CheckConservDen        = 0;  % Check if density is conserved
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



