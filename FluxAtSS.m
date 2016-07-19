% Find the flux at steady state for various parameter configurations
% Loops over KDinv, koff, nu

save_me = 0;
plotmap_flag = 1;

% Looped parameters
% Kon calculated in loop
nuVec  = [0 1 10];
% KDinvVec = [0 1e2 1e3 1e4 1e5 ];
% KoffVec = [ 1e-1 1e0 1e1 1e2 1e3 ];
% KDinvVec = [0 logspace(3,4.5,12) ];
% KoffVec = [ logspace(2,4,12) ];
KDinvVec = [0 logspace(3,5.0,10) ];
KoffVec = [ logspace(1,5.0,10) ];
savestr_fa = ['flxss'];

% Non-loopable parameters
linearEqn = 0;
BCstr = 'DirVn'; % 'Dir','Vn','DirVn'
DA  = 1;
AL  = 2e-4;
AR  = 0;
Bt  = 2e-3;
Nx  = 1000;
Lbox = 1;

% Flux matrix
fluxSS = zeros( length( nuVec ), length(KDinvVec), length( KoffVec ) );

% Calculated things
x = linspace(0, Lbox, Nx) ;
dx  = x(2) - x(1);

% Run the loops
for i = 1:length(nuVec)
  nu = nuVec(i);
  if nu == 0
    x = linspace(0, Lbox, Nx) ;
    dx = x(2) - x(1);
    AnlOde = (AR - AL) * x / Lbox + AL;
    CnlOde = zeros(1,Nx);
    flux   = - DA * ( AnlOde(end) - AnlOde(end-1) ) / dx;
    fluxSS( i, :, : ) = flux; 
  else
    for j = 1:length(KDinvVec)
      KDinv = KDinvVec(j);
      if KDinv == 0
        x = linspace(0, Lbox, Nx) ;
        dx = x(2) - x(1);
        AnlOde = (AR - AL) * x / Lbox + AL;
        CnlOde = zeros(1,Nx);
        flux   = - DA * ( AnlOde(end) - AnlOde(end-1) ) / dx;
        fluxSS( i, j, : ) = flux;
      else
        parfor k = 1:length(KoffVec)
          Koff = KoffVec(k);
          Kon  = Koff * KDinv;
          
          [AnlOde,CnlOde,x] = RdSsSolverMatBvFunc(...
            Kon,Koff,nu,AL,AR,Bt,Lbox,BCstr,Nx,linearEqn);
          dx = x(2) - x(1);
          flux   = - DA * ( AnlOde(end) - AnlOde(end-1) ) / dx;
          fluxSS( i, j, k ) = flux;
        end % loop Koff
      end % Kdinv = 0
    end % loop Kdinv
  end % if nu == 0
end % loop nu



%% Surface plot
if plotmap_flag
  
  for i = 1:length(nuVec)
    figure()
    
    % Flux
    imagesc( 1:length(KoffVec), 1:length(KDinvVec), ...
      reshape( fluxSS(i,:,:), [length(KDinvVec) length(KoffVec) ] ) );
    xlabel( 'Koff'); ylabel('KdInv');
    Ax = gca;
    Ax.YTick = 1:4:length(KDinvVec);
    Ax.YTickLabel = num2cell( round( KDinvVec(1:4:end) ) );
    Ax.XTick = 1: 4: length(KoffVec) ;
    Ax.XTickLabel = num2cell( round (KoffVec (1:4:end) ) );
    titstr = sprintf( 'Max Flux nu = %g', nuVec(i) );
    title(titstr)
    colorbar
    axis square
    
    % Save stuff
    if save_me
      savefig( gcf, [savestr_fa  '_nu'...
        num2str( nuVec(i) ) '.fig'] );
      saveas( gcf, [ savestr_fa '_nu'...
        num2str( nuVec(i) ) ], 'jpg' );
    end
  end
  
  if save_me
    save('FluxAtSS.mat', 'fluxSS', 'nuVec', 'KDinvVec', 'KoffVec');
  end
    
end








