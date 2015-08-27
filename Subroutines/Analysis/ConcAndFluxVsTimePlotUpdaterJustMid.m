function ConcAndFluxVsTimePlotUpdaterJustMid(hax1,hax2,hax3,hax4,...
    JT_rec,JTnorm_rec, T_rec, Tnorm_rec, TimeRec,N,trial,ColorVec)

% Flux at the beginning, midpoint, end
TM_time = T_rec(:,N/2);

TnormM_time = Tnorm_rec(:,N/2);

JtM_time = JT_rec(:,N/2);

JtNormM_time = JTnorm_rec(:,N/2);


% Plot them
% keyboard
% figure()
% plot(TimeRec,TM_time);
% text(mean(TimeRec),mean(TM_time),num2str(trial) )

% subplot(h,3,1,1)
% keyboard
% ColorVec = [rand() rand() rand()];
plot(hax1,TimeRec,TM_time,'Color', ColorVec);
% text(mean(TimeRec),mean(TM_time),num2str(trial) )
% text(10,10,num2str(trial) )
plot(hax2,TimeRec,JtM_time,'Color', ColorVec);
% text(mean(TimeRec),mean(JtM_time),num2str(trial) )
plot(hax3,TimeRec,TnormM_time,'Color', ColorVec);
% text(mean(TimeRec),mean(TnormM_time),num2str(trial) )
plot(hax4,TimeRec,JtNormM_time,'Color', ColorVec);
% text(mean(TimeRec),mean(JtNormM_time),num2str(trial) )
