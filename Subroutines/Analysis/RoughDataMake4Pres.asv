%%
trial = 5;
fileStr = sprintf('ConsNLNdFD_t%d.mat',trial);
[M_Allconc,M_Allflux,M_Allconcflux] = AnalysisFluxMov(fileStr);

%%
trial = 7;
fileStr = sprintf('ConsNLNdFD_t%d.mat',trial);
load(fileStr)
[JA_rec,JC_rec,JT_rec] = ...
    FluxCalc(A_rec,C_rec,AL,AR,CL,CR,ParamVec,N_rec,N,x_trim,ND);

 [h(1),hrhs] = FluxVsTimePlotter(JA_rec, JC_rec, JT_rec,TimeRec,AL,CL,Bt,N,ParamVec(1),ParamVec(2));
 h(2) = ConcVsTimePlotter(A_rec, C_rec, A_rec + A_rec,TimeRec,AL,CL,Bt,N,ParamVec(1),ParamVec(2));
 
 figstr = sprintf('FluxRHS_t%d.jpg',trial);
 saveas(hrhs,figstr)
 movefile(figstr,'C:\Users\MWS\Documents\Presentations\CoupChemDiff\')
 
%%

figure
movie(gca,M_Allconc)

%%
ResultsDir = 'C:\Users\MWS\Documents\Research\Hough\GrpMtg_18May';
DataDir = 'C:\Users\MWS\Documents\MATLAB\Research\Hough';

%%
moviestr = sprintf('Mconcflux_%d',trial);
avistr   = sprintf('%s.avi',moviestr);
movie2avi(M_Allconcflux,moviestr,'Compression','i420','fps',15)

%%
implay(avistr)

%%
 figstr = sprintf('x2vstNL3.jpg');
 saveas(gcf,figstr)
movefile(figstr,'C:\Users\MWS\Documents\Presentations\CoupChemDiff\')