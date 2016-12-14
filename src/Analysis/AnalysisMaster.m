% Handles all of the analysis
function [RecObj] = AnalysisMaster( filename, SteadyState,  ...
  DidIBreak, Flux2ResR_rec, FluxAccum_rec, A_rec, C_rec,...
  analysisFlags, paramObj, flags, timeObj, GridObj, TimeRec)
% Strings
Paramstr = sprintf(' $$k_{on}B_t=$$ %.1g\n $$k_{on}B_t=$$ %.1g\n $$k_{off}=$$ %.1g\n $$D_A=$$ %.2g\n $$D_C=$$ %.2g\n',...
  paramObj.Kon*max(paramObj.Bt),paramObj.Kon,paramObj.Koff,paramObj.Da,paramObj.Dc);
Concstr = sprintf('$$B_t=$$ %.1g\n $$A_L=$$ %.1g\n $$A_R=$$ %.2g',...
  max(paramObj.Bt),paramObj.AL,paramObj.AR);
Gridstr = sprintf(' $$N_x=$$ %d\n $$L_{box}=$$ %.1f',GridObj.Nx,GridObj.Lbox);
% RecObj
RecObj.params = paramObj;
RecObj.A_rec = A_rec;
RecObj.C_rec = C_rec;
RecObj.Afinal = A_rec(:,end);
RecObj.Cfinal = C_rec(:,end);
RecObj.SteadyState = SteadyState;
RecObj.DidIBreak = DidIBreak;
RecObj.TimeRec = TimeRec;
RecObj.Flux2ResR_rec = Flux2ResR_rec;
RecObj.FluxAccum_rec = FluxAccum_rec;
% save things
if flags.SaveMe
  save([filename '.mat'],'paramObj','GridObj','timeObj','analysisFlags','RecObj')
end
% Make a movie of the concentrations
if analysisFlags.QuickMovie
  try
    videoName = ['concMov_' filename '.avi'];
    ConcenMovieMakerTgthr1D(videoName, A_rec, C_rec,...
      GridObj.x, TimeRec, timeObj.N_rec, paramObj.Nx, paramObj.Kon, paramObj.Koff,...
      paramObj.Dnl, paramObj.Da, paramObj.Dc, paramObj.Bt, paramObj.Ka, flags.SaveMe);
  catch err
  fprintf('Error running movies. There is some box size error I do not get\n')
  keyboard
  end
end
% Plot the flux of species a at the end of the gel and "accumulation"
% ---i.e., even if we have dirichlet BC, what the accumulation would be
% if A could leave the gel.
if analysisFlags.TrackAccumFromFluxPlot
  FluxA2resDirPlotter(...
    paramObj.AL,paramObj.Bt,paramObj.AR,A_rec(:,end),C_rec(:,end),paramObj.Dc,...
    paramObj.Lbox,GridObj.dx,TimeRec,...
    FluxAccum_rec,Flux2ResR_rec,Paramstr,Concstr,Gridstr)
  if flags.SaveMe
    savefig(gcf, ['FluxAndAccum_' filename '.fig'])
  end
end
% See if Particles are conserved. Only conserved for reservoirs and Von
% Neumann
if analysisFlags.CheckConservDen
  ConservCheckerAres(GridObj.x,A_rec,C_rec,TimeRec,paramObj.Lr)
end
% Plot accumulation
if analysisFlags.PlotMeAccum
  figure()
  plot(TimeRec,A_rec(end,:)/paramObj.AL )
  titstr = sprintf('Normalized concentration at the outlet/end of gel');
  xlabel('Time'); ylabel('A(x+L_{box}) / A_L');
  title(titstr)
end
% Plot wave from and accumulation
if analysisFlags.PlotMeWaveFrontAccum
  WavefrontAndAccumPlotter(A_rec,C_rec,GridObj.x,TimeRec,timeObj.N_rec,...
    timeObj.NumPlots,paramObj.Kon,paramObj.Koff,paramObj.Dc,paramObj.Dnl,...
    paramObj.AL,paramObj.Bt)
end
% Plot last concentration and accum
if analysisFlags.PlotMeLastConcAccum
  PlotLastConcAndAccum(...
    A_rec,C_rec,GridObj.x,Paramstr,Gridstr,Concstr,TimeRec,paramObj.trial)
end
% PLot last concentration
if analysisFlags.PlotMeLastConc
  PlotLastConc(...
    A_rec(:,end),C_rec(:,end),GridObj.x,Paramstr,...
    Gridstr,Concstr,paramObj.trial)
end

end

