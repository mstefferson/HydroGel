% Add path
addpath( genpath( pwd ) );

AlVec =  logspace(-9,-3,5) ;
BtVec =  logspace(-5,-1,7) ;
KaVec =  logspace(4,8,5) ;
nuVec = [0.25 0.5 0.75];
initParams;

numAl = length(AlVec);
numBt = length(BtVec);
numKa = length(KaVec);
numNu = length(nuVec);
jError = zeros( numAl, numBt, numKa );
AlKaVsBt_NuCell = cell( numNu, 1 );
AlKaVsBt_NuParamsAlKa = cell( numNu, 1 );
AlKaVsBt_NuParamsBt = cell( numNu, 1 );
AlKaVsNu_BtCell = cell( numBt, 1 );
AlKaVsNu_BtParams = cell( numBt, 1 );
KaVcAl_BtNuCell = cell( numBt, numNu );
KaVcAl_BtNuParamsAl = cell( numBt, numNu );
KaVcAl_BtNuParamsKa = cell( numBt, numNu );
AlVsBt_KaNuCell = cell( numKa, numNu );
AlVsBt_KaNuParams = cell( numKa, numNu );

for nn = 1:numNu
  AlKaVsBt_NuCell{nn} = zeros( numAl * numKa, numBt );
  AlKaVsBt_NuParamsAlKa{nn} = zeros( numAl * numKa, 1 );
  AlKaVsBt_NuParamsBt{nn} = zeros( numBt, 1 );
  AlKaVsBt_NuParamsBt{nn} = BtVec;
  for bb = 1:numBt
    KaVcAl_BtNuCell{nn}{bb} = zeros( numAl, numKa );
    KaVcAl_BtNuParamsAl{nn}{bb} = AlVec;
    KaVcAl_BtNuParamsKa{nn}{bb} = KaVec;
  end
end

for aa = 1:numAl
  Altemp = AlVec(aa);
  for bb = 1:numBt
    Bttemp = BtVec(bb);
    % run it
    jOutLin = fluxODEBtALInputs( Altemp, Bttemp, KaVec, nuVec, 0 );
    jOutNl = fluxODEBtALInputs( Altemp, Bttemp, KaVec, nuVec, 1 );
    % reshape
    jLinRs = reshape( jOutLin.jNorm, [numNu numKa] );
    jNlRs = reshape( jOutNl.jNorm, [numNu numKa] );
    jDifference = jNlRs - jLinRs;
    for nn = 1:numNu
      % AlKa Vs Vt
      AlKaInds = (aa-1)*numKa+1:aa*numKa;
      AlKaVsBt_NuParamsAlKa{nn}(AlKaInds) = (Altemp .* KaVec)';
      AlKaVsBt_NuCell{nn}(AlKaInds, bb )  = jDifference(nn, :)';
      % Ka vs Al
      KaVcAl_BtNuCell{nn}{bb}(aa,:) = jDifference(nn,:);
    end
  end
end

%% plot
legcell = cell( numBt, 1 );
legendCell = cellstr(num2str(BtVec', 'Bt=%.1e'));
paramCol = AlKaVsBt_NuParamsBt{1};
paramRow = AlKaVsBt_NuParamsAlKa{1};
for nn = 1:numNu
  matTemp = AlKaVsBt_NuCell{nn};
  figure()
  ax = gca;
  ax.XScale = 'log';
  ax.YLim = [-50 0];
  xlabel('$$ K_A A_L $$'); ylabel('NL-Lin');
  hold on
  title( ['nu = ' num2str( nuVec(nn) ) ...
    ' konBt = ' num2str( paramMaster.KonBt ) ] );
  for bb = 1:numBt
    scatter( paramRow, matTemp(:,bb)  )
  end
  legend( legendCell,'location', 'best')
end