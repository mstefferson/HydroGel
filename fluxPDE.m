% fluxPDE solves the time evolution of the reaction diffusion equation
% for various parameter configurations by solving the PDE
% It saves steady state solutions, makes plots, and has temporal info for the
% flux. Loops over nu, KonBt, Koff.
%
% fluxPDE( plotVsT, plotSteady, plotMapFlux, ...
%  plotMapFluxSlope, plotMapFluxTime, saveMe, dirname )
%
% Inputs:
% plotFlag: structure of plot flags
% storeFlag: structure of store flags
% saveMe: save plots and outputs
% dirname: directory name for saving
% paramFile: initParam file
%
% plotFlag with fields
% plotFlag.plotVsT: plot j vs t for various koff and konbt
% plotFlag.plotSteady: plot concentration profiles
% plotFlag.plotMapFlux: surface plot jmax vs koff and konbt
% plotFlag.plotMapFluxSlope: surface plot of dj/dt at jmax/2 vs koff and konbt
% plotFlag.plotMapFluxTime: surface plot of time until jmax/2 vs koff and konbt
% 
% storeFlag with fields
% storeFlag.storeStdy: store steady state solution flag
% storeFlag.storeTimeDep: store flux time dependence
%
% Outputs: fluxSummary with fields
% jMax: matrix of steady state flux vs koff and konbt
% jNorm: jMax ./ jDiff
% djdtHm: matrix of dj/dt at jmax/2 vs koff and konbt
% tHm: matrix of time until jmax/2 vs koff and konbt
% AconcStdy: matrix of A steady state profile vs koff and konbt
% CconcStdy: matrix of C steady state profile vs koff and konbt
% params: parameters of runs
%
% example run
%
% plotFlag.plotMapFlux = 1;
% plotFlag.plotSteady = 1;
% plotFlag.plotVsT = 1;
% plotFlag.plotMapFluxSlope = 1;
% plotFlag.plotMapFluxTime = 1;
% storeFlag.storeStdy = 1;
% storeFlag.storeTimeDep = 1;
% saveMe = 1;
% dirname = 'blah';
%
% [fluxSummary] = fluxPDE( plotFlag, storeFlag, saveMe, dirname, paramFile );

function [fluxSummary] = fluxPDE( plotFlag, storeFlag, saveMe, dirname, paramFile )
% Latex font
set(0,'defaulttextinterpreter','latex')
% Make up a dirname if one wasn't given
totalInput = 5;
if nargin < totalInput-1
  if saveMe == 1
    dirname = ['fluxPDE_' num2str( randi( 100 ) )];
  else
    dirname = ['tempFluxPDE_' num2str( randi( 100 ) ) ];
  end
end
if nargin < totalInput
  paramFile = 'initParams.m';
end
% move input structure fields to variables
plotMapFlux  = plotFlag.plotMapFlux;
plotSteady = plotFlag.plotSteady;
plotVsT = plotFlag.plotVsT;
plotMapFluxSlope = plotFlag.plotMapFluxSlope;
plotMapFluxTime = plotFlag.plotMapFluxTime;
storeStdy = storeFlag.storeStdy;
storeTimeDep = storeFlag.storeTimeDep;
% can't plot steady if not storing
plotSteady = storeStdy * plotSteady;
plotVsT = storeTimeDep * plotVsT;
plotMapFluxSlope = storeTimeDep * plotMapFluxSlope;
plotMapFluxTime = storeTimeDep * plotMapFluxTime;
% fix flags
if plotMapFlux || plotMapFluxSlope || plotMapFluxTime
  plotMapFlag = 1;
  % set colormap
  randI = randi(100000);
  figure(randI)
  colormap( viridis );
  close(randI)
else
  plotMapFlag = 0;
end
% Add paths and output dir
addpath( genpath('./src') );
if ~exist('./steadyfiles','dir'); mkdir('steadyfiles'); end
if ~exist('./steadyfiles/PDE','dir'); mkdir('steadyfiles/PDE'); end
% print start time
Time = datestr(now);
fprintf('Starting fluxPDE: %s\n', Time)
% Initparams
fprintf('Initiating parameters\n');
if exist( paramFile,'file')
  fprintf('Init file: %s\n', paramFile);
  run( paramFile );
elseif exist( 'initParams.m', 'file')
  fprintf('Could not find init file: %s. Running initParams\n', ...
    paramFile);
  run( 'initParams.m');
else
  fprintf('Could not find init file: %s or initParams. Copying and running template\n', ...
    paramFile);
  cpParams
  initParams
end
% Copy master parameters input object
paramObj = paramMaster;
flagsObj = flags;
% Build timeObj
[timeObj] = TimeObjMakerRD(timeMaster.dt,timeMaster.t_tot,...
  timeMaster.t_rec,timeMaster.ss_epsilon);
% Fix N if it's too low and make sure Bt isn't a vec
if ( paramObj.Nx > 256 ); paramObj.Nx = 128; end
% Code can only handle one value of Bt currently
if length( paramObj.Bt ) > 1
  paramObj.Bt = paramObj.Bt(1);
end
% set-up params
pfixed = paramObj.Bt;
pfixedStr = '$$ B_t $$';
[paramObj, kinParams] = paramInputMaster( paramObj, koffVary );
% Run the loops
paramNuLlp  = kinParams.nuLlp;
paramKonBt  = kinParams.konBt;
paramKoffInds = kinParams.koffInds;
numRuns = kinParams.numRuns;
% save string and some plot labels
saveStrVsT = 'flxvst'; %flux and accumulation vs time
saveStrFM = 'flxss'; %flux map
saveStrSS = 'profileSS'; % steady state
saveStrMat = 'fluxSummary.mat'; % matlab files
if saveMe
  dirname = [dirname '_nl' num2str( flagsObj.NLcoup ) '/'];
  mkdir(dirname)
end
if plotMapFlux || plotMapFluxSlope || plotMapFluxTime
  xlab = kinParams.kinVar2strTex; % columns
  ylab = kinParams.kinVar1strTex;  % rows
end
if plotSteady || plotVsT
  p2name = kinParams.kinVar1strTex;
  p3name = kinParams.kinVar2strTex;
end
% "Analysis" subroutines
analysisFlags.QuickMovie=0; analysisFlags.TrackAccumFromFlux= 1;
analysisFlags.PlotAccumFlux=0; analysisFlags.PlotMeLastConc=0;
analysisFlags.PlotMeAccum=0; analysisFlags.PlotMeWaveFrontAccum=0;
analysisFlags.PlotMeLastConcAccum=0; analysisFlags.CheckConservDen=0;
analysisFlags.ShowRunTime=0;
% Commonly used parameters
Da = paramObj.Da; AL = paramObj.AL; AR = paramObj.AR;
Bt = paramObj.Bt; Nx = paramObj.Nx; Lbox = paramObj.Lbox;
% Set saveme to 0, don't need recs
flagsObj.SaveMe = 0;
% Display everything
fprintf('trial:%d A_BC: %s C_BC: %s\n', ...
  paramObj.trial,paramObj.A_BC, paramObj.C_BC)
disp(paramObj); disp(analysisFlags); disp(timeObj);
% Edits here. Change params and loop over
fluxEnd = zeros( numRuns, 1 );
FluxVsT = cell( numRuns, 1 );
AccumVsT = cell( numRuns, 1 );
AOutletVsT = cell( numRuns, 1 );
% Store steady state solutions;
AconcStdy = cell( numRuns, 1 );
CconcStdy = cell( numRuns, 1 );
aOutletVsT = cell( numRuns, 1 );
% Run Diff first
pVec =[0 0 0 1];
% always set dt scale to one for diffusion to prevent unnecessarily long runs
tfac        = 1;
dtfac       = 1;
dt = dtfac * ( (paramMaster.Lbox/paramMaster.Nx)^2 / paramMaster.Da );
t_tot   = tfac * paramMaster.Lbox^2 /  paramMaster.Da;
t_rec = t_tot / 100;
[timeObjDiff] = TimeObjMakerRD(dt,t_tot,t_rec,...
  timeObj.ss_epsilon);
[recObj] = ChemDiffMain('', paramObj, timeObjDiff, flagsObj, ...
  analysisFlags, pVec);
FluxVsTDiff = recObj.Flux2Res_rec;
AccumVsTDiff = recObj.FluxAccum_rec;
aOutletVsTDiff = recObj.A_rec(end,:);
% loop over runs
if numRuns > 1 && flags.ParforFlag
  recObj = 0;
  parobj = gcp;
  numWorkers = parobj.NumWorkers;
  fprintf('I have hired %d workers\n',parobj.NumWorkers);
else
  fprintf('Not using parfor\n')
  numWorkers = 0;
end
parfor (ii=1:numRuns, numWorkers)
  try
    % set params
    p1Temp = paramNuLlp(ii);
    KonBt  = paramKonBt(ii);
    Koff  = paramKoffInds(ii);
    [recObj] = ...
      ChemDiffMain('', paramObj, timeObj, flagsObj, ...
        analysisFlags, [p1Temp KonBt Koff Bt] );
    if recObj.DidIBreak == 1 || recObj.SteadyState == 0
      fprintf('B = %d S = %d\n',recObj.DidIBreak,recObj.SteadyState)
    end
    % record
    if storeStdy
      AconcStdy{ii} = recObj.Afinal;
      CconcStdy{ii} = recObj.Cfinal;
    else
      AconcStdy{ii} = 0;
      CconcStdy{ii} = 0;
    end
    % always store FluxMax
    fluxEnd(ii) = recObj.Flux2Res_rec(end);
    if storeTimeDep
      FluxVsT{ii} = recObj.Flux2Res_rec;
      AccumVsT{ii} = recObj.FluxAccum_rec;
      AOutletVsT{ii} = recObj.A_rec( end, : );
    else
      FluxVsT{ii} = 0;
      AccumVsT{ii} = 0;
      AOutletVsT{ii} = 0;
    end
    fprintf('Finished %d \n', ii );
  catch err
    fprintf('%s',err.getReport('extended') );
  end
end
% reshape to more intutive size---> Mat( p1, p2, p3, : )
numP1 = kinParams.numP1;
numP2 = kinParams.numP2;
numP3 = kinParams.numP3;
AconcStdy = reshape( AconcStdy, [numP1, numP2, numP3] );
CconcStdy = reshape( CconcStdy, [numP1, numP2, numP3] );
fluxEnd = reshape( fluxEnd, [numP1, numP2, numP3] );
FluxVsT = reshape( FluxVsT, [numP1, numP2, numP3] );
AccumVsT = reshape( AccumVsT, [numP1, numP2, numP3] );
aOutletVsT = reshape( aOutletVsT, [numP1, numP2, numP3] );
% time
TimeVec = (0:timeObj.N_rec-1) * timeObj.t_rec;
% Find Maxes and such
[jMax, ~, djdtHm, tHm] = ...
  findFluxProperties( fluxEnd, FluxVsT, AccumVsT, timeObj, ...
  length(kinParams.p1Vec), length(kinParams.kinVar1), length(kinParams.kinVar2) );
% Get norm
jDiff = Da * ( AL - AR ) / Lbox;
jNorm = jMax ./  jDiff;
% Plotting stuff
% flux vs time
if plotVsT
  plotBoth = 0;
  ah1titl = [kinParams.kinVar1strTex ' = ' ] ;
  ah2titl = [kinParams.p1nameTex ' = ' ] ;
  fluxAll2plot = FluxVsT;
  fluxDiff2plot = FluxVsTDiff;
  if plotBoth
    fluxAccumVsTimePlotMultParams( ...
      fluxAll2plot, AccumVsT, fluxDiff2plot, AccumVsTDiff, ...
      jDiff, TimeVec, ...
      kinParams.p1Vec, kinParams.kinVar1, kinParams.kinVar2, ...
      kinParams.p3nameTex, pfixed, pfixedStrTex, ...
      ah1titl, ah2titl, saveMe, saveStrVsT )
  else
    fluxVsTimePlotMultParams( ...
      fluxAll2plot ,fluxDiff2plot, jDiff, TimeVec, ...
      kinParams.p1Vec, kinParams.kinVar1, kinParams.kinVar2, ...
      kinParams.kinVar2strTex, pfixed, pfixedStr, ...
      ah1titl, ah2titl, saveMe, saveStrVsT )
    ylabel( ' $$ j / j_{diff, steady} $$' );
    xlabel( ' $$ t / \tau $$ ' );
  end
end
% steady state solutions
if plotSteady
  x = linspace( 0, Lbox, paramObj.Nx );
  concSteadyPlotMultParams( AconcStdy, CconcStdy, x, ...
    kinParams.p1Vec, kinParams.kinVar1, kinParams.kinVar2, ...
    kinParams.p1nameTex, kinParams.kinVar1strTex, kinParams.kinVar2strTex, ...
    pfixed, pfixedStr, saveMe, saveStrSS )
end
% Surface plot: max flux
if plotMapFlux
  titleShort = '$$ j_{max} / j_{diff} $$; ';
  titstr = [ titleShort kinParams.p1nameTex ' = '] ;
  surfLoopPlotter( jNorm, kinParams.p1Vec, kinParams.kinVar1, ...
    kinParams.kinVar2, xlab, ylab,  titstr, saveMe, saveStrFM)
end
% Surface plot: flux slope
if plotMapFluxSlope
  titleShort = 'Slope, $$ \frac{dj}{dt} $$, at Half Max Flux; ';
  titstr = [ titleShort kinParams.p1nameTex ' = '] ;
  saveStr = [saveStrFM '_slopeHm'];
  surfLoopPlotter( djdtHm, kinParams.p1Vec, ...
    kinParams.kinVar1, kinParams.kinVar2, ...
    xlab, ylab,  titstr, saveMe, saveStr)
end
% Surface plot: time to flux
if plotMapFluxTime
  titleShort = 'Time at Half Max Flux; ';
  titstr = [ titleShort kinParams.p1nameTex ' = '] ;
  saveStr = [saveStrFM '_tHm'];
  surfLoopPlotter( tHm, kinParams.p1Vec, kinParams.kinVar1, kinParams.kinVar2, ...
    xlab, ylab,  titstr, saveMe, saveStr)
end
% store everything
fluxSummary.jMax = jMax;
fluxSummary.jNorm = jNorm;
fluxSummary.djdtHm = djdtHm;
fluxSummary.tHm = tHm;
fluxSummary.aConcStdy = AconcStdy;
fluxSummary.cConcStdy = CconcStdy;
fluxSummary.jVsT = FluxVsT;
fluxSummary.jVsTDiff = FluxVsTDiff;
fluxSummary.jDiff = jDiff;
fluxSummary.aOutletVsTDiff = aOutletVsTDiff;
fluxSummary.aOutletVsT = aOutletVsT;
fluxSummary.paramObj = paramObj;
fluxSummary.kinParams = kinParams;
fluxSummary.timeVec = TimeVec;
% Save
if saveMe
  save(saveStrMat, 'fluxSummary');
  % make dirs and move
  if plotSteady || plotMapFlag
    movefile('*.fig', dirname);
    movefile('*.jpg', dirname);
  end
  movefile(saveStrMat, dirname);
  % dont overwrite directories
  where2SavePath = [ './steadyfiles/PDE/' dirname ];
  if exist(where2SavePath,'dir')
    fprintf('You are trying to rewrite data. Renaming \n')
    dirname = dirname(1:end-1);
    dirnameOld = dirname;
    dirname = [ datestr(now,'yyyymmdd') '_' dirname '_' num2str( randi(1000) ) ];
    movefile(dirnameOld, dirname);
  end
  movefile(dirname, './steadyfiles/PDE' )
end
% Print times
Time = datestr(now);
fprintf('Finished fluxPDE: %s\n', Time)
