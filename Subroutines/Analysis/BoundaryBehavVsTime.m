%%
% close all
% load('ConsNLNdFDext_t5.mat')
PlotFlux = 0;
PlotConc = 1;

if PlotFlux
Nt = Nl + Nm + Nr;
 [JA_rec,JC_rec,JT_rec] = ...
    FluxCalcExt(A_rec,C_rec,ParamVec,N_rec,Nt,dxl,dxm,dxr,L,R,LBind,RBind);

figure()
subplot(2,1,1)
plot(TimeRec,[JA_rec(:,LBind-1), JA_rec(:,LBind), JC_rec(:,LBind-1), JC_rec(:,LBind)])
title('Flux Left Boundary');xlabel('TimeRec');ylabel('Flux');
legend('Aleft','Aright','Cleft','Cright','Location','best')

subplot(2,1,2)
plot(TimeRec,[JA_rec(:,RBind-1), JA_rec(:,RBind), JC_rec(:,RBind-1), JC_rec(:,RBind)])
title('Flux Right Boundary'); xlabel('TimeRec');ylabel('Flux');
legend('Aleft','Aright','Cleft','Cright','Location','best')

end

if PlotConc
figure()
subplot(2,1,1)
plot(TimeRec,...
    [A_rec(:,LBind-1), A_rec(:,LBind), A_rec(:,LBind+1) ...
     A_rec(:,RBind-1), A_rec(:,RBind), A_rec(:,RBind+1)])
title('[A]'); xlabel('TimeRec');ylabel('Concentration');
legend('LB-1','LB','LB+1','RB-1','RB','RB+1','Location','best')

subplot(2,1,2)
plot(TimeRec,...
    [C_rec(:,LBind-1), C_rec(:,LBind), C_rec(:,LBind+1) ...
     C_rec(:,RBind-1), C_rec(:,RBind), C_rec(:,RBind+1)])
title('[C]'); xlabel('TimeRec');ylabel('Concentration');
legend('LB-1','LB','LB+1','RB-1','RB','RB+1','Location','best')
end