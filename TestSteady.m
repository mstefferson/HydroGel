SaveMe = 0;
PlotMe = 1;
BCstr = 'DirVn'; % 'Dir','Vn','DirVn'

trial  = 1;
%Parameter you can edit

linearEqn = 0;
KDinv = 1e+04 ;
Koff  = 1e2;
Kon  = KDinv * Koff;
DA  = 1;
nu  = 1;
AL  = 2e-4;
AR  = 0;
Bt  = 2e-3;
NxPDE  = 128;
% NxODE  = (NxPDE-1) .* 10 + 1;
NxODE  = 1000;
Lbox = 1;
Paramstr = sprintf('Kon=%.1e\nKoff=%.1e\nnu=%.2e\n',...
    Kon,Koff,nu);
Concstr = sprintf('Bt=%.1e\nAL=%.1e\nAR=%.2e',...
    Bt,AL,AR);
Gridstr = sprintf('NxODE = %d\nNxPDE = %d',...
    NxODE,NxPDE);
%% Objects
% Put Parameters in a structure
ParamObj   = struct('trial',trial,'saveMe',saveMe,...
    'NxODE',NxODE,'NxPDE',NxPDE,'Lbox',Lbox,...
    'BCstr',BCstr,...
    'Kon', Kon, 'Koff', Koff,'KDinv',Kon/Koff,...
    'nu',nu,'Bt',Bt,'AL',AL,'AR',AR);
if SaveMe
    diary('RunDiary.txt')
    disp(ParamObj)
end

%%%%%%%% MATLAB'S ODE SOLVER%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% non-linear
[AnlOde,CnlOde,xOde] = RdSsSolverMatBvFunc(...
    Kon,Koff,nu,AL,AR,Bt,Lbox,BCstr,NxODE,linearEqn);
fprintf('MATLAB method done\n');

% "Analysis" subroutines
AnalysisObj.QuickMovie             = 0;  % Time evolv. Movie
AnalysisObj.TrackAccumFromFlux     = 1;  % Track the flux into outlet
AnalysisObj.TrackAccumFromFluxPlot = 0;  % Plot flux vs time
AnalysisObj.PlotMeLastConc         = 0;  % Concentration at end time
AnalysisObj.PlotMeAccum            = 0;  % Concentration at Outlet vs time
AnalysisObj.PlotMeWaveFrontAccum   = 0;  % Wavefront and accum
AnalysisObj.PlotMeLastConcAccum    = 0;  % Conc at end time and accum
AnalysisObj.CheckConservDen        = 0;  % Check if density is conserved
AnalysisObj.ShowRunTime            = 0;  % Display run time

%Spatial grid
ParamObj.Lbox  = 1; % Gel length
Nx    = NxPDE;  % Internal gridpoints
ParamObj.Nx    = floor(Nx*ParamObj.Lbox); % Scale by box. Careful!!!
ParamObj.Lr = 10; % Reservoir length if there is one

%Non Dimensional and Concentration
ParamObj.KDinv = KDinv; % Binding affinity
ParamObj.Koff  = Koff; % scaled koff
ParamObj.Kon   = ParamObj.KDinv * ParamObj.Koff;  % scaled kon
ParamObj.Da    = DA; % Diffusion of species A (unbound)
ParamObj.Dc    = nu; % Dc/Da
ParamObj.Dnl   = 1; % Dsat/DA. Only used for nonlinear diffusion beta  > 1?
ParamObj.Bt    = Bt;  % molar (old: 1e-2) (new: 1e-3)
ParamObj.AL    = AL;  % concentration of inlet
ParamObj.AR    = 0; % concentration of outlet

% Binding flag 0: constant. 1: Square blurr
ParamObj.BindSiteDistFlag = 0; % flag turn on spatially varying binding sites
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
tfac        = 4;
dtfac       = 0.1;
dt          = dtfac *(ParamObj.Lbox/(ParamObj.Nx))^2; % time step
t_tot       = tfac * ParamObj.Lbox^2 /  ParamObj.Da;  % total time
t_rec       = t_tot / 100;  % time interval for recording dynamics
ss_epsilon  = 1e-12;  % steady state condition
NumPlots    = 10; % For the accumulation plot subroutine

% Turn things on
ParamObj.SaveMe = SaveMe;
ParamObj.NLcoup        = 1;
ParamObj.ChemOnEndPts  = 1;
ParamObj.A_BC = 'Dir';
ParamObj.C_BC = 'Vn';

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
[Apde,Cpde,DidIBreak,SteadyState] = ChemDiffMain(ParamObj,TimeObj,AnalysisObj);
fprintf('Finished run\n')
xPde = linspace( 0, Lbox, Nx );
% xOde = linspace( 0, Lbox, NxODE );

% Find how closen we got to steady state
% Pde

figure()
plot(xPde, Apde, xPde, Cpde);
hold all
plot(xOde, AnlOde, '--',xOde, CnlOde,'--');

% Flux out
jOde = - DA * (AnlOde(end) - AnlOde(end-1) ) / ( xOde(2) - xOde(1) );
jPde = - DA * (Apde(end) - Apde(end-1) ) / ( xPde(2) - xPde(1) );

fprintf('\njOde = %g jPde = %g\n', jOde, jPde);

legend('A pde','C pde','A ode','C ode','location', 'best')
%
