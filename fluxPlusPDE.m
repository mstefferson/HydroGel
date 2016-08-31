% LoopParamsFlux
% 
% Loops over parameter Kon*Bt (Bt fixed) and KoffVec 
% and calculates the max flux, slope, and time to half max

saveMe     = 0;
nuVec       = [1];
KonBtVec    = [  logspace(1,3,2) ];
KoffVec     = [  logspace(1,3,2)  ];
dt_fac   = 0.5;
savestr_vt = 'flxvst';
savestr_fm = ['flxmapSs'];
savematstr = 'fluxLin.mat';
plotvst_flag = 1;
plotmap_max_flag = 1;
plotmap_slope_flag = 1;
plotmap_time_flag = 1;

if plotmap_max_flag == 1 || plotmap_max_flag == 1 || plotmap_max_flag == 1;
  plotmap_flag = 1;
else
  plotmap_max_flag = 0;
end

% Add paths and see where we are
addpath('./Subroutines');
if ~exist('./Outputs','dir'); mkdir('Outputs'); end;
Time = datestr(now);
currentdir=pwd;
fprintf('In dir %s\n',currentdir);

fprintf('Starting Flux Loop: %s\n', Time)

% Initparams
fprintf('Initiating parameters\n');
if exist( 'initParams.m','file');
  initParams;
else
  cpParams
  initParams
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
FluxVsT = zeros( length(nuVec), length(KonBtVec) , length(KoffVec), TimeObj.N_rec );
AccumVsT = zeros( length(nuVec), length(KonBtVec) , length(KoffVec), TimeObj.N_rec );

% Run Diff first
Koff = 0;
Kon = 0;
dt = dtSave;

pVec(1) = 0;
pVec(2) = 0; 
pVec(3) = ParamObj.Bt;
pVec(4) = 0;

[RecObj] = ChemDiffMain('', ParamObj,TimeObj,AnalysisObj, pVec );
FluxVsTDiff = RecObj.Flux2ResR_rec;
AccumVsTDiff = RecObj.FluxAccum_rec;

% Hold Bt Steady
Bt = ParamObj.Bt;

for ii = 1:length(nuVec)
  ParamObj.Dc  = nuVec(ii);
  nu = ParamObj.Dc;
  fprintf('\n\n Starting nu = %g \n\n', ParamObj.Dc );
  for jj = 1:length(KonBtVec)
    Kon = KonBtVec(jj) / ParamObj.Bt;
    pVec(1) = Kon;
    fprintf('\n\n Starting Kon Bt = %f \n\n', KonBtVec(jj) );
    parfor kk = 1:length(KoffVec)
      Koff = KoffVec(kk);
     
      fprintf( 'Koff = %f Kon = %f\n',Koff,Kon );
      [RecObj] = ...
        ChemDiffMain('',ParamObj,TimeObj,AnalysisObj, [Kon Koff Bt nu]);
      
      if RecObj.DidIBreak == 1 || RecObj.SteadyState == 0
        fprintf('B = %d S = %d\n',RecObj.DidIBreak,RecObj.SteadyState)
      end
      
      FluxVsT(ii,jj,kk,:) = RecObj.Flux2ResR_rec;
      AccumVsT(ii,jj,kk,:) = RecObj.FluxAccum_rec;
    end
  end
end

%%
% Find Maxes and such
TimeVec = (0:TimeObj.N_rec-1) * t_rec;
jMax = FluxVsT(:,:,:,end);
aMax = AccumVsT(:,:,:,end);

djdtHm = zeros( length(nuVec), length(KonBtVec ) , length(KoffVec)  );
tHm = zeros( length(nuVec), length(KonBtVec ) , length(KoffVec)  );


for ii = 1:length(nuVec)
  for jj = 1:length(KonBtVec )
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
    
    for jj = 1:length(KonBtVec)
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
      plot( AH1, TimeVec, FluxVsTDiff);
      plot( AH2, TimeVec, AccumVsTDiff);
      %Axis
      xlabel(AH1,'time'); xlabel(AH2,'time');
      ylabel(AH1,'flux'); ylabel(AH2,'accumultation');
      %   AH1.YLim = [ 0 1e-3 ]; AH2.YLim = [ 0 5e-4 ];
      % Titles
      titstr = sprintf('Kon * Bt = %g (BA)', KonBtVec(jj) );
      title(AH1,titstr);
      titstr = sprintf('Dc/Da = %g', nuVec(ii) );
      title(AH2,titstr);
      h = legend(AH2,legcell,'location','best');
      h.Position(1:2) = [0.525 0.35];
      % Save stuff
      savestr_vts = [savestr_vt '_Kdinv' num2str(round(KonBtVec(jj)))...
        '_nu' num2str(nuVec(ii)) ];
      savefig( gcf, [savestr_vts '.fig'] );
      saveas( gcf, savestr_vts, 'jpg' );
    end
  end
end


%% Surface plot
if plotmap_flag
  
  deltaTick = 2;
  xstr = ' K_{off}  \tau ';
  ystr = ' K_{on}B_{t} \tau ';
  for ii = 1:length(nuVec)
    
    
    % Flux Max
    if plotmap_max_flag == 1
      figure()
      imagesc( 1:length(KoffVec), 1:length(KonBtVec), ...
        reshape( jMax(ii,:,:), [length(KonBtVec) length(KoffVec) ] ) );
      xlabel( xstr ); ylabel( ystr );
      Ax = gca;
      Ax.YTick = 1:deltaTick:length(KonBtVec);
      Ax.YTickLabel = num2cell( round( KonBtVec(1:deltaTick:end) ) );
      Ax.XTick = 1:deltaTick: length(KoffVec) ;
      Ax.XTickLabel = num2cell( round (KoffVec (1:deltaTick:end) ) );
      Ax.YDir = 'normal';
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
    end
    
    if plotmap_slope_flag == 1
      figure()
      % Slope at half max
      imagesc( 1:length(KoffVec), 1:length(KonBtVec), ...
        reshape( djdtHm(ii,:,:), [length(KonBtVec) length(KoffVec) ] ) );
      xlabel( xstr ); ylabel(  ystr );
      Ax = gca;
      Ax.YTick = 1:deltaTick:length(KonBtVec);
      Ax.YTickLabel = num2cell( round( KonBtVec(1:deltaTick:end) ) );
      Ax.XTick = 1:deltaTick: length(KoffVec) ;
      Ax.XTickLabel = num2cell( round (KoffVec (1:deltaTick:end) ) );
      Ax.YDir = 'normal';
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
    end
    
    if plotmap_time_flag == 1
      figure()
      % Time at half max
      imagesc( 1:length(KoffVec), 1:length(KonBtVec), ...
        reshape( tHm(ii,:,:), [length(KonBtVec) length(KoffVec) ] ) );
      xlabel( xstr ); ylabel( ystr );
      Ax = gca;
      Ax.YTick = 1:deltaTick:length(KonBtVec);
      Ax.YTickLabel = num2cell( round( KonBtVec(1:deltaTick:end) ) );
      Ax.XTick = 1:deltaTick: length(KoffVec) ;
      Ax.XTickLabel = num2cell( round (KoffVec (1:deltaTick:end) ) );
      Ax.YDir = 'normal';
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
    end
  end % loop nu
end % plot flag

%%
if saveMe
  save(savematstr, 'FluxVsT', 'jMax', ...
    'djdtHm','tHm', 'nuVec','KonBtVec','KoffVec','TimeVec');
end

