function [M_Allconc,M_Allflux,M_Allconcflux] = AnalysisFluxMov(ConcRecs)

close all
% Load everything
load(ConcRecs)
% keyboard
CurrDir  = pwd;
% keyboard
% Calculate fluxes
[JA_rec,JC_rec,JT_rec] = ...
    FluxCalc(A_rec,C_rec,AL,AR,CL,CR,ParamVec,N_rec,N,x_trim,ND);

% keyboard
%Make movie

if ND
    [M_Allconc] = ...
        ConcenMovieMakerNd1D(A_rec, Alin,C_rec, Clin,B_rec,Bt,x_trim,TimeRec,N_rec,N,ParamVec);
    
    [M_Allflux] = ...
        FluxMovieMakerNd1D(JA_rec, JC_rec, JT_rec,Bt,x_trim,TimeRec,N_rec,N,ParamVec,L_box);
    
    [M_Allconcflux] = ...
        ConcenFluxMovieMakerNd1D(A_rec, Alin,C_rec, Clin,JA_rec,JC_rec,JT_rec,Bt,...
        x_trim,TimeRec,N_rec,N,ParamVec,L_box);
    
else
    [M_Allconc] = ...
        ConcenMovieMaker1D(A_rec, Alin,C_rec, Clin,B_rec,Bt,x_trim,TimeRec,N_rec,N,ParamVec);
    
    % keyboard
    [M_Allflux] = ...
        FluxMovieMaker1D(JA_rec, JC_rec, JT_rec,Bt,x_trim,TimeRec,N_rec,N,ParamVec);
    
    [M_Allconcflux] = ...
        ConcenFluxMovieMaker1D(A_rec, Alin,C_rec, Clin,JA_rec,JC_rec,JT_rec,Bt,...
        x_trim,TimeRec,N_rec,N,ParamVec);
end

% Plot flux and concentration
if ND
    h(1) = FluxVsTimePlotter(JA_rec, JC_rec, JT_rec,TimeRec,AL,CL,Bt,N,ParamVec(1),ParamVec(2));
    h(2) = ConcVsTimePlotter(A_rec, C_rec, A_rec + A_rec,TimeRec,AL,CL,Bt,N,ParamVec(1),ParamVec(2));
else
    h(1) = ...
        FluxVsTimePlotter(JA_rec, JC_rec, JT_rec,TimeRec,AL,CL,Bt,N,...
                           ParamVec(2)/ParamVec(1),ParamVec(3)/ParamVec(4));
    h(2) = ...
        ConcVsTimePlotter(A_rec, C_rec, A_rec + A_rec,TimeRec,AL,CL,Bt,N,...
                          ParamVec(2)/ParamVec(1),ParamVec(3)/ParamVec(4));
end
ResultsStr = sprintf('%sMovies%s',ConcRecs(1:end-4),ConcRecs(end-3:end));
FigStr     = sprintf('%sFig',ConcRecs(1:end-4));


% keyboard
copyfile(ConcRecs,'C:\Users\MWS\Documents\Research\Hough\AnalyzedResults')
cd('C:\Users\MWS\Documents\Research\Hough\AnalyzedResults')
savefig(h,FigStr);
save(ResultsStr,'M_Allconc','M_Allflux','M_Allconcflux')

cd(CurrDir)
% keyboard

end