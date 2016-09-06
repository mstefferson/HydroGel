% fluxODE uses matlabs boundary value solver to find the steady state solution
% of the RD equation for various parameter configurations by solving the ODE ( dv/dt = 0 ).
% Using this, it calculated the RHS flux and makes nice plots. Loops over
% nu, KonBt, Koff.
% fluxODE( plotMapFlag, plotSteadyFlag, saveMe, dirname ) 

function [fluxSS, AconcStdy, CconcStdy, params] = ...
  fluxODE( plotMapFlag, plotSteadyFlag, saveMe, dirname ) 

% Make up a dirname if one wasn't given
if nargin == 3 && saveMe == 1
  dirname = ['flux_' num2str( randi( 100 ) )];
end

% Add paths and output dir 
addpath( genpath('./src') );
if ~exist('./steadyfiles','dir'); mkdir('steadyfiles'); end;
if ~exist('./steadyfiles/ODE','dir'); mkdir('steadyfiles/ODE'); end;

Time = datestr(now);
fprintf('Starting fluxODE: %s\n', Time)

% Initparams
fprintf('Initiating parameters\n');
if exist( 'initParams.m','file');
  initParams;
else
  cpParams
  initParams
end

% Copy master parameters input object
paramObj = paramMaster;
flagsObj = flags;
% Looped over parameters
nuVec = paramObj.nu;
KonBtVec = paramObj.KonBt; 
KoffVec = paramObj.Koff; 

% Store parameters just in case
params.nu = nuVec;
params.Koff = KoffVec;
params.KonBt = KonBtVec;

if length( paramObj.Bt ) > 1
  paramObj.Bt = paramObj.Bt(1);
end

saveStrFM = 'flxss'; %flux map
saveStrSS = 'profileSS'; % steady state
saveStrMat = 'FluxAtSS.mat'; % matlab files
if saveMe; dirname = [dirname '_nl' num2str( flagsObj.NLcoup )]; end;
if plotMapFlag 
  xlab = 'k_{off} \tau';
  ylab = 'k_{on}B_{t} \tau';
end
if plotSteadyFlag
  p1name = '\nu'; 
  p2name = 'k_{on}B_{t}'; 
  p3name = 'k_{off}';
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
fluxSS = zeros( length( nuVec ), length(KonBtVec), length( KoffVec ) );

% Store steady state solutions;
AconcStdy = zeros( length( nuVec ), length(KonBtVec), length( KoffVec ), Nx );
CconcStdy = zeros( length( nuVec ), length(KonBtVec), length( KoffVec ), Nx );

% Calculated things
x = linspace(0, Lbox, Nx) ;
dx  = x(2) - x(1);

% Run the loops
for i = 1:length(nuVec)
  nu = nuVec(i);
  for j = 1:length(KonBtVec)
    Kon = KonBtVec(j) ./ Bt;
    parfor k = 1:length(KoffVec)
      Koff = KoffVec(k);
      [AnlOde,CnlOde,x] = RdSsSolverMatBvFunc(...
        Kon,Koff,nu,AL,AR,Bt,Lbox,BCstr,Nx,linearEqn);
      % calc flux
      flux   = - Da * ( AnlOde(end) - AnlOde(end-1) ) / dx;
      % record
      AconcStdy(i,j,k,:) = AnlOde;
      CconcStdy(i,j,k,:) = CnlOde;
      fluxSS( i, j, k ) = flux;
    end % loop Koff
  end % loop Kdinv
end % loop nu

%% Surface plot
if plotMapFlag
  titstr = 'Max Flux nu = ';
  surfLoopPlotter( fluxSS, nuVec, KoffVec, KonBtVec,...
    xlab, ylab,  titstr, saveMe, saveStrFM )
end

if plotSteadyFlag
  concSteadyPlotMultParams( AconcStdy, CconcStdy, x, ...
    nuVec, KonBtVec, KoffVec, p1name, p2name, p3name, ...
    saveMe, saveStrSS  )
end

if saveMe
  % save data
  save(saveStrMat, 'fluxSS', 'AconcStdy', 'CconcStdy','nuVec', 'KonBtVec', 'KoffVec');
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

