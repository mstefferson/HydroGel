% fluxPDE solves the time evolution of the reaction diffusion equation
% for various parameter configurations by solving the PDE 
% It saves steady state solutions, makes plots, and has temporal info for the
% flux. Loops over nu, KonBt, Koff.
%
% fluxPDE( plotVstFlag, plotSteadyFlag, plotmapMaxFlag, ...
%  plotmapSlopeFlag, plotmapTimeFlag, saveMe, dirname ) 
% 
% Inputs:
% plotVstFlag: plot j vs t for various koff and konbt
% plotSteadyFlag: plot concentration profiles
% plotmapMaxFlag: surface plot jmax vs koff and konbt
% plotmapSlopeFlag: surface plot of dj/dt at jmax/2 vs koff and konbt
% plotmapTimeFlag: surface plot of time until jmax/2 vs koff and konbt
% saveMe: save plots and outputs
% dirname: directory name for saving
% Outputs:
% jMax: matrix of steady state flux vs koff and konbt
% djdtHm: matrix of dj/dt at jmax/2 vs koff and konbt
% tHm: matrix of time until jmax/2 vs koff and konbt
% AconcStdy: matrix of A steady state profile vs koff and konbt
% CconcStdy: matrix of C steady state profile vs koff and konbt
% params: parameters of runs
function [jMax, djdtHm, tHm, ...
    AconcStdy, CconcStdy, params] = ....
    fluxPDE( plotVstFlag, plotSteadyFlag, plotmapMaxFlag, ...
    plotmapSlopeFlag, plotmapTimeFlag, saveMe, dirname ) 
% Latex font
set(0,'defaulttextinterpreter','latex')
% Make up a dirname if one wasn't given
if nargin < 6
  if saveMe == 1
    dirname = ['fluxPDE_' num2str( randi( 100 ) )];
  else
    dirname = ['tempFluxPDE_' num2str( randi( 100 ) ) ];
  end
end
% Add paths and output dir 
addpath( genpath('./src') )
addpath( genpath('./src') );
if ~exist('./steadyfiles','dir'); mkdir('steadyfiles'); end;
if ~exist('./steadyfiles/PDE','dir'); mkdir('steadyfiles/PDE'); end;
% Prting start time
Time = datestr(now);
fprintf('Starting fluxPDE: %s\n', Time)
% Initparams
fprintf('Initiating parameters\n');
if exist( 'initParams.m','file')
  initParams;
else
  cpParams
  initParams
end
% Copy master parameters input object
paramObj = paramMaster;
timeObj = timeMaster;
flagsObj = flags;
boundTetherDiff = flags.BoundTetherDiff;
% Looped over parameters
% p1 either nu or Llp
if boundTetherDiff 
  p1name = '$$ Ll_p $$';
  p1Vec = paramObj.Llp;
else
  p1name = '$$ \nu $$';
  p1Vec = paramObj.nu;
end
numP1 = length(p1Vec);
numKonBt = length(paramObj.KonBt);
numKoff = length(paramObj.Koff);
KonBtVec = paramObj.KonBt; 
KoffVec = paramObj.Koff; 
% Store parameters just in case
params.nu = paramObj.nu;
params.Koff = KoffVec;
params.KonBt = KonBtVec;
params.Bt = paramObj.Bt;
params.nl = flags.NLcoup;
params.Llp = paramObj.Llp;
Da = paramObj.Da;
% Fix N if it's too high and make sure Bt isn't a vec 
if ( paramObj.Nx > 1000 ); paramObj.Nx = 128; end;
if length( paramObj.Bt ) > 1
  paramObj.Bt = paramObj.Bt(1);
end
% save string and some plot labels
saveStrVsT = 'flxvst'; %flux and accumulation vs time
saveStrFM = 'flxss'; %flux map
saveStrSS = 'profileSS'; % steady state
saveStrMat = 'FluxAtSS.mat'; % matlab files
if saveMe; dirname = [dirname '_nl' num2str( flagsObj.NLcoup )]; end;
if plotmapSlopeFlag || plotmapSlopeFlag || plotmapTimeFlag
  xlab = '$$ k_{off} $$';
  ylab = '$$ k_{on}B_{t} $$';
end
if plotSteadyFlag
    p2name = '$$ k_{on}B_{t} $$'; 
    p3name = '$$ k_{off} $$';
end
% "Analysis" subroutines
analysisFlags.QuickMovie=0; analysisFlags.TrackAccumFromFlux= 1;
analysisFlags.TrackAccumFromFluxPlot=0; analysisFlags.PlotMeLastConc=0;
analysisFlags.PlotMeAccum=0; analysisFlags.PlotMeWaveFrontAccum=0;
analysisFlags.PlotMeLastConcAccum=0; analysisFlags.CheckConservDen=0;
analysisFlags.ShowRunTime=0;
% Set saveme to 0, don't need recs
flagsObj.SaveMe = 0;
% Display everything
fprintf('trial:%d A_BC: %s C_BC: %s\n', ...
  paramObj.trial,paramObj.A_BC, paramObj.C_BC)
disp(paramObj); disp(analysisFlags); disp(timeObj);
% Edits here. Change params and loop over
FluxVsT = zeros( numP1, numKonBt, numKoff, timeObj.N_rec );
AccumVsT = zeros( numP1, numKonBt, numKoff, timeObj.N_rec );
% Store steady state solutions;
AconcStdy = zeros( numP1, numKonBt, numKoff, Nx );
CconcStdy = zeros( numP1, numKonBt, numKoff, Nx );
% Run Diff first
pVec =[0 0 0 0];
[RecObj] = ChemDiffMain('', paramObj, timeObj, flagsObj, analysisFlags, pVec );
FluxVsTDiff = RecObj.Flux2ResR_rec;
AccumVsTDiff = RecObj.FluxAccum_rec;
% Hold Bt Steady
Bt = paramObj.Bt;
for ii = 1:length(p1Vec)
  p1Temp = p1Vec(ii);
  fprintf('\n\n Starting p1 = %g \n\n', p1Temp );
  for jj = 1:length(KonBtVec)
    Kon = KonBtVec(jj) / paramObj.Bt;
    fprintf('\n\n Starting Kon Bt = %f \n\n', KonBtVec(jj) );
    parfor kk = 1:length(KoffVec)
      Koff = KoffVec(kk);    
      fprintf( 'Koff = %f Kon = %f\n',Koff,Kon );
      [RecObj] = ...
        ChemDiffMain('', paramObj, timeObj, flagsObj, analysisFlags, [p1Temp Kon Koff Bt]);   
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
[jMax, ~, djdtHm, tHm] = ...
  findFluxProperties( FluxVsT, AccumVsT, timeObj, ...
  length(p1Vec), length(KonBtVec), length(KoffVec) );
%% Plotting stuff
% flux vs time
if plotVstFlag
  TimeVec = (0:timeObj.N_rec-1) * t_rec;
  ah1titl = '$$ k_{on} B_t  = $$' ;
  ah2titl = [ p1name '=' ] ;
  fluxAccumVsTimePlotMultParams( ...
    FluxVsT, AccumVsT, FluxVsTDiff, AccumVsTDiff, TimeVec, ...
    p1Vec, KonBtVec, KoffVec, '$$k_{off}$$', ah1titl, ah2titl, saveMe, saveStrVsT )
end
% steady state solutions
if plotSteadyFlag
  x = linspace( 0, paramObj.Lbox, paramObj.Nx );
  concSteadyPlotMultParams( AconcStdy, CconcStdy, x, ...
    p1Vec, KonBtVec, KoffVec, p1name, p2name, p3name, ...
    saveMe, saveStrSS  )
end
% Surface plot: max flux
if plotmapMaxFlag
  titleSort = '$$ j_{max} $$; ';
  titstr = [ titleSort p1name ' = '] ;
  surfLoopPlotter( jMax, p1Vec, KonBtVec, KoffVec, ...
    xlab, ylab,  titstr, saveMe, saveStrFM)
end
% Surface plot: flux slope
if plotmapSlopeFlag
  titleSort = 'Slope, $$ \frac{dj}{dt} $$, at Half Max Flux; ';
  titstr = [ titleSort p1name ' = '] ;
  saveStr = [saveStrFM '_slopeHm'];
  surfLoopPlotter( djdtHm, p1Vec, KonBtVec, KoffVec, ...
    xlab, ylab,  titstr, saveMe, saveStr)
end
% Surface plot: time to flux
if plotmapTimeFlag 
  titleSort = 'Time at Half Max Flux; ';
  titstr = [ titleSort p1name ' = '] ;
  saveStr = [saveStrFM '_tHm'];
  surfLoopPlotter( tHm, p1Vec, KonBtVec, KoffVec, ...
    xlab, ylab,  titstr, saveMe, saveStr)
end
% Save
if saveMe
  save(saveStrMat, 'FluxVsT', 'jMax', 'djdtHm', 'tHm', ...
    'AconcStdy', 'CconcStdy', 'p1Vec', 'KonBtVec', 'KoffVec', 'TimeVec');
  % make dirs and move
    if plotSteadyFlag || plotMapFlag
      movefile('*.fig', dirname);
      movefile('*.jpg', dirname);
    end
    movefile(saveStrMat, dirname);
    movefile(dirname, './steadyfiles/PDE' )
end
% Print times
Time = datestr(now);
fprintf('Finished fluxPDE: %s\n', Time)
