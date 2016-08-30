function [RecObj] = AnalysisMaster( filename, SteadyState,  ...
 DidIBreak, Flux2ResR_rec, FluxAccum_rec, A_rec, C_rec,...
  AnalysisObj, ParamObj, TimeRec, TimeObj, GridObj,...
  Paramstr,Gridstr,Concstr)

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

if ParamObj.SaveMe
  save(filename,'ParamObj','GridObj','TimeObj','AnalysisObj','RecObj')
end

% Make a movie of the concentrations
try
  if AnalysisObj.QuickMovie
    if ParamObj.SaveMe
      videoName = ['concMov_' filename '.avi'];
      ConcenMovieMakerTgthr1DAvi(videoName,A_rec, C_rec,...
        GridObj.x,TimeRec,TimeObj.N_rec,ParamObj.Kon,ParamObj.Koff,...
        ParamObj.Dnl,ParamObj.Dc,ParamObj.Bt,ParamObj.Ka);
    else
      ConcenMovieMakerTgthr1D(A_rec, C_rec,...
        GridObj.x,TimeRec,TimeObj.N_rec,ParamObj.Nx,ParamObj.Kon,ParamObj.Koff,...
        ParamObj.Dnl,ParamObj.Dc,ParamObj.Bt,ParamObj.Ka);
    end   
  end
catch
  fprintf('Error running movies. There is some box size error I do not get\n')
  
end

% Plot the flux of species a at the end of the gel and "accumulation"
% ---i.e., even if we have dirichlet BC, what the accumulation would be
% if A could leave the gel.
if AnalysisObj.TrackAccumFromFluxPlot
  FluxA2resDirPlotter(...
    ParamObj.AL,ParamObj.Bt,ParamObj.AR,A_rec(:,end),C_rec(:,end),ParamObj.Dc,...
    ParamObj.Lbox,GridObj.dx,TimeRec,...
    FluxAccum_rec,Flux2ResR_rec,Paramstr,Gridstr)
    if ParamObj.SaveMe
      savefig(gcf, ['FluxAndAccum_' filename '.fig'])
    end
  
end

% See if Particles are conserved. Only conserved for reservoirs and Von
% Neumann
if AnalysisObj.CheckConservDen
  ConservCheckerAres(GridObj.x,A_rec,C_rec,TimeRec,ParamObj.Lr)
end

if AnalysisObj.PlotMeAccum
  figure()
  plot(TimeRec,A_rec(end,:)/ParamObj.AL )
  titstr = sprintf('Normalized concentration at the outlet/end of gel');
  xlabel('Time'); ylabel('A(x+L_{box}) / A_L');
  title(titstr)
end

if AnalysisObj.PlotMeWaveFrontAccum
  WavefrontAndAccumPlotter(A_rec,C_rec,GridObj.x,TimeRec,TimeObj.N_rec,...
    TimeObj.NumPlots,ParamObj.Kon,ParamObj.Koff,ParamObj.Dc,ParamObj.Dnl,...
    ParamObj.AL,ParamObj.Bt)
end

if AnalysisObj.PlotMeLastConcAccum
  PlotLastConcAndAccum(...
    A_rec,C_rec,GridObj.x,Paramstr,Gridstr,Concstr,TimeRec,ParamObj.trial)
end

if AnalysisObj.PlotMeLastConc
  PlotLastConc(...
    A_rec(:,end),C_rec(:,end),GridObj.x,Paramstr,...
    Gridstr,Concstr,ParamObj.trial)
end

end

