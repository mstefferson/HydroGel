% Find the flux at steady state for various parameter configurations
% Loops over Ka, koff, nu
saveMe = 0;
plotMapFlag = 1;
plotSteadyFlag = 1;

% Looped parameters
% Kon calculated in loop
nuVec  = [0 1];
KonBtVec = [0 logspace(3,4.0,2) ];
KoffVec = [ logspace(1,4.0,2) ];
savestr_fa = 'flxss';
savestr_ss = 'profileSS';

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
    for k = 1:length(KoffVec)
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
  xlab = 'K_{off} \tau';
  ylab = 'K_{on}B_{t} \tau';
  fluxSurfPlotter( fluxSS, nuVec, KoffVec, KonBtVec,...
    xlab, ylab,  titstr, saveMe, savestr_fa )
end

if plotSteadyFlag
  concSteadyPlotMultParams( AconcStdy, CconcStdy, x, ...
    nuVec, KonBtVec, KoffVec, 'nu', 'K_{on}B_{t}', 'K_{off}', ...
    saveMe, savestr_ss  )
end

if saveMe
  save('FluxAtSS.mat', 'fluxSS', 'nuVec', 'KaVec', 'KoffVec');
end