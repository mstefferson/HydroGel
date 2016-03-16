function AnalysisMaster( SaveMe, SteadyState, DidIBreak, ...
    AnalysisObj,ParamObj, TimeRec, TimeObj, GridObj,...
    x,Paramstr,Gridstr,Concstr)
global A_rec;
global C_rec;
global FluxAccum_rec;
global Flux2ResR_rec;
% keyboard
if SaveMe
% RecObj
   RecObj = struct('A_rec', A_rec,'C_rec',C_rec,...
    'FluxAccum_rec',FluxAccum_rec,'Flux2ResR_rec',Flux2ResR_rec,...
    'TimeRec',TimeRec,'SteadyState',SteadyState);

    saveStr = sprintf('ConsDirVnNL%d_t%d',ParamObj.NLcoup,ParamObj.trial);
    save(saveStr,'ParamObj','GridObj','TimeObj','AnalysisObj','RecObj')
    
    ConcenMovieMakerTgthr1DAvi(A_rec, C_rec,...
        x,TimeRec,TimeObj.N_rec,ParamObj.Kon,ParamObj.Koff,...
        ParamObj.Dnl,ParamObj.Dc,ParamObj.Bt,ParamObj.KDinv);
    
    %     movefile('*.mat', OutputDir)
end


if AnalysisObj.QuickMovie
    ConcenMovieMakerTgthr1D(A_rec, C_rec,...
        x,TimeRec,TimeObj.N_rec,Nx,ParamObj.Kon,ParamObj.Koff,...
        ParamObj.Dnl,ParamObj.Dc,ParamObj.Bt,ParamObj.KDinv);
end

if AnalysisObj.TrackAccumFromFluxPlot
    AccumMax = 4.5e-3;
    FluxA2resDirPlotter(...
        ParamObj.AL,ParamObj.Bt,ParamObj.AR,v,Nx,ParamObj.Dc,...
        ParamObj.Lbox,dx,AccumMax,Flux2ResR,TimeRec,...
        FluxAccum_rec,Flux2ResR_rec,Paramstr,Gridstr)
end

if AnalysisObj.CheckConservDen
    ConservCheckerAres(x,A_rec,C_rec,TimeRec,ParamObj.Lr)
end

if AnalysisObj.PlotMeRightRes
    figure()
    %    ReservConcVsTimePlotter(TimeRec,A_rec,AllParamVec,trial)
    plot(TimeRec,A_rec(end,:)/ParamObj.AL )
    titstr = sprintf('Nx = %d Lbox = %.1f',Nx,ParamObj.Lbox);
    title(titstr)
end

if AnalysisObj.PlotMeMovAccum
    WavefrontAndAccumPlotter(A_rec,C_rec,x,TimeRec,TimeObj.N_rec,TimeObj.NumPlots,...
        ParamObj.Kon,ParamObj.Koff,ParamObj.Dc,ParamObj.Dnl,...
        ParamObj.AL,ParamObj.Bt)
end

if AnalysisObj.PlotMeLastConcAccum
    PlotLastConcAndAccum(...
        A_rec,C_rec,x,Paramstr,Gridstr,Concstr,TimeRec,ParamObj.trial)
end

if AnalysisObj.PlotMeLastConc
    PlotLastConc(...
        A_rec(:,end),C_rec(:,end),x,Paramstr,Gridstr,Concstr,ParamObj.trial)
end



end

