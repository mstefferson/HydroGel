%  Parameter file
paramMaster.trial  = 1; % trial ID
% Turn things on
flags.SaveMe = 1; % Save runHydrogel outputs
flags.NLcoup = 1; % Turn on/off the nonlinear term AC
flags.ChemOnEndPts = 1; % Have chemistry on the endpoints
flags.BoundTetherDiff = 0; % Use the bound spring tether approx
flags.BindSiteDistFlag = 0; % flag turn on spatially varying binding sites
flags.BtDepDiff = 0;  % Turn on if diffusion depends on Bt.
flags.BreakAtSteady = 0; % Save runHydrogel outputs
flags.ParforFlag = 1; % Turn on/off Parfor

% "Analysis" subroutines
analysisFlags.QuickMovie             = 0;  % Time evolv. Movie
analysisFlags.TrackAccumFlux         = 1;  % Track the flux into outlet
analysisFlags.PlotAccumFlux          = 1;  % Plot flux vs time
analysisFlags.PlotMeLastConc         = 1;  % Concentration at end time
analysisFlags.PlotMeAccum            = 0;  % Concentration at Outlet vs time
analysisFlags.PlotMeWaveFrontAccum   = 0;  % Wavefront and accum
analysisFlags.PlotMeLastConcAccum    = 0;  % Conc at end time and accum
analysisFlags.CheckConservDen        = 0;  % Check if density is conserved
analysisFlags.ShowRunTime            = 1;  % Display run time
analysisFlags.TrackProgress          = 1;  % Track run progress

%Spatial grid
paramMaster.Lbox  = 1; % Gel length
Nx    = 128;  % Internal gridpoints
paramMaster.Nx    = floor(Nx*paramMaster.Lbox); % Scale by box. Careful!!!
paramMaster.Lr = 10; % Reservoir length if there is one

%Non Dimensional and Concentration. Code will only vary 2/3 of kinetic parameters
% konBt, koff, Ka
paramMaster.Da     = 1; % Diffusion of species A (unbound). Sets time scale
paramMaster.nu     = [1]; % vec Dc/Da aka nu 
% Varying only 2 of konbt, koff, Ka. Leave third blank []. e.g.
saturatedFlag = 1;
betaTest = 1;
% saturated
if saturatedFlag
  paramMaster.KonBt  = [1e1];  % vec konBt (time scale)
  paramMaster.Koff   = []; % vec koff (time scale)
  paramMaster.Ka   = [1e8]; % vec binding affinity (time scale) 
% unsaturated
else
  paramMaster.KonBt  = [1e1];  % vec konBt (time scale)
  paramMaster.Koff   = []; % vec koff (time scale)
  paramMaster.Ka   = [1e5]; % vec binding affinity (time scale) 
end
if betaTest
  paramMaster.KonBt  = [1e1 1e2 1e3 1e4 1e5];  % vec konBt (time scale)
  paramMaster.Koff   = []; % vec koff (time scale)
  paramMaster.Ka   = [1e4 1e5 1e6 1e7 1e8]; % vec binding affinity (time scale) 
end
paramMaster.Bt     = [2e-5];  % vec molar (old: 1e-2) (new: 1e-3)
paramMaster.Llp    = 1e-2; % Tether length x persistence length
paramMaster.Dnl    = 1; % Dsat/DA. Dnl = 1: (constant D); Dnl > 1 : D([A])
paramMaster.AL     = 1e-6;  % concentration of inlet
paramMaster.AR     = 0; % concentration of outlet

% time
tfac        = 1; % run time factor in relation to box diffusion time
dtfac       = 1; % dt factor in relation to VN stability condition
dt          = dtfac * ( (paramMaster.Lbox/paramMaster.Nx)^2 / paramMaster.Da ); % time step
t_tot       = tfac * paramMaster.Lbox^2 /  paramMaster.Da;  % total time
t_rec       = t_tot / 100;  % time interval for recording dynamics
ss_epsilon  = 1e-6;  % steady state condition
NumPlots    = 10; % For the accumulation plot subroutine

% koff vary
% {'const'}  or {}
% {'outletboundary', multVal}
koffVary = {'outletboundary', 2};

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
