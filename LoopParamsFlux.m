% Build vectors and matrices
KDinvVec = [0 1e1 1e4];
KoffVec = [1e-2 1e-1 1e0 1e1];
FluxVsT = zeros( length(KDinvVec) , length(KoffVec), TimeObj.N_rec );
AccumVsT = zeros( length(KDinvVec) , length(KoffVec), TimeObj.N_rec );

% Add paths and see where we are
addpath('./Subroutines');
if ~exist('./Outputs','dir'); mkdir('Outputs'); end;
Time = datestr(now);
currentdir=pwd;
fprintf('In dir %s\n',currentdir);

fprintf('Starting RunHydroGel: %s\n', Time)

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
AnalysisObj.ShowRunTime=1;  

% Build TimeObj
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
      FluxVsT(ii,jj,:) = Flux2ResR_rec;
      AccumVsT(ii,jj,:) = FluxAccum_rec;
      fprintf('Break = %d Steady = %d\n',DidIBreak,SteadyState)
    end
  end
end
      
FluxMax = FluxVsT(:,:,end);
AccumMax = AccumVsT(:,:,end);

% Plot time
TimeVec = (0:TimeObj.N_rec-1) * t_rec;
[Tr, Tc] =  size(TimeVec);

% Plot Koffs vs time for each KdInv
for ii = 2:length(KDinvVec)
  figure()
  hold all

  for jj = 1:length(KoffVec)
    plotyy( TimeVec, reshape( FluxVsT(ii,jj,:), [Tr Tc] ),...
      TimeVec, reshape( AccumVsT(ii,jj,:), [Tr Tc] ) );
  end
  plotyy( TimeVec, reshape( FluxVsT(1,1,:), [Tr Tc] ),...
    TimeVec, reshape( AccumVsT(1,1,:), [Tr Tc] ) );
  xlabel('time'); ylabel('flux');
  titstr = sprintf('Kd^{-1} = %g (Binding Affinity)', KDinvVec(ii) );
  title(titstr);
  Ax = gca;
  Ax.YLim = [ 0 1e-3 ];

  legcell = cell( length(KoffVec) + 1, 1 );
  for i = 1:length(KoffVec)
   legcell{i} = ['Koff = ' num2str( KoffVec(i) ) ];
  end
  legcell{end} = 'No binding';
  legend(legcell,'location','best');

end

% Surface plot
figure()
imagesc( 1:length(KoffVec), 1:length(KDinvVec),  FluxMax);
xlabel( 'Koff'); ylabel('KdInv');
Ax = gca;
Ax.YTick = 1:length(KDinvVec);
Ax.YTickLabel = num2cell( KDinvVec );
Ax.XTick = 1:length(KoffVec);
Ax.XTickLabel = num2cell( KoffVec );
title('Max Flux')
colorbar

% Surface plot
figure()
imagesc( 1:length(KoffVec), 1:length(KDinvVec),  AccumMax);
xlabel( 'Koff'); ylabel('KdInv');
Ax = gca;
Ax.YTick = 1:length(KDinvVec);
Ax.YTickLabel = num2cell( KDinvVec );
Ax.XTick = 1:length(KoffVec);
Ax.XTickLabel = num2cell( KoffVec );
title('Max Accum')
colorbar