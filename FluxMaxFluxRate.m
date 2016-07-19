% Find the flux at steady state for various parameter configurations
% Loops over KDinv, koff, nu

save_me = 1;

% Looped parameters
% Kon calculated in loop
nuVec  = [0 1];
% KDinvVec = [0 1e2 1e3 1e4 1e5 ];
% KoffVec = [ 1e-1 1e0 1e1 1e2 1e3 ];
% KDinvVec = [0 logspace(3,4,2) ];
% KoffVec = [ logspace(1,2,2) ];
KDinvVec = [0 logspace(3,4.5,2) ];
KoffVec = [ logspace(1,4,2) ];

% Non-loopable parameters
linearEqn = 0;
dt_fac = 0.2;
t_fac   = 4;
BCstr = 'DirVn'; % 'Dir','Vn','DirVn'
Da  = 1;
AL  = 2e-4;
AR  = 0;
Bt  = 2e-3;
NxODE  = 1000;
Lbox = 1;

% Add paths and see where we are
addpath('./Subroutines');
if ~exist('./Outputs','dir'); mkdir('Outputs'); end;
Time = datestr(now);
currentdir=pwd;
fprintf('In dir %s\n',currentdir);

fprintf('Starting Flux Loop: %s\n', Time)

% Initparams
fprintf('Initiating parameters\n');
if exist( 'InitParams.m','file');
  InitParams;
else
  cpParams
  InitParams
end

% Reset Parameters
ParamObj.Da = Da; ParamObj.AL = AL; ParamObj.AR = AR;
ParamObj.Bt = Bt; ParamObj.Lbox = Lbox;

% "Analysis" subroutines
AnalysisObj.QuickMovie=0; AnalysisObj.TrackAccumFromFlux= 1;
AnalysisObj.TrackAccumFromFluxPlot=0; AnalysisObj.PlotMeLastConc=0;
AnalysisObj.PlotMeAccum=0; AnalysisObj.PlotMeWaveFrontAccum=0;
AnalysisObj.PlotMeLastConcAccum=0; AnalysisObj.CheckConservDen=0;
AnalysisObj.ShowRunTime=0;

% Build TimeObj
t_tot = t_tot * t_fac;
dtSave = dt;
[TimeObj] = TimeObjMakerRD(dt,t_tot,t_rec,ss_epsilon,NumPlots);

% Flux matrix
fluxSsRec = zeros( length( nuVec ), length(KDinvVec), length( KoffVec ) );
% dj/dt at j =  j_steady / 2
fluxSlopeHmRec = zeros( length( nuVec ), length(KDinvVec), length( KoffVec ) );
% time at j =  j_steady / 2
fluxTimeHmRec = zeros( length( nuVec ), length(KDinvVec), length( KoffVec ) );

% Calculated things
x = linspace(0, Lbox, NxODE) ;
dx  = x(2) - x(1);

% Run the Steady Stateloops
for i = 1:length(nuVec)
  nu = nuVec(i);
  ParamObj.Dc    = nu; % Dc/Da
  if nu == 0
    x = linspace(0, Lbox, NxODE) ;
    dx = x(2) - x(1);
    AnlOde = (AR - AL) * x / Lbox + AL;
    CnlOde = zeros(1,NxODE);
    fluxSs  = - Da * ( AnlOde(end) - AnlOde(end-1) ) / dx;
    fluxSsRec( i, :, : ) = fluxSs;
  else
    for j = 1:length(KDinvVec)
      KDinv = KDinvVec(j);
      if KDinv == 0
        x = linspace(0, Lbox, NxODE) ;
        dx = x(2) - x(1);
        AnlOde = (AR - AL) * x / Lbox + AL;
        CnlOde = zeros(1,NxODE);
        fluxSs = - Da * ( AnlOde(end) - AnlOde(end-1) ) / dx;
        fluxSsRec( i, j, : ) = fluxSs;
      else
        parfor k = 1:length(KoffVec)
          Koff = KoffVec(k);
          Kon  = Koff * KDinv;
          
          [AnlOde,CnlOde,x] = RdSsSolverMatBvFunc(...
            Kon,Koff,nu,AL,AR,Bt,Lbox,BCstr,NxODE,linearEqn);
          dx = x(2) - x(1);
          fluxSs  = - Da * ( AnlOde(end) - AnlOde(end-1) ) / dx;
          fluxSsRec( i, j, k ) = fluxSs;
        end % loop Koff
      end % Kdinv = 0
    end % loop Kdinv
  end % if nu == 0
end % loop nu
fprintf('Finished finding steady state\n');

% Run the Temporal loops
for i = 1:length(nuVec)
  nu = nuVec(i);
  ParamObj.Dc    = nu; % Dc/Da
  for j = 1:length(KDinvVec)
    KDinv = KDinvVec(j);
    if KDinv == 0
      fluxStop = fluxSsRec( i, j, 1 ) / 2;
      Koff = 0;
      Kon = 0;
      [A,C,DidIBreak,SteadyState,fluxTimeHm, fluxSlopeHm] = ...
        ChemDiffMainFluxBreak(ParamObj,TimeObj,AnalysisObj,fluxStop, Koff, Kon, dt);
      fluxTimeHmRec( i, j, : ) = fluxTimeHm;
      fluxSlopeHmRec( i, j, : ) = fluxSlopeHm;
    else
      parfor k = 1:length(KoffVec)
        Koff = KoffVec(k);
        Kon  = Koff * KDinv;
        fluxStop = fluxSsRec( i, j, k ) / 2;
        
        if Kon > 1e7
          dt = dtSave * dt_fac;
        else
          dt = dtSave;
        end
        
        [A,C,DidIBreak,SteadyState,fluxTimeHm, fluxSlopeHm] = ...
          ChemDiffMainFluxBreak(ParamObj,TimeObj,AnalysisObj,fluxStop, Koff, Kon, dt);
        
        if fluxTimeHm ~= 0
          fluxTimeHmRec( i, j, k ) = fluxTimeHm;
        else
          fprintf('(%d,%d,%d) KDinv = %g nu = %g Koff =%g\n', ...
            i,j,k,KDinv, nu, Koff);
          fprintf('Never made it!\n');
        end
        fluxSlopeHmRec( i, j, k ) = fluxSlopeHm;
      end % loop Koff
    end % Kdinv = 0
  end % loop Kdinv
end % loop nu

fprintf('Finished flux slope and time \n');
if save_me
  save('FluxMaxFluxRate.mat','fluxSlopeHmRec','fluxTimeHmRec','fluxSsRec',...
    'nuVec','KDinvVec','KoffVec');
end
%%% Surface plot
%if plotmap_flag

%for i = 1:length(nuVec)
%figure()

%% Flux
%imagesc( 1:length(KoffVec), 1:length(KDinvVec), ...
%reshape( fluxSSrec(i,:,:), [length(KDinvVec) length(KoffVec) ] ) );
%xlabel( 'Koff'); ylabel('KdInv');
%Ax = gca;
%Ax.YTick = 1:length(KDinvVec);
%Ax.YTickLabel = num2cell( KDinvVec );
%Ax.XTick = 1: 2: length(KoffVec) ;
%Ax.XTickLabel = num2cell( round (KoffVec (1:2:end) ) );
%titstr = sprintf( 'Max Flux nu = %g', nuVec(i) );
%title(titstr)
%colorbar
%axis square

%% Save stuff
%if save_me
%savefig( gcf, [savestr_fa  '_nu'...
%num2str( nuVec(i) ) '.fig'] );
%saveas( gcf, [ savestr_fa '_nu'...
%num2str( nuVec(i) ) ], 'jpg' );
%save('FluxAtSS.mat', fluxSSrec, nuVec, KDinvVec, KoffVec )
%end
%end
%end








