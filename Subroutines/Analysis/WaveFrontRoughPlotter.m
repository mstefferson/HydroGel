
%%
%%
load('ConsNLNdFD_t10.mat') %KD = 1e-6 nu = 0.01
[xDesVsTime10,DesCon10] = WaveFrontTracker(A_rec+C_rec,TimeRec,x_trim,0);
load('ConsNLNdFD_t12.mat') %KD = 1e-4 nu = 0.01
[xDesVsTime12,DesCon12] = WaveFrontTracker(A_rec+C_rec,TimeRec,x_trim,0);
load('ConsNLNdFD_t13.mat') %KD = 1e-6 nu = 0
[xDesVsTime13,DesCon13] = WaveFrontTracker(A_rec+C_rec,TimeRec,x_trim,0);
load('ConsNLNdFD_t15.mat') %KD = 1e-4 nu = 0
[xDesVsTime15,DesCon15] = WaveFrontTracker(A_rec+C_rec,TimeRec,x_trim,0);
load('ConsNLNdFD_t30.mat') %KD = 1e-4 nu = 0
[xDesVsTime30,DesCon30] = WaveFrontTracker(A_rec+C_rec,TimeRec,x_trim,0);

% DesCon10-DesCon13
figure
plot(TimeRec,xDesVsTime10.^2,TimeRec,xDesVsTime12.^2,...
    TimeRec,xDesVsTime13.^2,TimeRec,xDesVsTime15.^2,...
    TimeRec,xDesVsTime30.^2)
xlabel('Time'); ylabel('x^2'); title('wavefront displacement')
legend('KD = 1e-6 nu = 0.01','KD = 1e-4 nu = 0.01',...
    'KD = 1e-6 nu = 0','KD = 1e-4 nu = 0', 'No chem', 'Location','best')


%%
load('ConsNLNdFD_t10.mat') %KD = 1e-6 nu = 0.01
[xDesVsTime10,DesCon10] = WaveFrontTracker(A_rec,TimeRec,x_trim,0);
load('ConsNLNdFD_t12.mat') %KD = 1e-4 nu = 0.01
[xDesVsTime12,DesCon12] = WaveFrontTracker(A_rec,TimeRec,x_trim,0);
load('ConsNLNdFD_t13.mat') %KD = 1e-6 nu = 0
[xDesVsTime13,DesCon13] = WaveFrontTracker(A_rec,TimeRec,x_trim,0);
load('ConsNLNdFD_t15.mat') %KD = 1e-4 nu = 0
[xDesVsTime15,DesCon15] = WaveFrontTracker(A_rec,TimeRec,x_trim,0);
load('ConsNLNdFD_t30.mat') %KD = 1e-4 nu = 0
[xDesVsTime30,DesCon30] = WaveFrontTracker(A_rec,TimeRec,x_trim,0);

% DesCon10-DesCon13

plot(TimeRec,xDesVsTime10.^2,TimeRec,xDesVsTime12.^2,...
    TimeRec,xDesVsTime13.^2,TimeRec,xDesVsTime15.^2,...
    TimeRec,xDesVsTime30.^2)
xlabel('Time'); ylabel('x^2'); title('wavefront displacement')
legend('KD = 1e-6 nu = 0.01','KD = 1e-4 nu = 0.01',...
    'KD = 1e-6 nu = 0','KD = 1e-4 nu = 0', 'No chem', 'Location','best')


%%
load('ConsNLNdFD_t10.mat') %KD = 1e-6 nu = 0.01
[xDesVsTime10,DesCon10] = WaveFrontTracker(C_rec,TimeRec,x_trim,0);
load('ConsNLNdFD_t12.mat') %KD = 1e-4 nu = 0.01
[xDesVsTime12,DesCon12] = WaveFrontTracker(C_rec,TimeRec,x_trim,0);
load('ConsNLNdFD_t13.mat') %KD = 1e-6 nu = 0
[xDesVsTime13,DesCon13] = WaveFrontTracker(C_rec,TimeRec,x_trim,0);
load('ConsNLNdFD_t15.mat') %KD = 1e-4 nu = 0
[xDesVsTime15,DesCon15] = WaveFrontTracker(C_rec,TimeRec,x_trim,0);
load('ConsNLNdFD_t30.mat') %KD = 1e-4 nu = 0
[xDesVsTime30,DesCon30] = WaveFrontTracker(C_rec,TimeRec,x_trim,0);

% DesCon10-DesCon13

plot(TimeRec,xDesVsTime10.^2,TimeRec,xDesVsTime12.^2,...
    TimeRec,xDesVsTime13.^2,TimeRec,xDesVsTime15.^2,...
    TimeRec,xDesVsTime30.^2)
xlabel('Time'); ylabel('x^2'); title('wavefront displacement')
legend('KD = 1e-6 nu = 0.01','KD = 1e-4 nu = 0.01',...
    'KD = 1e-6 nu = 0','KD = 1e-4 nu = 0', 'No chem', 'Location','best')


%%
%% NL%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bt = 2e-4 Al = 2e-4
load('ConsNLNdFD_t50.mat') %No chemistry
[xDesVsTime50,DesCon50] = WaveFrontTracker(A_rec+C_rec,TimeRec,x_trim,0);
load('ConsNLNdFD_t51.mat') %KD = 1e-3 nu = 0
[xDesVsTime51,DesCon51] = WaveFrontTracker(A_rec+C_rec,TimeRec,x_trim,0);
load('ConsNLNdFD_t52.mat') %KD = 1e-5 nu = 0
[xDesVsTime52,DesCon52] = WaveFrontTracker(A_rec+C_rec,TimeRec,x_trim,0);
load('ConsNLNdFD_t53.mat') %KD = 1e-5 nu = 0
[xDesVsTime53,DesCon53] = WaveFrontTracker(A_rec+C_rec,TimeRec,x_trim,0);
load('ConsNLNdFD_t54.mat') %KD = 1e-6 nu = 0
[xDesVsTime54,DesCon54] = WaveFrontTracker(A_rec+C_rec,TimeRec,x_trim,0);
load('ConsNLNdFD_t55.mat') %KD = 1e-6 nu = 0
[xDesVsTime55,DesCon55] = WaveFrontTracker(A_rec+C_rec,TimeRec,x_trim,0);
load('ConsNLNdFD_t56.mat') %KD = 1e-6 nu = 0
[xDesVsTime56,DesCon56] = WaveFrontTracker(A_rec+C_rec,TimeRec,x_trim,0);



% DesCon10-DesCon13
figure
plot(TimeRec,xDesVsTime50.^2,TimeRec,xDesVsTime51.^2,...
    TimeRec,xDesVsTime52.^2,TimeRec,xDesVsTime53.^2,...
    TimeRec,xDesVsTime54.^2,TimeRec,xDesVsTime55.^2,TimeRec,xDesVsTime56.^2)
xlabel('Time'); ylabel('x^2'); title('wavefront displacement')
legend('No chem','KD = 1e-1 nu = 0','KD = 1e-2 nu = 0',...
    'KD = 1e-3 nu = 0','KD = 1e-4 nu = 0',  'Location','best')



%% NL%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bt = 2e-2 Al = 2e-5
load('ConsNLNdFD_t40.mat') %No chemistry
[xDesVsTime40,DesCon40] = WaveFrontTracker(A_rec+C_rec,TimeRec,x_trim,0);
load('ConsNLNdFD_t41.mat') %KD = 1e-3 nu = 0
[xDesVsTime41,DesCon41] = WaveFrontTracker(A_rec+C_rec,TimeRec,x_trim,0);
load('ConsNLNdFD_t42.mat') %KD = 1e-4 nu = 0
[xDesVsTime42,DesCon42] = WaveFrontTracker(A_rec+C_rec,TimeRec,x_trim,0);
load('ConsNLNdFD_t43.mat') %KD = 1e-5 nu = 0
[xDesVsTime43,DesCon43] = WaveFrontTracker(A_rec+C_rec,TimeRec,x_trim,0);
load('ConsNLNdFD_t44.mat') %KD = 1e-6 nu = 0
[xDesVsTime44,DesCon44] = WaveFrontTracker(A_rec+C_rec,TimeRec,x_trim,0);


% DesCon10-DesCon13

plot(TimeRec,xDesVsTime40.^2,TimeRec,xDesVsTime41.^2,...
    TimeRec,xDesVsTime42.^2,TimeRec,xDesVsTime43.^2,...
    TimeRec,xDesVsTime44.^2)
xlabel('Time'); ylabel('x^2'); title('wavefront displacement')
legend('No chem','KD = 1e-3 nu = 0','KD = 1e-4 nu = 0',...
    'KD = 1e-5 nu = 0','KD = 1e-6 nu = 0.',  'Location','best')



%% LINEAR LINEAR%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
% Bt = 2e-2 Al = 2e-5
load('ConsLinNdFD_t40.mat') %No chemistry
[xDesVsTime40,DesCon40] = WaveFrontTracker(A_rec+C_rec,TimeRec,x_trim,0);
load('ConsLinNdFD_t41.mat') %KD = 1e-3 nu = 0.01
[xDesVsTime41,DesCon41] = WaveFrontTracker(A_rec+C_rec,TimeRec,x_trim,0);
load('ConsLinNdFD_t42.mat') %KD = 1e-4 nu = 0.01
[xDesVsTime42,DesCon42] = WaveFrontTracker(A_rec+C_rec,TimeRec,x_trim,0);
load('ConsLinNdFD_t43.mat') %KD = 1e-5 nu = 0.01
[xDesVsTime43,DesCon43] = WaveFrontTracker(A_rec+C_rec,TimeRec,x_trim,0);
load('ConsLinNdFD_t44.mat') %KD = 1e-6 nu = 0.01
[xDesVsTime44,DesCon44] = WaveFrontTracker(A_rec+C_rec,TimeRec,x_trim,0);


% DesCon10-DesCon13

plot(TimeRec,xDesVsTime40.^2,TimeRec,xDesVsTime41.^2,...
    TimeRec,xDesVsTime42.^2,TimeRec,xDesVsTime43.^2,...
    TimeRec,xDesVsTime44.^2)
xlabel('Time'); ylabel('x^2'); title('wavefront displacement')
legend('No chem','KD = 1e-3 nu = 0','KD = 1e-4 nu = 0',...
    'KD = 1e-5 nu = 0','KD = 1e-6 nu = 0.',  'Location','best')


%% Linear Bt = 2e-2 Al = 2e-5
%%
load('ConsLinNdFD_t45.mat') %KD = No chem nu = 0.01
[xDesVsTime45,DesCon45] = WaveFrontTracker(A_rec+C_rec,TimeRec,x_trim,0.5,0);

load('ConsLinNdFD_t46.mat') %KD = 1e-1 nu = 0.01
[xDesVsTime46,DesCon46] = WaveFrontTracker(A_rec+C_rec,TimeRec,x_trim,0.5,0);

load('ConsLinNdFD_t47.mat') %KD = 1e-2 nu = 0.01
[xDesVsTime47,DesCon47] = WaveFrontTracker(A_rec+C_rec,TimeRec,x_trim,0.5,0);

load('ConsLinNdFD_t48.mat') %KD = 1e-3 nu = 0.01
[xDesVsTime48,DesCon48] = WaveFrontTracker(A_rec+C_rec,TimeRec,x_trim,0.5,0);

load('ConsLinNdFD_t49.mat') %KD = 1e-4 nu = 0.01
[xDesVsTime49,DesCon49] = WaveFrontTracker(A_rec+C_rec,TimeRec,x_trim,0.5,0);

plot(TimeRec,xDesVsTime45.^2,TimeRec,xDesVsTime46.^2,...
    TimeRec,xDesVsTime47.^2,TimeRec,xDesVsTime48.^2,...
    TimeRec,xDesVsTime49.^2)
xlabel('Time'); ylabel('x^2'); title('wavefront displacement')
legend('No chem','KD = 1e-1 nu = 0.01','KD = 1e-2 nu = 0.01',...
    'KD = 1e-3 nu = 0.01','KD = 1e-4 nu = 0.01',  'Location','best')

%%
% Linear Bt = 2e-2 Al = 2e-5
load('ConsLinNdFD_t50.mat') %KD = 1e-2 nu = 0
[xDesVsTime50,DesCon50] = WaveFrontTracker(A_rec+C_rec,TimeRec,x_trim,0);
load('ConsLinNdFD_t51.mat') %KD = 1e-2 nu = 0.001
[xDesVsTime51,DesCon51] = WaveFrontTracker(A_rec+C_rec,TimeRec,x_trim,0);
load('ConsLinNdFD_t52.mat') %KD = 1e-2 nu = 0.01
[xDesVsTime52,DesCon52] = WaveFrontTracker(A_rec+C_rec,TimeRec,x_trim,0);
load('ConsLinNdFD_t53.mat') %KD = 1e-2 nu = 0.1
[xDesVsTime53,DesCon53] = WaveFrontTracker(A_rec+C_rec,TimeRec,x_trim,0);
load('ConsLinNdFD_t54.mat') %KD = 1e-2 nu = 0.1
[xDesVsTime54,DesCon54] = WaveFrontTracker(A_rec+C_rec,TimeRec,x_trim,0);


plot(TimeRec,xDesVsTime50.^2,TimeRec,xDesVsTime51.^2,...
    TimeRec,xDesVsTime52.^2,TimeRec,xDesVsTime53.^2,...
    TimeRec,xDesVsTime54.^2)
xlabel('Time'); ylabel('x^2'); title('wavefront displacement')
legend('KD = 1e-1 nu = 0','KD = 1e-1 nu = 0.001',...
    'KD = 1e-1 nu = 0.01','KD = 1e-1 nu = 0.1','KD = 1e-1 nu = 1','Location','best')
