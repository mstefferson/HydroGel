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
%
% Outputs: fluxSummary with fields
% jMax: matrix of steady state flux vs koff and konbt
% jNorm: jMax ./ jDiff
% djdtHm: matrix of dj/dt at jmax/2 vs koff and konbt
% tHm: matrix of time until jmax/2 vs koff and konbt
% AconcStdy: matrix of A steady state profile vs koff and konbt
% CconcStdy: matrix of C steady state profile vs koff and konbt
% params: parameters of runs

function [fluxSummary] = fluxPDE( plotVstFlag, plotSteadyFlag,...
  plotMapMaxFlag, plotMapSlopeFlag, plotMapTimeFlag, saveMe, ...
  dirname, paramFile)
% Latex font
set(0,'defaulttextinterpreter','latex')
% Make up a dirname if one wasn't given
if nargin <= 6
  if saveMe == 1
    dirname = ['fluxODE_' num2str( randi( 100 ) )];
  else
    dirname = ['tempFluxODE_' num2str( randi( 100 ) ) ];
  end
end
if nargin <= 7
  paramFile = 'initParams.m';
end
% fix flags
if plotMapMaxFlag || plotMapSlopeFlag || plotMapTimeFlag
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
elseif exists( 'initParams.m', file')
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
timeObj = timeMaster;
flagsObj = flags;
boundTetherDiff = flags.BoundTetherDiff;
% Looped over parameters
% p1 either nu or Llp
if boundTetherDiff
  p1nameTex = '$$ Ll_p $$';
  p1name = 'Llp ';
  p1Vec = paramObj.Llp;
else
  p1nameTex = '$$ \nu $$';
  p1name = 'nu ';
  p1Vec = paramObj.nu;
end
paramObj.nu = p1Vec;
paramObj.diffName = p1name;
paramObj.diffNameTex = p1nameTex;
numP1 = length(p1Vec);
% Fix N if it's too low and make sure Bt isn't a vec
if ( paramObj.Nx > 256 ); paramObj.Nx = 128; end
% Code can only handle one value of Bt currently
if length( paramObj.Bt ) > 1
  paramObj.Bt = paramObj.Bt(1);
end
% Get correct kinetic params
[~, kinParams] =  kineticParams( paramObj.KonBt, paramObj.Koff, paramObj.Ka, paramObj.Bt );
paramObj.KonBt = kinParams.konBt;
paramObj.Koff = kinParams.koff;
paramObj.Ka = kinParams.kA;
paramObj.Bt = kinParams.Bt;
paramObj.fixedVar = kinParams.fixedVar;
if strcmp( kinParams.fixedVar, 'kA')
  paramObj.kinVar1 = paramObj.KonBt;
  paramObj.kinVar1str = 'konBt';
  paramObj.kinVar1strTex = '$$ k_{on} B_t \tau $$';
  paramObj.kinVar2 = paramObj.Koff;
  paramObj.kinVar2str = 'koff';
  paramObj.kinVar2strTex = '$$ k_{off} \tau $$';
elseif strcmp( kinParams.fixedVar, 'koff')
  paramObj.kinVar1 = paramObj.KonBt;
  paramObj.kinVar1str = 'konBt';
  paramObj.kinVar1strTex = '$$ k_{on} B_t \tau $$';
  paramObj.kinVar2 = paramObj.Ka;
  paramObj.kinVar2str = 'Ka';
  paramObj.kinVar2strTex = '$$ K_A $$';
else % 'konBt'
  paramObj.kinVar1 = paramObj.Koff;
  paramObj.kinVar1strTex = '$$ k_{off} \tau $$';
  paramObj.kinVar1str = 'koff';
  paramObj.kinVar2 = paramObj.Ka;
  paramObj.kinVar2str = 'Ka';
  paramObj.kinVar2strTex = '$$ K_A $$';
end
numP2 = length( paramObj.kinVar1 );
numP3 = length( paramObj.kinVar2 );
% Make paramMat
fprintf('Building parameter mat \n');
[paramMat, numRuns] = MakeParamMat( paramObj, flagsObj );
fprintf('Executing %d runs \n\n', numRuns);
% Run the loops
paramNuLlp  = paramMat(1,:);
paramKonBt  = paramMat(2,:);
paramKoff = paramMat(3,:);
% save string and some plot labels
saveStrVsT = 'flxvst'; %flux and accumulation vs time
saveStrFM = 'flxss'; %flux map
saveStrSS = 'profileSS'; % steady state
saveStrMat = 'FluxAtSS.mat'; % matlab files
if saveMe
  dirname = [dirname '_nl' num2str( flagsObj.NLcoup ) '/'];
  mkdir(dirname)
end
if plotMapMaxFlag || plotMapSlopeFlag || plotMapTimeFlag
  xlab = paramObj.kinVar2strTex; % columns
  ylab = paramObj.kinVar1strTex;  % rows
end
if plotSteadyFlag || plotVstFlag
  pfixed = paramObj.Bt;
  pfixedStr = 'B_t';
  pfixedTex = '$$ B_t $$';
  p2name = paramObj.kinVar1strTex;
  p3name = paramObj.kinVar2strTex;
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
% you need to have koffVary show in script to work
koffVaryRun = koffVary;
% Edits here. Change params and loop over
FluxVsT = cell( numRuns, 1 );
AccumVsT = cell( numRuns, 1 );
% Store steady state solutions;
AconcStdy = zeros( numRuns, Nx );
CconcStdy = zeros( numRuns, Nx );
% Run Diff first
pVec =[0 0 0 0];
% always set dt scale to one to prevent unnecessarily long runs
dtfac       = 1;
dt          = dtfac *(paramObj.Lbox/(paramObj.Nx))^2; % time step
[timeObjDiff] = TimeObjMakerRD(dt,t_tot,t_rec,ss_epsilon,NumPlots);
[recObj] = ChemDiffMain('', paramObj, timeObjDiff, flagsObj, ...
  analysisFlags, pVec, koffVary );
FluxVsTDiff = recObj.Flux2Res_rec;
AccumVsTDiff = recObj.FluxAccum_rec;
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
    Koff  = paramKoff(ii);
    [recObj] = ...
      ChemDiffMain('', paramObj, timeObj, flagsObj, ...
      analysisFlags, [p1Temp KonBt Koff Bt], koffVaryRun);
    if recObj.DidIBreak == 1 || recObj.SteadyState == 0
      fprintf('B = %d S = %d\n',recObj.DidIBreak,recObj.SteadyState)
    end
    % record
    AconcStdy(ii,:) = recObj.Afinal;
    CconcStdy(ii,:) = recObj.Cfinal;
    FluxVsT{ii} = recObj.Flux2Res_rec;
    AccumVsT{ii} = recObj.FluxAccum_rec;
    fprintf('Finished %d \n', ii );
  catch err
    fprintf('%s',err.getReport('extended') );
  end
end
% reshape to more intutive size---> Mat( p1, p2, p3, : )
AconcStdy = reshape( AconcStdy, [numP1, numP2, numP3, Nx] );
CconcStdy = reshape( CconcStdy, [numP1, numP2, numP3, Nx] );
% keyboard
FluxVsT = reshape( FluxVsT, [numP1, numP2, numP3] );
AccumVsT = reshape( AccumVsT, [numP1, numP2, numP3] );
% time
TimeVec = (0:timeObj.N_rec-1) * t_rec;
% Find Maxes and such
[jMax, ~, djdtHm, tHm] = ...
  findFluxProperties( FluxVsT, AccumVsT, timeObj, ...
  length(p1Vec), length(paramObj.kinVar1), length(paramObj.kinVar2) );
% Get norm
jDiff = Da * ( AL - AR ) / Lbox;
jNorm = jMax ./  jDiff;
%% Plotting stuff
% flux vs time
if plotVstFlag
  plotBoth = 0;
  ah1titl = [paramObj.kinVar1strTex ' = ' ] ;
  ah2titl = [p1name ' = ' ] ;
  fluxAll2plot = FluxVsT;
  fluxDiff2plot = FluxVsTDiff;
  if plotBoth
    fluxAccumVsTimePlotMultParams( ...
      fluxAll2plot, AccumVsT, fluxDiff2plot, AccumVsTDiff, ...
      jDiff, TimeVec, ...
      p1Vec, paramObj.kinVar1, paramObj.kinVar2, ...
      p3name, pfixed, pfixedStr, ah1titl, ah2titl, saveMe, saveStrVsT )
  else
    fluxVsTimePlotMultParams( ...
      fluxAll2plot ,fluxDiff2plot, jDiff, TimeVec, ...
      p1Vec, paramObj.kinVar1, paramObj.kinVar2, ...
      p3name, pfixed, pfixedStr, ah1titl, ah2titl, saveMe, saveStrVsT )
    ylabel( ' $$ j / j_{diff, steady} $$' );
    xlabel( ' $$ t / \tau $$ ' );
  end
end
% steady state solutions
if plotSteadyFlag
  x = linspace( 0, Lbox, paramObj.Nx );
  concSteadyPlotMultParams( AconcStdy, CconcStdy, x, ...
    p1Vec, paramObj.kinVar1, paramObj.kinVar2, p1name, p2name, p3name, ...
    pfixed, pfixedStr, saveMe, saveStrSS )
end
% Surface plot: max flux
if plotMapMaxFlag
  titleSort = '$$ j_{max} / j_{diff} $$; ';
  titstr = [ titleSort p1name ' = '] ;
  surfLoopPlotter( jNorm, p1Vec, paramObj.kinVar1, paramObj.kinVar2, ...
    xlab, ylab,  titstr, saveMe, saveStrFM)
end
% Surface plot: flux slope
if plotMapSlopeFlag
  titleSort = 'Slope, $$ \frac{dj}{dt} $$, at Half Max Flux; ';
  titstr = [ titleSort p1name ' = '] ;
  saveStr = [saveStrFM '_slopeHm'];
  surfLoopPlotter( djdtHm, p1Vec, paramObj.kinVar1, paramObj.kinVar2, ...
    xlab, ylab,  titstr, saveMe, saveStr)
end
% Surface plot: time to flux
if plotMapTimeFlag
  titleSort = 'Time at Half Max Flux; ';
  titstr = [ titleSort p1name ' = '] ;
  saveStr = [saveStrFM '_tHm'];
  surfLoopPlotter( tHm, p1Vec, paramObj.kinVar1, paramObj.kinVar2, ...
    xlab, ylab,  titstr, saveMe, saveStr)
end
% store everything
fluxSummary.jMax = jMax;
fluxSummary.jNorm = jNorm;
fluxSummary.djdtHm = djdtHm;
fluxSummary.tHm = tHm;
fluxSummary.AconcStdy = AconcStdy;
fluxSummary.CconcStdy = CconcStdy;
fluxSummary.FluxVsT = FluxVsT;
fluxSummary.FluxVsTDiff = FluxVsTDiff;
fluxSummary.paramObj = paramObj;
fluxSummary.timeVec = TimeVec;
% Save
if saveMe
  kinVar1 = paramObj.kinVar1;
  kinVar1str = paramObj.kinVar1str;
  kinVar2 = paramObj.kinVar2;
  kinVar2str = paramObj.kinVar2str;
  save(saveStrMat, 'fluxSummary', 'p1Vec', 'p1name', 'kinVar1','kinVar1str',...
    'kinVar2', 'kinVar2str', 'TimeVec');
  % make dirs and move
  if plotSteadyFlag || plotMapFlag
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
