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
  fluxODE( plotMapFlag, plotSteadyFlag, saveMe, dirname )
% Latex font
set(0,'defaulttextinterpreter','latex')
% Make up a dirname if one wasn't given
if nargin < 3
  if saveMe == 1
    dirname = ['fluxODE_' num2str( randi( 100 ) )];
  else
    dirname = ['tempFluxODE_' num2str( randi( 100 ) ) ];
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
if exist( 'initParams.m','file')
  initParams;
else
  cpParams
  initParams
end
% Copy master parameters input object
paramObj = paramMaster;
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
paramObj.nu = p1Vec;
numP1 = length(p1Vec);
% Fix N if it's too low and make sure Bt isn't a vec
if ( paramObj.Nx < 1000 ); paramObj.Nx = 1000; end;
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
  paramObj.kinVar1strTex = '$$ k_{on} B_t $$';
  paramObj.kinVar2 = paramObj.Koff;
  paramObj.kinVar2str = 'koff';
  paramObj.kinVar2strTex = '$$ k_{off}$$';
elseif strcmp( kinParams.fixedVar, 'koff')
  paramObj.kinVar1 = paramObj.KonBt;
  paramObj.kinVar1str = 'konBt';
  paramObj.kinVar1strTex = '$$ k_{on} B_t $$';
  paramObj.kinVar2 = paramObj.Ka;
  paramObj.kinVar2str = 'Ka';
  paramObj.kinVar2strTex = '$$ K_A $$';
else % 'konBt'
  paramObj.kinVar1 = paramObj.Koff;
  paramObj.kinVar1strTex = '$$ k_{off}$$';
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
% save names
saveStrFM = 'flxss'; %flux map
saveStrSS = 'profileSS'; % steady state
saveStrMat = 'FluxAtSS.mat'; % matlab files
if saveMe; dirname = [dirname '_nl' num2str( flagsObj.NLcoup )]; end;
if plotMapFlag
  xlab = paramObj.kinVar1strTex;
  ylab = paramObj.kinVar2strTex;
end
if plotSteadyFlag
  pfixed = paramObj.Bt;
  pfixedStr = '$$ B_t $$';
  p2name = paramObj.kinVar1strTex;
  p3name = paramObj.kinVar2strTex;
end
% Specify necessary parameters for parfor
linearEqn = ~flags.NLcoup;
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
AconcStdy = zeros( numRuns, Nx );
CconcStdy = zeros( numRuns, Nx );
% Calculated things
x = linspace(0, Lbox, Nx) ;
dx  = x(2) - x(1);
parfor ii = 1:numRuns
  % set params
  p1Temp = paramNuLlp(ii);
  KonBt  = paramKonBt(ii);
  Koff  = paramKoff(ii);
  Kon = KonBt ./ Bt;
  if boundTetherDiff
    Dc =  boundTetherDiffCalc( p1Temp, Koff, Da);
    nu = Dc ./ Da;
  else
    nu = p1Temp;
  end
  [AnlOde,CnlOde,~] = RdSsSolverMatBvFunc(...
    Kon,Koff,nu,AL,AR,Bt,Lbox,BCstr,Nx,linearEqn);
  % calc flux
  flux   = - Da * ( AnlOde(end) - AnlOde(end-1) ) / dx;
  % record
  AconcStdy(ii,:) = AnlOde;
  CconcStdy(ii,:) = CnlOde;
  jMax(ii) = flux;
end
% reshape to more intutive size---> Mat( p1, p2, p3, : )
AconcStdy = reshape( AconcStdy, [numP1, numP2, numP3, Nx] );
CconcStdy = reshape( CconcStdy, [numP1, numP2, numP3, Nx] );
jMax = reshape( jMax, [numP1, numP2, numP3] );
% Get flux diff and normalize it
jDiff = Da * ( AL - AR ) / Lbox;
jNorm = jMax ./  jDiff;
% Surface plot
if plotMapFlag
  if flags.BoundTetherDiff
    titstr = ['$$ j_{max} / j_{diff} $$; $$ B_t = $$ ' num2str(Bt) '; $$ Ll_p = $$ '];
  else
    titstr = ['$$ j_{max} / j_{diff} $$; $$ B_t = $$ ' num2str(Bt) '; $$ \nu = $$ ' ];
  end
  save
  surfLoopPlotter( jNorm, p1Vec, paramObj.kinVar1, paramObj.kinVar2,...
    xlab, ylab,  titstr, saveMe, saveStrFM )
end
% Steady states
if plotSteadyFlag
  concSteadyPlotMultParams( AconcStdy, CconcStdy, x, ...
    p1Vec,  paramObj.kinVar1, paramObj.kinVar2, p1name, p2name, p3name, ...
    pfixed, pfixedStr, saveMe, saveStrSS )
end
% store everything
fluxSummary.jMax = jMax;
fluxSummary.jNorm = jNorm;
fluxSummary.AconcStdy = AconcStdy;
fluxSummary.CconcStdy = CconcStdy;
fluxSummary.paramObj = paramObj;
% save data
if saveMe
  kinVar1 = paramObj.kinVar1;
  kinVar1str = paramObj.kinVar1str;
  kinVar2 = paramObj.kinVar2;
  kinVar2str = paramObj.kinVar2str;
  save(saveStrMat, 'fluxSummary', 'p1Vec', 'p1name', 'kinVar1', 'kinVar1str', ...
  'kinVar2', 'kinVar2str');
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
