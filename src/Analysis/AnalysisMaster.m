
% Handles all of the analysis
function [recObj] = AnalysisMaster( filename, runSave, ...
  A_rec, C_rec, Flux2Res_rec, FluxAccum_rec,...
  Afinal, Cfinal, SteadyState, DidIBreak, ...
  analysisFlags, paramObj, flags, timeObj, GridObj, TimeRec)
% Strings
paramStr = sprintf(' $$k_{on}B_t=$$ %.1g\n $$k_{on} =$$ %.1g\n $$k_{off}=$$ %.1g\n $$D_A=$$ %.2g\n $$D_C=$$ %.2g\n',...
  paramObj.Kon(1)*max(paramObj.Bt),paramObj.Kon(1),...
  paramObj.Koff(1),paramObj.Da,paramObj.Dc(1));
concStr = sprintf('$$B_t=$$ %.1g\n $$A_L=$$ %.1g\n $$A_R=$$ %.2g',...
  max(paramObj.Bt),paramObj.AL,paramObj.AR);
gridStr = sprintf(' $$N_x=$$ %d\n $$L_{box}=$$ %.1f',GridObj.Nx,GridObj.Lbox);
% RecObj
recObj.Params = paramObj;
recObj.Afinal = Afinal;
recObj.Cfinal = Cfinal;
recObj.SteadyState = SteadyState;
recObj.DidIBreak = DidIBreak;
recObj.TimeRec = TimeRec;
recObj.A_rec = A_rec;
recObj.C_rec = C_rec;
recObj.Flux2Res_rec = Flux2Res_rec;
recObj.FluxAccum_rec = FluxAccum_rec;

% save things
if flags.SaveMe
  runSave.recObj = recObj;
end

% Make a movie of the concentrations
if analysisFlags.QuickMovie
  try
    videoName = ['concMov_' filename '.avi'];
    ConcenMovieMakerTgthr1D(videoName, A_rec, C_rec, paramObj.Bt,...
      GridObj.x, TimeRec, paramStr, gridStr, concStr, flags.SaveMe);
  catch err
    fprintf('Error writing video\n')
    fprintf('%s',err.getReport('extended') );
  end
end
% Plot the flux of species a at the end of the gel and "accumulation"
% ---i.e., even if we have dirichlet BC, what the accumulation would be
% if A could leave the gel.
if analysisFlags.PlotAccumFlux
  FluxA2resDirPlotter(...
    paramObj.AL,paramObj.Bt,paramObj.AR,recObj.Afinal,recObj.Cfinal,paramObj.Dc,...
    paramObj.Lbox,GridObj.dx,TimeRec,...
    FluxAccum_rec,Flux2Res_rec,paramStr,concStr,gridStr)
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
  xlabel('Time $$ t $$'); ylabel('$$ A(x=L_{box}) / A_L $$');
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
    A_rec,C_rec,GridObj.x,paramStr,gridStr,concStr,TimeRec,paramObj.trial)
end
% PLot last concentration
if analysisFlags.PlotMeLastConc
  gridStrOneLine = sprintf(' $$N_x=$$ %d $$L_{box}=$$ %.1f',GridObj.Nx,GridObj.Lbox);
  PlotLastConc(...
    A_rec(:,end),C_rec(:,end),GridObj.x,paramStr,...
    gridStrOneLine,concStr)
end
end

