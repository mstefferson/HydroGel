% LoopParamsFlux
%
% Loops over parameter Kon*Bt (Bt fixed) and KoffVec
% and calculates the max flux, slope, and time to half max
% Add paths and output dir 
addpath( genpath('./src') )
addpath( genpath('./src') );
if ~exist('./steadyfiles','dir'); mkdir('steadyfiles'); end;
if ~exist('./steadyfiles/PDE','dir'); mkdir('steadyfiles/PDE'); end;

Time = datestr(now);
fprintf('Starting fluxPDE: %s\n', Time)

% flags
saveMe     = 1;
plotVstFlag = 1;
plotSteadyFlag = 1;
plotmapMaxFlag = 1;
plotmapSlopeFlag = 1;
plotmapTimeFlag = 1;

% save string and some plot labels
saveStrVsT = 'flxvst'; %flux and accumulation vs time
saveStrFM = 'flxss'; %flux map
saveStrSS = 'profileSS'; % steady state
saveStrMat = 'FluxAtSS.mat'; % matlab files
dirname = 'temp'; % save dir

if plotmapSlopeFlag || plotmapSlopeFlag || plotmapTimeFlag
  xlab = 'k_{off} \tau';
  ylab = 'k_{on}B_{t} \tau';
end
if plotSteadyFlag
    p1name = '\nu'; 
    p2name = 'k_{on}B_{t}'; 
    p3name = 'k_{off}';
end

nuVec       = [0 1 10];
KonBtVec    = [ logspace(1,3,2) ];
KoffVec     = [  logspace(1,3,2)  ];
dt_fac   = 0.5;

% Initparams
fprintf('Initiating parameters\n');
if exist( 'initParams.m','file');
  initParams;
else
  cpParams
  initParams
end

% "Analysis" subroutines
analysisFlags.QuickMovie=0; analysisFlags.TrackAccumFromFlux= 1;
analysisFlags.TrackAccumFromFluxPlot=0; analysisFlags.PlotMeLastConc=0;
analysisFlags.PlotMeAccum=0; analysisFlags.PlotMeWaveFrontAccum=0;
analysisFlags.PlotMeLastConcAccum=0; analysisFlags.CheckConservDen=0;
analysisFlags.ShowRunTime=0;

% Set saveme to 0, don't need recs
flags.SaveMe = 0;

% Build timeObj
dt = dt * dt_fac;
[timeObj] = TimeObjMakerRD(dt,t_tot,t_rec,ss_epsilon,NumPlots);
dtSave = timeObj.dt;

% Display everything
fprintf('trial:%d A_BC: %s C_BC: %s\n', ...
  paramObj.trial,paramObj.A_BC, paramObj.C_BC)
disp(paramObj); disp(analysisFlags); disp(timeObj);

% Edits here. Change params and loop over
FluxVsT = zeros( length(nuVec), length(KonBtVec) , length(KoffVec), timeObj.N_rec );
AccumVsT = zeros( length(nuVec), length(KonBtVec) , length(KoffVec), timeObj.N_rec );

% Store steady state solutions;
AconcStdy = zeros( length( nuVec ), length(KonBtVec), length( KoffVec ), Nx );
CconcStdy = zeros( length( nuVec ), length(KonBtVec), length( KoffVec ), Nx );

% Run Diff first
Koff = 0;
Kon = 0;
dt = dtSave;

pVec(1) = 0;
pVec(2) = 0;
pVec(3) = paramObj.Bt;
pVec(4) = 0;

[RecObj] = ChemDiffMain('', paramObj,timeObj,analysisFlags, pVec );
FluxVsTDiff = RecObj.Flux2ResR_rec;
AccumVsTDiff = RecObj.FluxAccum_rec;

% Hold Bt Steady
Bt = paramObj.Bt;

for ii = 1:length(nuVec)
  paramObj.Dc  = nuVec(ii);
  nu = paramObj.Dc;
  fprintf('\n\n Starting nu = %g \n\n', paramObj.Dc );
  for jj = 1:length(KonBtVec)
    Kon = KonBtVec(jj) / paramObj.Bt;
    pVec(1) = Kon;
    fprintf('\n\n Starting Kon Bt = %f \n\n', KonBtVec(jj) );
    parfor kk = 1:length(KoffVec)
      Koff = KoffVec(kk);    
      fprintf( 'Koff = %f Kon = %f\n',Koff,Kon );
      [RecObj] = ...
        ChemDiffMain('',paramObj,timeObj,analysisFlags, [Kon Koff Bt nu]);   
      if RecObj.DidIBreak == 1 || RecObj.SteadyState == 0
        fprintf('B = %d S = %d\n',RecObj.DidIBreak,RecObj.SteadyState)
      end
      
      % record
      AconcStdy(ii,jj,kk,:) = RecObj.Afinal;
      CconcStdy(ii,jj,kk,:) = RecObj.Cfinal;
      FluxVsT(ii,jj,kk,:) = RecObj.Flux2ResR_rec;
      AccumVsT(ii,jj,kk,:) = RecObj.FluxAccum_rec;
    end
  end
end

% Find Maxes and such
[jMax, aMax, djdtHm, tHm] = ...
  findFluxProperties( FluxVsT, AccumVsT, timeObj, ...
  length(nuVec), length(KonBtVec), length(KoffVec) );

%% Plotting stuff
% flux vs time
if plotVstFlag
  TimeVec = (0:timeObj.N_rec-1) * t_rec;
  ah1titl = 'k_{on} * Bt = ';
  ah2titl = 'Dc/Da = ';
  fluxAccumVsTimePlotMultParams( ...
    FluxVsT, AccumVsT, FluxVsTDiff, AccumVsTDiff, TimeVec, ...
    nuVec, KonBtVec, KoffVec, 'k_{off}', ah1titl, ah2titl, saveMe, saveStrVsT )
end

% steady state solutions
if plotSteadyFlag
  x = linspace( 0, paramObj.Lbox, paramObj.Nx );
  concSteadyPlotMultParams( AconcStdy, CconcStdy, x, ...
    nuVec, KonBtVec, KoffVec, p1name, p2name, p3name, ...
    saveMe, saveStrSS  )
end

% Surface plot: max flux
if plotmapMaxFlag
  titstr = 'Max Flux nu = ';
  fluxSurfPlotter( jMax, nuVec, KoffVec, KonBtVec,...
    xlab, ylab,  titstr, saveMe, saveStrFM)
end

% Surface plot: flux slope
if plotmapSlopeFlag
  titstr = 'Slope, dj/dt, at Half Max Flux nu = ';
  saveStr = [saveStrFM '_slopeHm'];
  fluxSurfPlotter( djdtHm, nuVec, KoffVec, KonBtVec,...
    xlab, ylab,  titstr, saveMe, saveStr)
end

% Surface plot: time to flux
if plotmapTimeFlag 
  titstr = 'Time at Half Max Flux nu = ';
  saveStr = [saveStrFM '_tHm'];
  fluxSurfPlotter( tHm, nuVec, KoffVec, KonBtVec,...
    xlab, ylab,  titstr, saveMe, saveStr)
end

if saveMe
  save(saveStrMat, 'FluxVsT', 'jMax', 'djdtHm', 'tHm', ...
    'AconcStdy', 'CconcStdy', 'nuVec', 'KonBtVec', 'KoffVec', 'TimeVec');
  % make dirs and move
    if plotSteadyFlag || plotMapFlag
      movefile('*.fig', dirname);
      movefile('*.jpg', dirname);
    end
    movefile(saveStrMat, dirname);
    movefile(dirname, './steadyfiles/PDE' )
end

Time = datestr(now);
fprintf('Finished fluxPDE: %s\n', Time)

