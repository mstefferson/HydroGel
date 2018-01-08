%  Parameter file
paramMaster.trial  = 1; % trial ID
% Turn things on
flags.SaveMe = 1; % Save runHydrogel outputs
flags.NLcoup = 1; % Turn on/off the nonlinear term AC
flags.ChemOnEndPts = 1; % Have chemistry on the endpoints
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
paramMaster.Nx = 12800; % number of grid points
paramMaster.Lr = 10; % Reservoir length if there is one
% diffusion coefficient
paramMaster.Da = 1; % Diffusion of species A (unbound). Sets time scale
% bound diffusion, either {'nu',[]},{'lplc',[]}
% nu: actual value, lplc: bound tethered model
paramMaster.DbParam     = {'nu', 1}; 
% concentrations
paramMaster.AL = 1e-6;  % concentration of inlet
paramMaster.AR = 0; % concentration of outlet
paramMaster.Bt = [1e-3];  % vec molar (old: 1e-2) (new: 1e-3)
% Varying two kinetic parameters. First cell, name (str). Second, vector of values
% options: {'konBt',[...]}, {'koff',[...]}, {'kD',[...]}, {'kA',[...]}
kon = [1e9]; % if you want to change just kon, and not konBt, do it here
konBt = buildKonBt( paramMaster.Bt, kon );
% Varying only 2 of konbt, koff, Ka. Leave third blank []. e.g.
paramMaster.kinParam1 = {'konBt', [konBt]};  % vec konBt (time scale)
paramMaster.kinParam2 = {'kA', []};
paramMaster.Dnl = 1; % Dsat/DA. Dnl = 1: (constant D); Dnl > 1 : D([A])

% time
tfac = 1; % run time factor in relation to box diffusion time
dtfac = 1; % dt factor in relation to VN stability condition
timeMaster.dt = dtfac * ( (paramMaster.Lbox/paramMaster.Nx)^2 / paramMaster.Da ); % time step
timeMaster.t_tot = tfac * paramMaster.Lbox^2 /  paramMaster.Da;  % total time
timeMaster.t_rec = timeMaster.t_tot / 100;  % time interval for recording dynamics
timeMaster.ss_epsilon = 1e-6;  % steady state condition
timeMaster.NumPlots = 10; % For the accumulation plot subroutine

% koff vary
% {'const'}  or {}
% {'outletboundary', multVal}
koffVary = {};
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

function konBt = buildKonBt( kon, bt )
if isempty(kon)
  konBt = [];
else
  konBt = reshape( bt' * kon, [1 length(kon) * length( bt ) ] );
end
end
