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
AnalysisObj.QuickMovie=0; AnalysisObj.TrackAccumFromFlux= 1;
AnalysisObj.TrackAccumFromFluxPlot=0; AnalysisObj.PlotMeLastConc=0;
AnalysisObj.PlotMeAccum=0; AnalysisObj.PlotMeWaveFrontAccum=0;
AnalysisObj.PlotMeLastConcAccum=0; AnalysisObj.CheckConservDen=0;
AnalysisObj.ShowRunTime=0;

% Set saveme to 0, don't need recs
ParamObj.SaveMe = 0;

% Build TimeObj
dt = dt * dt_fac;
[TimeObj] = TimeObjMakerRD(dt,t_tot,t_rec,ss_epsilon,NumPlots);
dtSave = TimeObj.dt;

% Display everything
fprintf('trial:%d A_BC: %s C_BC: %s\n', ...
  ParamObj.trial,ParamObj.A_BC, ParamObj.C_BC)
disp(ParamObj); disp(AnalysisObj); disp(TimeObj);

% Edits here. Change params and loop over
FluxVsT = zeros( length(nuVec), length(KonBtVec) , length(KoffVec), TimeObj.N_rec );
AccumVsT = zeros( length(nuVec), length(KonBtVec) , length(KoffVec), TimeObj.N_rec );

% Store steady state solutions;
AconcStdy = zeros( length( nuVec ), length(KonBtVec), length( KoffVec ), Nx );
CconcStdy = zeros( length( nuVec ), length(KonBtVec), length( KoffVec ), Nx );

% Run Diff first
Koff = 0;
Kon = 0;
dt = dtSave;

pVec(1) = 0;
pVec(2) = 0;
pVec(3) = ParamObj.Bt;
pVec(4) = 0;

[RecObj] = ChemDiffMain('', ParamObj,TimeObj,AnalysisObj, pVec );
FluxVsTDiff = RecObj.Flux2ResR_rec;
AccumVsTDiff = RecObj.FluxAccum_rec;

% Hold Bt Steady
Bt = ParamObj.Bt;

for ii = 1:length(nuVec)
  ParamObj.Dc  = nuVec(ii);
  nu = ParamObj.Dc;
  fprintf('\n\n Starting nu = %g \n\n', ParamObj.Dc );
  for jj = 1:length(KonBtVec)
    Kon = KonBtVec(jj) / ParamObj.Bt;
    pVec(1) = Kon;
    fprintf('\n\n Starting Kon Bt = %f \n\n', KonBtVec(jj) );
    parfor kk = 1:length(KoffVec)
      Koff = KoffVec(kk);    
      fprintf( 'Koff = %f Kon = %f\n',Koff,Kon );
      [RecObj] = ...
        ChemDiffMain('',ParamObj,TimeObj,AnalysisObj, [Kon Koff Bt nu]);   
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
  findFluxProperties( FluxVsT, AccumVsT, TimeObj, ...
  length(nuVec), length(KonBtVec), length(KoffVec) );

%% Plotting stuff
% flux vs time
if plotVstFlag
  TimeVec = (0:TimeObj.N_rec-1) * t_rec;
  ah1titl = 'k_{on} * Bt = ';
  ah2titl = 'Dc/Da = ';
  fluxAccumVsTimePlotMultParams( ...
    FluxVsT, AccumVsT, FluxVsTDiff, AccumVsTDiff, TimeVec, ...
    nuVec, KonBtVec, KoffVec, 'k_{off}', ah1titl, ah2titl, saveMe, saveStrVsT )
end

% steady state solutions
if plotSteadyFlag
  x = linspace( 0, ParamObj.Lbox, ParamObj.Nx );
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

