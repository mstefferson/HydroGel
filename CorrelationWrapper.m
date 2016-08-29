%% CorrelationWrapper
%
% Make Correlation plots ( maxFlux, slope, time to half max ) from a saved matlab file 
load fluxStuff.mat
saveMe = 0;

plotNu = 1;
plotKdInv = 1;
plotKoff = 1;

KdInvInd = 1:length(KDinvVec);
nuInd = 1:length(nuVec);
KoffInd = 1:length*KoffInd;;

%% Nu 
if plotNu
  textstr = ' nu color';
  % Set-up figs
  H1 = figure(1);
  clf(H1)
  xlabel('max flux'); ylabel(' 1/time ');
  title(['Correlations: 1/time vs max flux' textstr])
  hold all
  Ax1 = H1.CurrentAxes;

  H2 = figure(2);
  clf(H2)
  xlabel('max flux'); ylabel('slope');
  title(['Correlations: slope vs max flux' textstr])
  hold all
  Ax2 = H2.CurrentAxes;

  H3 = figure(3);
  clf(H3)
  xlabel('slope'); ylabel('1 / time');
  title(['Correlations: 1 / time vs slope' textstr])
  hold all
  Ax3 = H3.CurrentAxes;


  % Loop over everything
  for ii = nuInd 
    fluxT   = jMax(ii,KdInvInd, KoffInd );
    timeT   = tHm(ii,KdInvInd, KoffInd );
    slopeT   = djdtHm(ii,KdInvInd, KoffInd );

    [l,m,n] = size( fluxT );
    totLength  = l*m*n;

    colrnd = [ rand() rand() rand() ];
    colplot = repmat( colrnd, [totLength 1] );
    fluxMaxVec = reshape( fluxT, [1 totLength] );
    tHmVec = reshape( timeT, [1 totLength] );
    djdtHmVec = reshape( slopeT, [1 totLength] );

    % Plot it
    scatter(Ax1,fluxMaxVec, 1 ./ tHmVec,36,colplot);
    scatter(Ax2,fluxMaxVec,djdtHmVec,36,colplot);
    scatter(Ax3,djdtHmVec, 1./ tHmVec,36,colplot);
  end

  if saveMe; savefig( H1, ['corr_time_jmax' '_nuc' '.fig'] ); end
  if saveMe; savefig( H2, ['corr_slope_jmax' '_nuc' '.fig'] ); end
  if saveMe; savefig( H3, ['corr_slope_time' '_nuc' '.fig'] ); end

end

%% Kdinv
if plotKdInv
  textstr = ' KDinv color';
  % Set-up figs
  H4 = figure(4);
  clf(H4)
  xlabel('max flux'); ylabel(' 1/time ');
  title(['Correlations: 1/time vs max flux' textstr])
  hold all
  Ax4 = H4.CurrentAxes;

  H5 = figure(5);
  clf(H5)
  xlabel('max flux'); ylabel('slope');
  title(['Correlations: slope vs max flux' textstr])
  hold all
  Ax5 = H5.CurrentAxes;

  H6 = figure(6);
  clf(H6)
  xlabel('slope'); ylabel('1 / time');
  title(['Correlations: 1 / time vs slope' textstr])
  hold all
  Ax6 = H6.CurrentAxes;

  % Loop over everything
  for ii = KdInvInd;
    fluxT   = jMax(nuInd,ii, KoffInd );
    timeT   = tHm(nuInd,ii, KoffInd );
    slopeT   = djdtHm(nuInd,ii, KoffInd );

    [l,m,n] = size( fluxT );
    totLength  = l*m*n;

    colrnd = [ rand() rand() rand() ];
    colplot = repmat( colrnd, [totLength 1] );
    fluxMaxVec = reshape( fluxT, [1 totLength] );
    tHmVec = reshape( timeT, [1 totLength] );
    djdtHmVec = reshape( slopeT, [1 totLength] );

    % Plot it
    scatter(Ax4,fluxMaxVec, 1 ./ tHmVec,36,colplot);
    scatter(Ax5,fluxMaxVec,djdtHmVec,36,colplot);
    scatter(Ax6,djdtHmVec, 1./ tHmVec,36,colplot);
  end

  if saveMe; savefig( H1, ['corr_time_jmax' '_kdc' '.fig'] ); end
  if saveMe; savefig( H2, ['corr_slope_jmax' '_kdc' '.fig'] ); end
  if saveMe; savefig( H3, ['corr_slope_time' '_kdc' '.fig'] ); end

end

%% Koff
if plotKoff
  textstr = ' koff color';
  % Set-up figs
  H7 = figure(7);
  clf(H7)
  xlabel('max flux'); ylabel(' 1/time ');
  title(['Correlations: 1/time vs max flux' textstr])
  hold all
  Ax7 = H7.CurrentAxes;

  H8 = figure(8);
  clf(H8)
  xlabel('max flux'); ylabel('slope');
  title(['Correlations: slope vs max flux' textstr])
  hold all
  Ax8 = H8.CurrentAxes;

  H9 = figure(9);
  clf(H9)
  xlabel('slope'); ylabel('1 / time');
  title(['Correlations: 1 / time vs slope' textstr])
  hold all
  Ax9 = H9.CurrentAxes;

  % Loop over everything
  for ii = KoffVec
    fluxT   = jMax(nuInd, KdInvInd, ii );
    timeT   = tHm(nuInd,KdInvInd, ii);
    slopeT   = djdtHm(nuInd,KdInvInd, ii);

    [l,m,n] = size( fluxT );
    totLength  = l*m*n;

    colrnd = [ rand() rand() rand() ];
    colplot = repmat( colrnd, [totLength 1] );
    fluxMaxVec = reshape( fluxT, [1 totLength] );
    tHmVec = reshape( timeT, [1 totLength] );
    djdtHmVec = reshape( slopeT, [1 totLength] );

    % Plot it
    scatter(Ax7,fluxMaxVec, 1 ./ tHmVec,36,colplot);
    scatter(Ax8,fluxMaxVec,djdtHmVec,36,colplot);
    scatter(Ax9,djdtHmVec, 1./ tHmVec,36,colplot);
  end

  if saveMe; savefig( H1, ['corr_time_jmax' '_koffc' '.fig'] ); end
  if saveMe; savefig( H2, ['corr_slope_jmax' '_koffc' '.fig'] ); end
  if saveMe; savefig( H3, ['corr_slope_time' '_koffc' '.fig'] ); end

end

