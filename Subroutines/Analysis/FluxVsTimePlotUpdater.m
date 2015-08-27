function FluxVsTimePlotUpdater(hax1,hax2,hax3,JA_rec, JC_rec, JT_rec,TimeRec,N)

% Flux at the beginning, midpoint, end
JaL_time = JA_rec(:,1);
JaM_time = JA_rec(:,N/2);
JaR_time = JA_rec(:,end);

JcL_time = JC_rec(:,1);
JcM_time = JC_rec(:,N/2);
JcR_time = JC_rec(:,end);


JtL_time = JT_rec(:,1);
JtM_time = JT_rec(:,N/2);
JtR_time = JT_rec(:,end);

% Plot them
% keyboard

% subplot(h,3,1,1)
plot(hax1,TimeRec,JaL_time,TimeRec,JaM_time,TimeRec,JaR_time);


plot(hax2,TimeRec,JcL_time,TimeRec,JcM_time,TimeRec,JcR_time);



plot(hax3,TimeRec,JtL_time,TimeRec,JtM_time,TimeRec,JtR_time);
