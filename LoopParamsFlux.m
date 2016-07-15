% Build vectors and matrices
%  KDinvVec = [0 logspace(3,4.5,12) ];
%  KoffVec = [ logspace(2,4,12) ];

% KDinvVec = [0 linspace(1e4 - 500,1e4 + 500,12) ];
% KoffVec = [ logspace(1e2 - 50, 1e2 + 50,12) ];
nu       = 1;
KDinvVec = [0 1e2 1e3 1e4 1e5 ];
KoffVec = [ 1e-1 1e0 1e1 1e2 1e3 ];
dt_fac   = 0.5;
savestr_vt = 'flxvst';
savestr_fa = ['flxaccummap'];
plotvst_flag = 0;
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

ParamObj.Dc    = nu; % Dc/Da

% "Analysis" subroutines
AnalysisObj.QuickMovie=0; AnalysisObj.TrackAccumFromFlux= 1;
AnalysisObj.TrackAccumFromFluxPlot=0; AnalysisObj.PlotMeLastConc=0;
AnalysisObj.PlotMeAccum=0; AnalysisObj.PlotMeWaveFrontAccum=0;
AnalysisObj.PlotMeLastConcAccum=0; AnalysisObj.CheckConservDen=0;
AnalysisObj.ShowRunTime=1;

% Build TimeObj
dt = dt * dt_fac;
[TimeObj] = TimeObjMakerRD(dt,t_tot,t_rec,ss_epsilon,NumPlots);

FileDir = sprintf('RdNx%dA%sC%st%d',...
  ParamObj.Nx,ParamObj.A_BC,ParamObj.C_BC,ParamObj.trial);
Where2SavePath    = sprintf('%s/%s/%s',pwd,'Outputs',FileDir);
% disp( max(dt * (Nx/Lbox)^2,nu * dt * (Nx/Lbox)^2) )

if ParamObj.SaveMe
  diary('RunDiary.txt')
end

% Display everything
fprintf('trial:%d A_BC: %s C_BC: %s\n', ...
  ParamObj.trial,ParamObj.A_BC, ParamObj.C_BC)
disp(ParamObj); disp(AnalysisObj); disp(TimeObj);

% Edits here. Change params and loop over
FluxVsT = zeros( length(KDinvVec) , length(KoffVec), TimeObj.N_rec );
AccumVsT = zeros( length(KDinvVec) , length(KoffVec), TimeObj.N_rec );

global Flux2ResR_rec;
global FluxAccum_rec;


for ii = 1:length(KDinvVec)
  ParamObj.KDinv = KDinvVec(ii);
  fprintf('\n\n Starting Kd = %f \n\n', ParamObj.KDinv );
  if ParamObj.KDinv == 0;
    ParamObj.Koff = 0;
    ParamObj.Kon = 0;
    [A,C,DidIBreak,SteadyState] = ChemDiffMain(ParamObj,TimeObj,AnalysisObj);
    FluxVsT(1,:,:) = repmat(Flux2ResR_rec,[length(KoffVec) 1] );
    AccumVsT(1,:,:) = repmat(FluxAccum_rec,[length(KoffVec) 1] );
  else
    for jj = 1:length(KoffVec)
      ParamObj.Koff = KoffVec(jj);
      ParamObj.Kon   = ParamObj.KDinv * ParamObj.Koff;
      fprintf( 'Koff = %f Kon = %f\n',ParamObj.Koff,ParamObj.Kon );
      [A,C,DidIBreak,SteadyState] = ChemDiffMain(ParamObj,TimeObj,AnalysisObj);
      fprintf('Break = %d Steady = %d\n',DidIBreak,SteadyState)
      FluxVsT(ii,jj,1:length( Flux2ResR_rec )) = Flux2ResR_rec;
      AccumVsT(ii,jj,1:length( Flux2ResR_rec )) = FluxAccum_rec;
      if SteadyState
        FluxVsT(ii,jj,length( Flux2ResR_rec ) + 1:TimeObj.N_rec) = ...
          Flux2ResR_rec(end);
        AccumVsT(ii,jj,length( Flux2ResR_rec ) + 1:TimeObj.N_rec) = ...
          FluxAccum_rec(end) + Flux2ResR_rec(end) * ...
          TimeObj.t_rec .* (1: TimeObj.N_rec -length( Flux2ResR_rec )  ) ;
      end
    end
  end
end

FluxMax = FluxVsT(:,:,end);
AccumMax = AccumVsT(:,:,end);

%% Plot time

% Plot vs time
if plotvst_flag
  TimeVec = (0:TimeObj.N_rec-1) * t_rec;
  [Tr, Tc] =  size(TimeVec);

  % Plot Koffs vs time for each KdInv
  for ii = 2:length(KDinvVec)
    figure()
    % Plot it
    AH1 = subplot(1,2,1);
    axis square
    hold all
    AH2 = subplot(1,2,2);
    axis square
    hold all
    for jj = 1:length(KoffVec)
      plot( AH1, TimeVec, reshape( FluxVsT(ii,jj,:), [Tr Tc] ) );
      plot( AH2, TimeVec, reshape( AccumVsT(ii,jj,:), [Tr Tc] ) );
    end
    plot( AH1, TimeVec, reshape( FluxVsT(1,1,:), [Tr Tc] ) );
    plot( AH2, TimeVec, reshape( AccumVsT(1,1,:), [Tr Tc] ) );
    %Axis
    xlabel(AH1,'time'); xlabel(AH2,'time');
    ylabel(AH1,'flux'); ylabel(AH2,'accumultation');
    %   AH1.YLim = [ 0 1e-3 ]; AH2.YLim = [ 0 5e-4 ];
    % Titles
    titstr = sprintf('Kd^{-1} = %g (BA)', KDinvVec(ii) );
    title(AH1,titstr);
    titstr = sprintf('Dc/Da = %g', ParamObj.Dc );
    title(AH2,titstr);
    % Legend stuff
    legcell = cell( length(KoffVec) + 1, 1 );
    for i = 1:length(KoffVec)
      legcell{i} = ['Koff = ' num2str( KoffVec(i) ) ];
    end
    legcell{end} = 'No binding';
    h = legend(AH2,legcell,'location','best');
    h.Position(1:2) = [0.525 0.35];
    % Save stuff
    savestr_vts = [savestr_vt '_Kdinv' num2str(round(KDinvVec(ii)))...
      '_nu' num2str(ParamObj.Dc/ParamObj.Da) ];
    savefig( gcf, [savestr_vts '.fig'] );
    saveas( gcf, savestr_vts, 'jpg' );
  end
end


%% Surface plot
if plotmap_flag
  figure()

  % Flux
  subplot(1,2,1);
  imagesc( 1:length(KoffVec), 1:length(KDinvVec),  FluxMax);
  xlabel( 'Koff'); ylabel('KdInv');
  Ax = gca;
  Ax.YTick = 1:length(KDinvVec);
  Ax.YTickLabel = num2cell( KDinvVec );
  Ax.XTick = 1: 2: length(KoffVec) ;
  Ax.XTickLabel = num2cell( round (KoffVec (1:2:end) ) );
  titstr = sprintf('Max Flux nu = %g',ParamObj.Dc);
  title(titstr)
  colorbar
  axis square

  % Accumulation
  subplot(1,2,2);
  imagesc( 1:length(KoffVec), 1:length(KDinvVec),  AccumMax);
  xlabel( 'Koff'); ylabel('KdInv');
  Ax = gca;
  Ax.YTick = 1:length(KDinvVec);
  Ax.YTickLabel = num2cell( KDinvVec );
  Ax.XTick = 1: 2: length(KoffVec) ;
  Ax.XTickLabel = num2cell( round (KoffVec (1:2:end) ) );
  titstr = sprintf('Max Accum nu = %g',ParamObj.Dc);
  title(titstr)
  colorbar
  axis square

  %%
  % Save stuff
  savefig( gcf, [savestr_fa  '_nu'...
    num2str(ParamObj.Dc/ParamObj.Da) '.fig'] );
  saveas( gcf, [ savestr_fa '_nu'...
    num2str(ParamObj.Dc/ParamObj.Da) ], 'jpg' );
end
