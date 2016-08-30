%% Plot vs time
% load it
load fluxStuff.mat
% String for saving
saveMe    = 1;  
savestr_vt = 'flxvst';
savestr_fm = 'flxmapSs_scaled_';

[Tr, Tc] =  size(TimeVec);

% Plot Koffs vs time for each KdInv
% Legend stuff
legcell = cell( length(KoffVec) + 1, 1 );
legcell{end} = 'No binding';
for ii = 1:length(nuVec)
  
  for jj = 2:length(KaVec)
    figure();
    % Plot it
    axis square
    hold all
    for kk = 1:length(KoffVec)
      plot(TimeVec, reshape( FluxVsT(ii,jj,kk,:), [Tr Tc] ) );
      legcell{kk} = ['Koff = ' num2str( KoffVec(kk) ) ];
    end
    plot( TimeVec, reshape( FluxVsT(ii,1,1,:), [Tr Tc] ) );
    
    %Axis
    xlabel('time');
    ylabel('flux');
    %   AH1.YLim = [ 0 1e-3 ]; AH2.YLim = [ 0 5e-4 ];
    % Titles
    titstr = sprintf('Kd^{-1} = %g (BA) Dc/Da = %g', KaVec(jj), nuVec(ii)  );
    title(titstr);
    
    legend(legcell,'location','best');

    % Save stuff
    savestr_vts = [savestr_vt '_Kdinv' num2str(round(KaVec(jj)))...
      '_nu' num2str(nuVec(ii)) ];
    savefig( gcf, [savestr_vts '.fig'] );
    saveas( gcf, savestr_vts, 'jpg' );
  end
end

%% Surface plot

deltaTick = 2;
for ii = 1:length(nuVec)
  figure()
  
  % Flux Max
  imagesc( 1:length(KoffVec), 1:length(KaVec), ...
    reshape( jMax(ii,:,:), [length(KaVec) length(KoffVec) ] ) );
  xlabel( 'Koff'); ylabel('KdInv');
  Ax = gca;
  Ax.YTick = 1:deltaTick:length(KaVec);
  Ax.YTickLabel = num2cell( round( KaVec(1:deltaTick:end) ) );
  Ax.XTick = 1:deltaTick: length(KoffVec) ;
  Ax.XTickLabel = num2cell( round (KoffVec (1:deltaTick:end) ) );
%   Ax.CLim = [ min(min(min(jMax))) max(max(max(jMax)))];
  titstr = sprintf( 'Max Flux: nu = %g', nuVec(ii) );
  title(titstr)
  colorbar
  axis square
  if saveMe   ;
    savefig( gcf, [savestr_fm '_max' '_nu'...
      num2str( nuVec(ii) ) '.fig'] );
    saveas( gcf, [ savestr_fm '_max' '_nu'...
      num2str( nuVec(ii) ) ], 'jpg' );
  end
  
  figure()
  % Slope at half max
  imagesc( 1:length(KoffVec), 1:length(KaVec), ...
    reshape( djdtHm(ii,:,:), [length(KaVec) length(KoffVec) ] ) );
  xlabel( 'Koff'); ylabel('KdInv');
  Ax = gca;
  Ax.YTick = 1:deltaTick:length(KaVec);
  Ax.YTickLabel = num2cell( round( KaVec(1:deltaTick:end) ) );
  Ax.XTick = 1:deltaTick: length(KoffVec) ;
  Ax.XTickLabel = num2cell( round (KoffVec (1:deltaTick:end) ) );
%   Ax.CLim = [ min(min(min(djdtHm))) max(max(max(djdtHm)))];
  titstr = sprintf( 'Slope, dj/dt, at Half Max Flux: nu = %g', nuVec(ii) );
  title(titstr)
  colorbar
  axis square
  if saveMe   ;
    savefig( gcf, [savestr_fm '_slopeHm'  '_nu'...
      num2str( nuVec(ii) ) '.fig'] );
    saveas( gcf, [ savestr_fm '_slopeHm' '_nu'...
      num2str( nuVec(ii) ) ], 'jpg' );
  end
  
  figure()
  % Time at half max
  imagesc( 1:length(KoffVec), 1:length(KaVec), ...
    reshape( tHm(ii,:,:), [length(KaVec) length(KoffVec) ] ) );
  xlabel( 'Koff'); ylabel('KdInv');
  Ax = gca;
  Ax.YTick = 1:deltaTick:length(KaVec);
  Ax.YTickLabel = num2cell( round( KaVec(1:deltaTick:end) ) );
  Ax.XTick = 1:deltaTick: length(KoffVec) ;
  Ax.XTickLabel = num2cell( round (KoffVec (1:deltaTick:end) ) );
%   Ax.CLim = [0 max(max(max(tHm)))];
  titstr = sprintf( ' Time at Half Max Flux: nu = %g', nuVec(ii) );
  title(titstr)
  colorbar
  axis square
  if saveMe   ;
    savefig( gcf, [savestr_fm  '_tHm' '_nu'...
      num2str( nuVec(ii) ) '.fig'] );
    saveas( gcf, [ savestr_fm '_tHm' '_nu'...
      num2str( nuVec(ii) ) ], 'jpg' );
  end
end % loop nu



