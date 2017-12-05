% fluxODE uses matlabs boundary value solver to find the steady state solution
% of the RD equation for various parameter configurations by solving the ODE ( dv/dt = 0 ).
% Using this, it calculated the RHS flux and makes nice plots. Loops over
% nu, KonBt, Koff.
% fluxODE( plotMapFlag, plotSteadyFlag, saveMe, dirname )
%
% Inputs:
% plotFlag: structure of plot flags
% storeFlag: structure of store flags
% saveMe: save plots and outputs
% dirname: directory name for saving
% paramFile: initParam file
% paramInputMaster: input params 
% nu = paramInput(:,1);
% konBt = paramInput(:,2);
% koff = paramInput(:,3);
% bt = paramInput(:,4);
%
% plotFlag with fields
% plotFlag.plotMapFlux: surface plot jmax vs koff and konbt
% plotFlag.plotSteady: plot concentration profiles
%
% storeFlag with fields
% storeFlag.storeStdy: store steady state solution flag
%
% Outputs: fluxSummary with fields
% jMax: matrix of steady state flux vs koff and konbt
% jNorm: jMax ./ jDiff
% AconcStdy: matrix of A steady state profile vs koff and konbt
% CconcStdy: matrix of C steady state profile vs koff and konbt
% params: parameters of runs
%
% example run
%
% plotFlag.plotSteady = 1;
% plotFlag.plotMapFlux = 1;
% storeFlag.storeStdy = 1;
% saveMe = 1;
% dirname = 'blah';
%
% [fluxSummary] = fluxODE( plotFlag, storeFlag, saveMe, dirname );

function [ fluxSummary ] = ...
  fluxODEParamIn( plotFlag, storeFlag, saveMe, dirname, paramInput, paramFile )
% Latex font
set(0,'defaulttextinterpreter','latex')
% Make up a dirname if one wasn't given
if nargin == 2
  saveMe = 0;
end
if nargin == 2
  if saveMe == 1
    dirname = ['fluxODE_' num2str( randi( 100 ) )];
  end
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
  run( 'initParams.m');
end
% Copy master parameters input object
paramObj = paramMaster;
flagsObj = flags;
% Code can only handle one value of Bt currently
if length( paramObj.Bt ) > 1
  paramObj.Bt = paramObj.Bt(1);
end
% set-up params
pfixed = paramObj.Bt;
BtFixed = paramObj.Bt;
pfixedStr = '$$ B_t $$';
[paramObj, kinParams] = paramLoadMaster( paramObj, paramInput );
% Run the loops
paramNuLlp  = kinParams.nuLlp;
paramKonBt  = kinParams.konBt;
paramKoffInds = kinParams.koffInds;
% warn about low N
numRuns = kinParams.numRuns;
if paramObj.Nx < 1000
  fprintf('Warning, very low number of grid points\n')
end
% save names
saveStrFM = 'flxss'; %flux map
saveStrSS = 'profileSS'; % steady state
saveStrMat = 'FluxAtSS.mat'; % matlab files
if saveMe; dirname = [dirname '_nl' num2str( flagsObj.NLcoup )]; end
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
% set bound diffusion or not
nuCell = cell(1, numRuns);
for ii = 1:numRuns
  nuCell{ii} = { paramObj.DbParam{1}, paramNuLlp(ii) };
end
% set up koff cell
koffCell = cell( 1, numRuns );
for ii = 1:numRuns
  koffCell{ii} = paramObj.koffObj.InfoCell{ paramKoffInds(ii) };
end

% parfor (ii=1:numRuns, numWorkers)
for ii=1:numRuns
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
% Get flux diff and normalize it
jDiff = Da * ( AL - AR ) / Lbox;
jNorm = jMax ./  jDiff;
% store everything
fluxSummary.jMax = jMax;
fluxSummary.jNorm = jNorm;
fluxSummary.jDiff = jDiff;
fluxSummary.aConcStdy = AconcStdy;
fluxSummary.cConcStdy = CconcStdy;
fluxSummary.paramObj = paramObj;
fluxSummary.kinParams = kinParams;
fluxSummary.paramInput = paramInput;
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
