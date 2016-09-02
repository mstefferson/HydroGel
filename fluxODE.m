% Add paths and output dir 
addpath( genpath('./src') );
if ~exist('./steadyfiles','dir'); mkdir('steadyfiles'); end;
if ~exist('./steadyfiles/ODE','dir'); mkdir('steadyfiles/ODE'); end;

Time = datestr(now);
fprintf('Starting fluxODE: %s\n', Time)

% Find the flux at steady state for various parameter configurations
% Loops over Ka, koff, nu
saveMe = 1;
plotMapFlag = 1;
plotSteadyFlag = 1;

saveStrFM = 'flxss'; %flux map
saveStrSS = 'profileSS'; % steady state
saveStrMat = 'FluxAtSS.mat'; % matlab files
dirname = 'temp'; % save dir

if plotMapFlag 
  xlab = 'k_{off} \tau';
  ylab = 'k_{on}B_{t} \tau';
end
if plotSteadyFlag
    p1name = '\nu'; 
    p2name = 'k_{on}B_{t}'; 
    p3name = 'k_{off}';
end

% Looped parameters
% Kon calculated in loop
nuVec  = [0 1];
KonBtVec = [0 logspace(3,4.0,2) ];
KoffVec = [ logspace(1,4.0,1) ];

% Non-loopable parameters
linearEqn = 1;
BCstr = 'DirVn'; % 'Dir','Vn','DirVn'
DA  = 1;
AL  = 2e-4;
AR  = 0;
Bt  = 2e-3;
Nx  = 1000;
Lbox = 1;

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
      flux   = - DA * ( AnlOde(end) - AnlOde(end-1) ) / dx;
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
  fluxSurfPlotter( fluxSS, nuVec, KoffVec, KonBtVec,...
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

