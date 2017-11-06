% fluxODE uses matlabs boundary value solver to find the steady state solution
% of the RD equation for various parameter configurations by solving the ODE ( dv/dt = 0 ).
% Using this, it calculated the RHS flux and makes nice plots. Loops over
% nu, KonBt, Koff.
% fluxODE( plotMapFlag, plotSteadyFlag, saveMe, dirname )
%
% Inputs:
% plotMapFlag: surface plot jmax vs koff and konbt
% plotSteadyFlag: plot concentration profiles
% saveMe: save plots and outputs
% dirname: directory name for saving
%
% Outputs: fluxSummary with fields
% jMax: matrix of steady state flux vs koff and konbt
% jNorm: jMax ./ jDiff
% AconcStdy: matrix of A steady state profile vs koff and konbt
% CconcStdy: matrix of C steady state profile vs koff and konbt
% params: parameters of runs
function [ fluxSummary ] = ...
  fluxODE( plotMapFlag, plotSteadyFlag, saveMe, dirname, paramFile )
% Latex font
set(0,'defaulttextinterpreter','latex')
% Make up a dirname if one wasn't given
if nargin <= 3
  if saveMe == 1
    dirname = ['fluxODE_' num2str( randi( 100 ) )];
  else
    dirname = ['tempFluxODE_' num2str( randi( 100 ) ) ];
  end
end
if nargin <= 4
  paramFile = 'initParams.m';
end
% Add paths and output dir
addpath( genpath('./src') );
if ~exist('./steadyfiles','dir'); mkdir('steadyfiles'); end;
if ~exist('./steadyfiles/ODE','dir'); mkdir('steadyfiles/ODE'); end;
% print start time
Time = datestr(now);
fprintf('Starting fluxODE: %s\n', Time)
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
flagsObj = flags;
boundTetherDiff = flags.BoundTetherDiff;
% Code can only handle one value of Bt currently
if length( paramObj.Bt ) > 1
  paramObj.Bt = paramObj.Bt(1);
end
% set-up params
pfixed = paramObj.Bt;
BtFixed = paramObj.Bt;
pfixedStr = '$$ B_t $$';
[paramObj, kinParams] = paramInputMaster( paramObj, koffVary, flags );
% Run the loops
paramNuLlp  = kinParams.nuLlp;
paramKonBt  = kinParams.konBt;
paramKoffInds = kinParams.koffInds;
numRuns = kinParams.numRuns;
% save names
saveStrFM = 'flxss'; %flux map
saveStrSS = 'profileSS'; % steady state
saveStrMat = 'FluxAtSS.mat'; % matlab files
if saveMe; dirname = [dirname '_nl' num2str( flagsObj.NLcoup )]; end
if plotMapFlag
  % set colormap
  randI = randi(100000);
  figure(randI)
  colormap( viridis );
  close(randI)
  % labels
  ylab = kinParams.kinVar1strTex; % rows
  xlab = kinParams.kinVar2strTex; % columns
end
if plotSteadyFlag
  p1name = kinParams.p1name;
  p2name = kinParams.kinVar1strTex;
  p3name = kinParams.kinVar2strTex;
end
% Specify necessary parameters for parfor
nlEqn = flags.NLcoup;
Da = paramObj.Da; AL = paramObj.AL; AR = paramObj.AR;
Bt = paramObj.Bt; Nx = paramObj.Nx; Lbox = paramObj.Lbox;
if strcmp( paramObj.A_BC,'Dir' ) && strcmp( paramObj.C_BC, 'Vn' )
  BCstr = 'DirVn';
elseif strcmp( paramObj.A_BC,'Dir' ) && strcmp( paramObj.C_BC, 'Vn' )
  BCstr = 'Dir';
elseif strcmp( paramObj.A_BC,'Vn' ) && strcmp( paramObj.C_BC, 'Vn' )
  BCstr = 'Vn';
else
  fprintf( 'I cannot handle those BC, doing A = Dir, C = Vn \n')
  BCstr = 'DirVn';
end
% Flux matrix
jMax = zeros( 1, numRuns);
% Store steady state solutions;
AconcStdy = cell( numRuns, 1 );
CconcStdy = cell( numRuns, 1 );
% Calculated things
x = linspace(0, Lbox, Nx) ;
dx  = x(2) - x(1);
if numRuns > 1 && flags.ParforFlag
  recObj = 0;
  parobj = gcp;
  numWorkers = parobj.NumWorkers;
  fprintf('I have hired %d workers\n',parobj.NumWorkers);
else
  fprintf('Not using parfor\n')
  numWorkers = 0;
end
% set bound diffusion or not
nuCell = cell(1, numRuns);
for ii = 1:numRuns
  if boundTetherDiff
  nuCell{ii} = {'bound', paramNuLlp(ii)};
  else
  nuCell{ii} = {'const', paramNuLlp(ii)};
  end
end
% set up koff cell
koffCell = cell( 1, numRuns );
for ii = 1:numRuns
  koffCell{ii} = paramObj.KoffObj.InfoCell{ paramKoffInds(ii) };
end

parfor (ii=1:numRuns, numWorkers)
  % set params
  nuCellTemp = nuCell{ii};
  KonBt  = paramKonBt(ii);
  koffCellTemp = koffCell{ ii };
  Kon = KonBt ./ BtFixed;  
  [AnlOde,CnlOde,~] = RdSsSolverMatBvFunc(...
    Kon, koffCellTemp, nuCellTemp, AL, AR, BtFixed, Lbox, BCstr, Nx, nlEqn );
  % calc flux
  flux   = - Da * ( AnlOde(end) - AnlOde(end-1) ) / dx;
  % record
  AconcStdy{ii} = AnlOde;
  CconcStdy{ii} = CnlOde;
  jMax(ii) = flux;
end

% reshape to more intutive size---> Mat( p1, p2, p3, : )
numP1 = kinParams.numP1;
numP2 = kinParams.numP2;
numP3 = kinParams.numP3;
AconcStdy = reshape( AconcStdy, [numP1, numP2, numP3] );
CconcStdy = reshape( CconcStdy, [numP1, numP2, numP3] );
jMax = reshape( jMax, [numP1, numP2, numP3] );
% Get flux diff and normalize it
jDiff = Da * ( AL - AR ) / Lbox;
jNorm = jMax ./  jDiff;
% Steady states
if plotSteadyFlag
  concSteadyPlotMultParams( AconcStdy, CconcStdy, x, ...
    kinParams.p1Vec,  kinParams.kinVar1, kinParams.kinVar2, ...
    p1name, p2name, p3name, ...
    pfixed, pfixedStr, saveMe, saveStrSS )
end
% Surface plot
if plotMapFlag
  if flags.BoundTetherDiff
    titstr = ['$$ j_{max} / j_{diff} $$; $$ B_t = $$ ' num2str(BtFixed) '; $$ Ll_p = $$ '];
  else
    titstr = ['$$ j_{max} / j_{diff} $$; $$ B_t = $$ ' num2str(BtFixed) '; $$ \nu = $$ ' ];
  end
  save
  surfLoopPlotter( jNorm, kinParams.p1Vec, kinParams.kinVar1, kinParams.kinVar2,...
    xlab, ylab,  titstr, saveMe, saveStrFM )
end
% store everything
fluxSummary.jMax = jMax;
fluxSummary.jNorm = jNorm;
fluxSummary.jDiff = jDiff;
fluxSummary.aConcStdy = AconcStdy;
fluxSummary.cConcStdy = CconcStdy;
fluxSummary.paramObj = paramObj;
fluxSummary.kinParams = kinParams;
% save data
if saveMe
  save(saveStrMat, 'fluxSummary');
  % make dirs and move
  if plotSteadyFlag || plotMapFlag
    movefile('*.fig', dirname);
    movefile('*.jpg', dirname);
  end
  movefile(saveStrMat, dirname);
  movefile(dirname, './steadyfiles/ODE' )
end
Time = datestr(now);
fprintf('Finished fluxODE: %s\n', Time)
