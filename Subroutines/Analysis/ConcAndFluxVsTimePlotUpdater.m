function ConcAndFluxVsTimePlotUpdater(hax1,hax2,hax3,hax4,...
    JT_rec,JTnorm_rec, T_rec, Tnorm_rec, TimeRec,N,trial)

% Flux at the beginning, midpoint, end
TL_time = T_rec(:,1);
TM_time = T_rec(:,N/2);
TR_time = T_rec(:,end);

TnormL_time = Tnorm_rec(:,1);
TnormM_time = Tnorm_rec(:,N/2);
TnormR_time = Tnorm_rec(:,end);

JtL_time = JT_rec(:,1);
JtM_time = JT_rec(:,N/2);
JtR_time = JT_rec(:,end);


JtNormL_time = JTnorm_rec(:,1);
JtNormM_time = JTnorm_rec(:,N/2);
JtNormR_time = JTnorm_rec(:,end);

% Plot them
% keyboard

% subplot(h,3,1,1)
% keyboard
plot(hax1,TimeRec,TL_time,TimeRec,TM_time,TimeRec,TR_time);
% text(mean(TimeRec),mean(TL_time),num2str(trial) )
% text(10,10,num2str(trial) )
plot(hax2,TimeRec,JtL_time,TimeRec,JtM_time,TimeRec,JtR_time);
% text(mean(TimeRec),mean(JtM_time),num2str(trial) )
plot(hax3,TimeRec,TnormL_time ,TimeRec,TnormM_time ,TimeRec,TnormR_time );
% text(mean(TimeRec),mean(TnormM_time),num2str(trial) )
plot(hax4,TimeRec,JtNormL_time,TimeRec,JtNormM_time,TimeRec,JtNormR_time);
% text(mean(TimeRec),mean(JtNormM_time),num2str(trial) )
