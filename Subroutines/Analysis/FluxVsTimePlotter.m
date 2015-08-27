function [h,hrhs] = ...
    FluxVsTimePlotter(JA_rec, JC_rec, JT_rec,TimeRec,AL,CL,Bt,N,KDinv,nu)

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
h(1) = figure(2);
subplot(3,1,1)
plot(TimeRec,JaL_time,TimeRec,JaM_time,TimeRec,JaR_time);
legend('Left end', 'Middle', 'Right end')
TitStr = sprintf('A: AL = %.1e CL = %.1e Bt = %.1e KD = %.1e nu = %.1e',AL,CL,Bt,KDinv,nu);
xlabel('Time'); ylabel('J_A');title(TitStr);

subplot(3,1,2)
plot(TimeRec,JcL_time,TimeRec,JcM_time,TimeRec,JcR_time);
legend('Left end', 'Middle', 'Right end')
TitStr = sprintf('C: AL = %.1e CL = %.1e Bt = %.1e KD = %.1e nu = %.1e',AL,CL,Bt,KDinv,nu);
xlabel('Time'); ylabel('J_C');title(TitStr);


subplot(3,1,3)
plot(TimeRec,JtL_time,TimeRec,JtM_time,TimeRec,JtR_time);
legend('Left end', 'Middle', 'Right end')
TitStr = sprintf('Flux Total=A+C AL = %.1e CL = %.1e Bt = %.1e KD = %.1e nu = %.1e',AL,CL,Bt,KDinv,nu);
xlabel('Time'); ylabel('J_T');title(TitStr);

hrhs = figure(3);
plot(TimeRec,JaR_time,TimeRec,JcR_time,TimeRec,JtR_time)
legend('A','C','A+C','Location','best')
titlestr = sprintf('Flux at right hand boundary nu = %.2e KDinv = %.2e',...
    nu,KDinv);
title(titlestr);xlabel('time'); ylabel('flux')
