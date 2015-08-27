function ConcVsTimePlotUpdater(hax1,hax2,hax3,A_rec, C_rec, T_rec,TimeRec,N)

% Flux at the beginning, midpoint, end
AL_time = A_rec(:,1);
AM_time = A_rec(:,N/2);
AR_time = A_rec(:,end);

CL_time = C_rec(:,1);
CM_time = C_rec(:,N/2);
CR_time = C_rec(:,end);


TL_time = T_rec(:,1);
TM_time = T_rec(:,N/2);
TR_time = T_rec(:,end);

% Plot them
% keyboard

plot(hax1,TimeRec,AL_time,TimeRec,AM_time,TimeRec,AR_time);

plot(hax2,TimeRec,CL_time,TimeRec,CM_time,TimeRec,CR_time);

plot(hax3,TimeRec,TL_time,TimeRec,TM_time,TimeRec,TR_time);
