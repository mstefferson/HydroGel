% Build vectors and matrices
%  KDinvVec = [0 logspace(3,4.5,12) ];
%  KoffVec = [ logspace(2,4,12) ];

% KDinvVec = [0 linspace(1e4 - 500,1e4 + 500,12) ];
% KoffVec = [ logspace(1e2 - 50, 1e2 + 50,12) ];
saveMe     = 1;
nuVec       = [0 1 10];
KDinvVec = [0 logspace(3,5,12) ];
KoffVec = [ logspace(1,4,16)  ];
dt_fac   = 0.5;
savestr_vt = 'flxvst';
savestr_fm = ['flxmapSs'];
plotvst_flag = 1;
plotmap_flag = 1;

% Add paths and see where we are
addpath('./Subroutines');
if ~exist('./Outputs','dir'); mkdir('Outputs'); end;
Time = datestr(now);
currentdir=pwd;
fprintf('In dir %s\n',currentdir);

fprintf('Starting Flux Loop: %s\n', Time)

% Initparams
fprintf('Initiating parameters\n');
if exist( 'InitParams.m','file');
  InitParams;
else
  cpParams
  InitParams
end

% "Analysis" subroutines
AnalysisObj.QuickMovie=0; AnalysisObj.TrackAccumFromFlux= 1;
AnalysisObj.TrackAccumFromFluxPlot=0; AnalysisObj.PlotMeLastConc=0;
AnalysisObj.PlotMeAccum=0; AnalysisObj.PlotMeWaveFrontAccum=0;
AnalysisObj.PlotMeLastConcAccum=0; AnalysisObj.CheckConservDen=0;
AnalysisObj.ShowRunTime=0;

% Build TimeObj
dt = dt * dt_fac;
[TimeObj] = TimeObjMakerRD(dt,t_tot,t_rec,ss_epsilon,NumPlots);
dtSave = TimeObj.dt;


% Display everything
fprintf('trial:%d A_BC: %s C_BC: %s\n', ...
  ParamObj.trial,ParamObj.A_BC, ParamObj.C_BC)
disp(ParamObj); disp(AnalysisObj); disp(TimeObj);

% Edits here. Change params and loop over
FluxVsT = zeros( length(nuVec), length(KDinvVec) , length(KoffVec), TimeObj.N_rec );
AccumVsT = zeros( length(nuVec), length(KDinvVec) , length(KoffVec), TimeObj.N_rec );


% Run Diff first
Koff = 0;
Kon = 0;
dt = dtSave;

[A,C,DidIBreak,SteadyState,Flux2ResR_rec,FluxAccum_rec] = ...
  ChemDiffMainFluxReturn(ParamObj,TimeObj,AnalysisObj, Koff, Kon, dt);
% keyboard
% temp = repmat( reshape( Flux2ResR_rec, [1 1 1 length(Flux2ResR_rec) ] ) , ...
%   [1 length(nuVec) length(KoffVec) 1] );
FluxVsT(:,1,:,:) = repmat( reshape( Flux2ResR_rec, [1 1 1 length(Flux2ResR_rec) ] ) , ...
  [1 length(nuVec) length(KoffVec) 1] );
AccumVsT(:,1,:,:) = repmat( reshape( FluxAccum_rec, [1 1 1 length(Flux2ResR_rec) ] ) , ...
  [1 length(nuVec) length(KoffVec) 1] );

for ii = 1:length(nuVec)
  ParamObj.Dc  = nuVec(ii);
  fprintf('\n\n Starting nu = %g \n\n', ParamObj.Dc );
  for jj = 2:length(KDinvVec)
    ParamObj.KDinv = KDinvVec(jj);
    KDinv = ParamObj.KDinv;
    fprintf('\n\n Starting Kd = %f \n\n', ParamObj.KDinv );
    parfor kk = 1:length(KoffVec)
      %       ParamObj.Koff = KoffVec(kk);
      %       ParamObj.Kon   = ParamObj.KDinv * ParamObj.Koff;
      
      Koff = KoffVec(kk);
      Kon  = KDinv * Koff;
      
      if Kon > 1e8
        dt = dtSave / 10;
      else
        dt = dtSave;
      end
      
      fprintf( 'Koff = %f Kon = %f\n',Koff,Kon );
      [A,C,DidIBreak,SteadyState,Flux2ResR_rec,FluxAccum_rec] = ...
        ChemDiffMainFluxReturn(ParamObj,TimeObj,AnalysisObj, Koff, Kon, dt);
      
      if DidIBreak == 1 || SteadyState == 0
        fprintf('B = %d S = %d\n',DidIBreak,SteadyState)
      end
      
      FluxVsT(ii,jj,kk,:) = Flux2ResR_rec;
      AccumVsT(ii,jj,kk,:) = FluxAccum_rec;
    end
  end
end

%%
% Find Maxes and such
TimeVec = (0:TimeObj.N_rec-1) * t_rec;
jMax = FluxVsT(:,:,:,end);
aMax = AccumVsT(:,:,:,end);

djdtHm = zeros( length(nuVec), length(KDinvVec) , length(KoffVec)  );
tHm = zeros( length(nuVec), length(KDinvVec) , length(KoffVec)  );


for ii = 1:length(nuVec)
  for jj = 1:length(KDinvVec)
    for kk = 1:length(KoffVec)
      
      % Find index where flux passes half max
      indTemp = find( FluxVsT(ii,jj,kk,:) > jMax(ii,jj,kk) / 2, 1 );
      
      if indTemp == 1
        indTemp = 2;
      end
      djdtHm(ii,jj,kk) = ...
        ( FluxVsT(ii,jj,kk,indTemp) - FluxVsT(ii,jj,kk,indTemp - 1) ) ...
        ./ TimeObj.t_rec;
      tHm(ii,jj,kk) = TimeVec(indTemp);
      
    end
  end
end

%%
% Plot vs time
if plotvst_flag
  TimeVec = (0:TimeObj.N_rec-1) * t_rec;
  [Tr, Tc] =  size(TimeVec);
  
  % Plot Koffs vs time for each KdInv
  % Legend stuff
  legcell = cell( length(KoffVec) + 1, 1 );
  legcell{end} = 'No binding';
  for ii = 1:length(nuVec)
    
    for jj = 2:length(KDinvVec)
      figure();
      % Plot it
      AH1 = subplot(1,2,1);
      axis square
      hold all
      AH2 = subplot(1,2,2);
      axis square
      hold all
      for kk = 1:length(KoffVec)
        plot( AH1, TimeVec, reshape( FluxVsT(ii,jj,kk,:), [Tr Tc] ) );
        plot( AH2, TimeVec, reshape( AccumVsT(ii,jj,kk,:), [Tr Tc] ) );
        legcell{kk} = ['Koff = ' num2str( KoffVec(kk) ) ];
      end
      plot( AH1, TimeVec, reshape( FluxVsT(ii,1,1,:), [Tr Tc] ) );
      plot( AH2, TimeVec, reshape( AccumVsT(ii,1,1,:), [Tr Tc] ) );
      %Axis
      xlabel(AH1,'time'); xlabel(AH2,'time');
      ylabel(AH1,'flux'); ylabel(AH2,'accumultation');
      %   AH1.YLim = [ 0 1e-3 ]; AH2.YLim = [ 0 5e-4 ];
      % Titles
      titstr = sprintf('Kd^{-1} = %g (BA)', KDinvVec(jj) );
      title(AH1,titstr);
      titstr = sprintf('Dc/Da = %g', nuVec(ii) );
      title(AH2,titstr);
      h = legend(AH2,legcell,'location','best');
      h.Position(1:2) = [0.525 0.35];
      % Save stuff
      savestr_vts = [savestr_vt '_Kdinv' num2str(round(KDinvVec(jj)))...
        '_nu' num2str(nuVec(ii)) ];
      savefig( gcf, [savestr_vts '.fig'] );
      saveas( gcf, savestr_vts, 'jpg' );
    end
  end
end


%% Surface plot
if plotmap_flag
  
  deltaTick = 2;
  for ii = 1:length(nuVec)
    figure()
    
    % Flux Max
    imagesc( 1:length(KoffVec), 1:length(KDinvVec), ...
      reshape( jMax(ii,:,:), [length(KDinvVec) length(KoffVec) ] ) );
    xlabel( 'Koff'); ylabel('KdInv');
    Ax = gca;
    Ax.YTick = 1:deltaTick:length(KDinvVec);
    Ax.YTickLabel = num2cell( round( KDinvVec(1:deltaTick:end) ) );
    Ax.XTick = 1:deltaTick: length(KoffVec) ;
    Ax.XTickLabel = num2cell( round (KoffVec (1:deltaTick:end) ) );
    titstr = sprintf( 'Max Flux nu = %g', nuVec(ii) );
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
    imagesc( 1:length(KoffVec), 1:length(KDinvVec), ...
      reshape( djdtHm(ii,:,:), [length(KDinvVec) length(KoffVec) ] ) );
    xlabel( 'Koff'); ylabel('KdInv');
    Ax = gca;
    Ax.YTick = 1:deltaTick:length(KDinvVec);
    Ax.YTickLabel = num2cell( round( KDinvVec(1:deltaTick:end) ) );
    Ax.XTick = 1:deltaTick: length(KoffVec) ;
    Ax.XTickLabel = num2cell( round (KoffVec (1:deltaTick:end) ) );
    titstr = sprintf( 'Slope, dj/dt, at Half Max Flux nu = %g', nuVec(ii) );
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
    imagesc( 1:length(KoffVec), 1:length(KDinvVec), ...
      reshape( tHm(ii,:,:), [length(KDinvVec) length(KoffVec) ] ) );
    xlabel( 'Koff'); ylabel('KdInv');
    Ax = gca;
    Ax.YTick = 1:deltaTick:length(KDinvVec);
    Ax.YTickLabel = num2cell( round( KDinvVec(1:deltaTick:end) ) );
    Ax.XTick = 1:deltaTick: length(KoffVec) ;
    Ax.XTickLabel = num2cell( round (KoffVec (1:deltaTick:end) ) );
    titstr = sprintf( ' Time at Half Max Flux nu = %g', nuVec(ii) );
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
end % plot flag

%%
if saveMe
  save('fluxStuff.mat', 'FluxVsT', 'jMax', ...
    'djdtHm','tHm', 'nuVec','KDinvVec','KoffVec','TimeVec');
end
  
