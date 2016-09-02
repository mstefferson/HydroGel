function [RecObj] = AnalysisMaster( filename, SteadyState,  ...
  DidIBreak, Flux2ResR_rec, FluxAccum_rec, A_rec, C_rec,...
  analysisFlags, paramObj, flags, timeObj, GridObj, TimeRec)

% Strings
Paramstr = sprintf(' Kon=%.1g\n Koff=%.1g\n Bt = %.1g\n nu=%.2g\n',...
  paramObj.Kon,paramObj.Koff,paramObj.Bt,paramObj.Dc / paramObj.Da);
Concstr = sprintf('Bt=%.1g\nAL=%.1g\nAR=%.2g',...
  paramObj.Bt,paramObj.AL,paramObj.AR);
Gridstr = sprintf('Nx=%d\nLbox=%.1f',GridObj.Nx,GridObj.Lbox);

% RecObj
RecObj.A_rec = A_rec;
RecObj.C_rec = C_rec;
RecObj.Afinal = A_rec(:,end);
RecObj.Cfinal = C_rec(:,end);
RecObj.SteadyState = SteadyState;
RecObj.DidIBreak = DidIBreak;
RecObj.TimeRec = TimeRec;
RecObj.Flux2ResR_rec = Flux2ResR_rec;
RecObj.FluxAccum_rec = FluxAccum_rec;

if flags.SaveMe
  save([filename '.mat'],'paramObj','GridObj','timeObj','analysisFlags','RecObj')
end

% Make a movie of the concentrations
try
  if analysisFlags.QuickMovie
    if flags.SaveMe
      videoName = ['concMov_' filename '.avi'];
      ConcenMovieMakerTgthr1DAvi(videoName,A_rec, C_rec,...
        GridObj.x,TimeRec,timeObj.N_rec,paramObj.Kon,paramObj.Koff,...
        paramObj.Dnl,paramObj.Dc,paramObj.Bt,paramObj.Ka);
    else
      ConcenMovieMakerTgthr1D(A_rec, C_rec,...
        GridObj.x,TimeRec,timeObj.N_rec,paramObj.Nx,paramObj.Kon,paramObj.Koff,...
        paramObj.Dnl,paramObj.Dc,paramObj.Bt,paramObj.Ka);
    end
  end
catch
  fprintf('Error running movies. There is some box size error I do not get\n')
  
end

% Plot the flux of species a at the end of the gel and "accumulation"
% ---i.e., even if we have dirichlet BC, what the accumulation would be
% if A could leave the gel.
if analysisFlags.TrackAccumFromFluxPlot
  FluxA2resDirPlotter(...
    paramObj.AL,paramObj.Bt,paramObj.AR,A_rec(:,end),C_rec(:,end),paramObj.Dc,...
    paramObj.Lbox,GridObj.dx,TimeRec,...
    FluxAccum_rec,Flux2ResR_rec,Paramstr,Gridstr)
  if flags.SaveMe
    savefig(gcf, ['FluxAndAccum_' filename '.fig'])
  end
  
end

% See if Particles are conserved. Only conserved for reservoirs and Von
% Neumann
if analysisFlags.CheckConservDen
  ConservCheckerAres(GridObj.x,A_rec,C_rec,TimeRec,paramObj.Lr)
end

if analysisFlags.PlotMeAccum
  figure()
  plot(TimeRec,A_rec(end,:)/paramObj.AL )
  titstr = sprintf('Normalized concentration at the outlet/end of gel');
  xlabel('Time'); ylabel('A(x+L_{box}) / A_L');
  title(titstr)
end

if analysisFlags.PlotMeWaveFrontAccum
  WavefrontAndAccumPlotter(A_rec,C_rec,GridObj.x,TimeRec,timeObj.N_rec,...
    timeObj.NumPlots,paramObj.Kon,paramObj.Koff,paramObj.Dc,paramObj.Dnl,...
    paramObj.AL,paramObj.Bt)
end

if analysisFlags.PlotMeLastConcAccum
  PlotLastConcAndAccum(...
    A_rec,C_rec,GridObj.x,Paramstr,Gridstr,Concstr,TimeRec,paramObj.trial)
end

if analysisFlags.PlotMeLastConc
  PlotLastConc(...
    A_rec(:,end),C_rec(:,end),GridObj.x,Paramstr,...
    Gridstr,Concstr,paramObj.trial)
end

end

