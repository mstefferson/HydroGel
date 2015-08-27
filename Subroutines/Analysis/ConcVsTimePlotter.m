function [h] = ConcVsTimePlotter(A_rec, C_rec, T_rec,TimeRec,AL,CL,Bt,N,KD,nu)

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
h(1) = figure(1);
subplot(3,1,1)
plot(TimeRec,AL_time,TimeRec,AM_time,TimeRec,AR_time);
legend('Left end', 'Middle', 'Right end')
TitStr = sprintf('A: AL = %.1e CL = %.1e Bt = %.1e  KD = %.1e nu = %.1e',AL,CL,Bt,KD,nu);
xlabel('Time'); ylabel('[A]');title(TitStr);

subplot(3,1,2)
plot(TimeRec,CL_time,TimeRec,CM_time,TimeRec,CR_time);
legend('Left end', 'Middle', 'Right end')
TitStr = sprintf('C: AL = %.1e CL = %.1e Bt = %.1e  KD = %.1e nu = %.1e',AL,CL,Bt,KD,nu);
xlabel('Time'); ylabel('[C]');title(TitStr);


subplot(3,1,3)
plot(TimeRec,TL_time,TimeRec,TM_time,TimeRec,TR_time);
legend('Left end', 'Middle', 'Right end')
TitStr = sprintf('Total=[A]+[C] AL = %.1e CL = %.1e Bt = %.1e  KD = %.1e nu = %.1e',AL,CL,Bt,KD,nu);
xlabel('Time'); ylabel('[A] + [C]');title(TitStr);
