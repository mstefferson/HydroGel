clear
clc

CurrentDir = pwd;
addpath( genpath( CurrentDir) );

trial    = 501;

% Turn things on
NLcoup             = 1;
RunMe              = 1;
ChemOnEndPts       = 1;
SaveMe             = 0;

% "Analysis" subroutines
TrackAccumFromFlux     = 0;
TrackAccumFromFluxPlot = 0;
PlotMeMovAccum         = 0;
PlotMeLastConcAccum    = 0;
PlotMeLastConc         = 0;
QuickMovie             = 0;
CheckConservDen        = 0;
PlotMeRightRes         = 0;
ShowRunTime            = 1;

%%
% Load experimental grid
load('ExpData.mat')
Exp_rec = kymoGreen_01;

% Experimental Position stuff
NxM     = 128;
xDiS    = 467; % Indice for the start of the gel
xDiE    = xDiS + 63; % Indice for the end of the gel
Exp_rec = Exp_rec(:,xDiS:xDiE);
NxE     = xDiE - xDiS +1;
x_exp   = 1e-6 * pos_01(xDiS:xDiE); %Microns. Trimmed to gel
LboxExp = x_exp(end) - x_exp(1);   % Gel length
L       = LboxExp;        % Scaling factor
x_expS  = (x_exp - x_exp(1) ) ./ L; % Scaled. Start it at zero

% Time stuff
NtE       = 100; % Num of experiment record
t_exp     = 60 * time_01(1:NtE); % Seconds
t_endExp  = t_exp(NtE);
tau       = t_endExp;  % Scaling factor
t_expS    = t_exp (1:NtE) / tau ; % Scaled
Exp_rec   = Exp_rec(1:NtE,:);
%%

%Dimensionalful and Concentration
KDinv   = (1.9)*1e4;           % Binding affinity
Koff_D  = 1e-3;           % scaled koff
Kon_D   = KDinv * Koff_D;  % scaled kon
DA_D    = 0.65e-12;
nu      = 0.001;        % Dc/Da
Dnl     = 1;      % Dsat/DA. Only used for nonlinear diffusion beta  > 1?
Bt      = 1e-3;     % molar (old: 1e-2) (new: 1e-3)
ALfac   = 0.20;
ALres   = 1e-5;
AL      = ALfac*ALres ;     % molar 2e-5
AR      = 0;
AddInt  = 0.040;
% AddInt  = 0.0;
% AR      = 0.040 * ALres;

% Scaled variables
Koff  = Koff_D * tau;           % scaled koff
Kon   = Kon_D * tau;  % scaled kon
DA    = DA_D * tau / L^2;

% Scaled box
Lbox = 1;
Lr   = Lbox *10000;

% Scaled
t_interval = 1;       % time interval
dt_temp    = t_interval / 1000;   % time step
t_start    = 0.05;      % temporary start time

% approx # of record points before experiment
% make sure every exp time point is modeled
t_rec     =  (t_interval) / ( ( NtE - 1 ) ) ; % interval divisible by t_rec
dt        =  t_rec * 1 / ( ceil( t_rec / dt_temp ) ); % t_rec multiple of dt

% make sure exp. start time is hit by t_rec
t_start   = ceil(t_start/t_rec) * t_rec;
% # time points before experiment includes t = 0, no +1 for double counting t_start
NtEx      = ceil(t_start/t_rec); 
% NtEx      = ceil (t_start * NtE / (t_end - t_start) ); 
N_rec     = NtE + NtEx; % N_rec 
t_end     = (N_rec-1) * t_rec;

% Steady state and plotting stuff
ss_epsilon  = 1e-12;   % steady state condition
NumPlots    = 10;      % For the accumulation plot subroutine

% Build the object
[TimeObj] = TimeObjMakerRD(dt,t_end,t_rec,ss_epsilon,NumPlots);
Tmod      = 0:TimeObj.t_rec:t_end;

if TimeObj.N_rec <= NtE % N_rec always should have one more recording point for t = 0
   error('recording error') 
end

% Boudary conditions: 'Dir', 'VN', 'Res','PBC'
A_BC = 'Dir';
C_BC = 'VN';

fprintf('trial:%d A_BC: %s C_BC: %s\n', trial,A_BC, C_BC)

% keyboard
% Build Objects
[ParamObj] = ParamObjMakerRD(SaveMe,ChemOnEndPts,NxM,Lbox,Lr,...
    A_BC,C_BC,Kon,Koff,DA,nu,Dnl,...
    NLcoup,Bt,AL,AR,trial);
[xExp,~]  = Gridmaker1DVn(ParamObj.Lbox,NxE);
[xMod,~]  = Gridmaker1DVn(ParamObj.Lbox,NxM);
[TimeObj] = TimeObjMakerRD(dt,t_end,t_rec,ss_epsilon,NumPlots);
[AnalysisObj] = AnalysisObjMakerRD(TrackAccumFromFlux,...
    TrackAccumFromFluxPlot, PlotMeMovAccum, PlotMeLastConcAccum,...
    PlotMeLastConc,QuickMovie,CheckConservDen,PlotMeRightRes,ShowRunTime);

FileDir = sprintf('Red01A%sC%st%d',A_BC,C_BC,trial);
Where2SavePath    = sprintf('%s/%s/%s',pwd,'Outputs',FileDir);
% disp( max(dt * (Nx/Lbox)^2,nu * dt * (Nx/Lbox)^2) )

if SaveMe
    diary('RunDiary.txt')
    disp(ParamObj)
end
% keyboard

% keyboard
if RunMe == 1
    tic
%     keyboard
 %     ChemDiffMainAResVn
%     ChemDiffMainDir
%     ChemDiffMainVn

fprintf('Starting run \n')
% [Amod_rec,Cmod_rec,DidIBreak,SteadyState] = ...
%     ChemDiffMainResVn(ParamObj,TimeObj,AnalysisObj);

[Amod_rec,Cmod_rec,DidIBreak,SteadyState] = ...
ChemDiffMainDirVn(ParamObj,TimeObj,AnalysisObj);

fprintf('Finished run\n')

% Rotate
Amod_rec = Amod_rec';
Cmod_rec = Cmod_rec';

% Movie
Mov = VideoWriter('Green01Model.avi');
% Set the frame rate (frames per second).
Mov.FrameRate = 4;
% Open the video writer before beginning.
open(Mov);

% Rec to plot
Mod_rec = (Amod_rec + Cmod_rec) ./ ALres + AddInt;
timeRec = TimeObj.t_rec * (0:TimeObj.N_rec-1);

MaxExp =  max(max( Exp_rec )) ;
MaxMod = max(max( Mod_rec ));
MaxYlim = max( MaxExp, MaxMod);

ParamStr1 = sprintf('Parameters\n KDinv %.2e\n Koff = %.2e\n Kon = %.2e\n DA = %.2e\n nu = %.2e\n',...
    KDinv,Koff_D, Kon_D, DA_D,nu);
ConcStr = sprintf(' Bt = %.2e\n ALres = %.2e\n AL = %.2e\n Intesity shift = %.2e',...
    Bt,AL,ALres,AddInt);
ScaleStr = sprintf('Scaling & Box\n tau = %.2e [s]\n L = %.2e [m]\n Inlet Ind = %d\n Outlet Ind = %d',...
    tau, L,xDiS,xDiE);

figure()
% keyboard
%%
for i = 1:TimeObj.N_rec;
 
    if i <= (NtEx)
    h1 = plot(xMod,Mod_rec(i,:),'-',...
        xExp, Exp_rec(1,:),'--' );
    timeExpstr = sprintf( 'Time\nt_E = 0\n');
    FrameStr   = sprintf( 'Frame = N/A' );
    else
%     keyboard
    h1 = plot(xMod,Mod_rec(i,:),'-',...
        xExp, Exp_rec(i - NtEx,:),'--' );
    timeExpstr = sprintf( 'Time\nt_E = %.2e [s] \n',...
        t_exp(NtE - TimeObj.N_rec + i) );
    FrameStr   = sprintf( 'Frame = %d\n',i - NtEx );
    end   

    %Label
    title('RD across hydrogel Model (BC: A-Dir C-Vn ) vs Exp KymoGreen-01')
    ylabel('Intensity')
    xlabel('Scaled Position')
    
    %Str stuff
    timeModstr = sprintf( 't_M = %.2e []\n',timeRec(i) );   
    timestr = [ timeExpstr timeModstr FrameStr];
    text(0.25, MaxYlim / 2,ScaleStr);
    text(0.5,  MaxYlim / 2,timestr);
    text(0.75, MaxYlim / 2,ParamStr1);
    text(0.75, MaxYlim / 4,ConcStr);
    legend('Model','Exp','location','best')
    % Rescale axis
    Ax = gca;
    Ax.YLim = [0 MaxYlim];  
    pause(0.1)
    Fr = getframe(gcf);
    % Add the frame to the movie.
    writeVideo(Mov,Fr);
%     keyboard
    % Get rid of trace and annotation without closing figure.
%       keyboard
if i ~= TimeObj.N_rec
    delete(h1);
end

end % End time
%Close the video writer.
close(Mov);
%%
% ChemDiffMainPBCft
    if SaveMe 
      diary off
      mkdir(Where2SavePath)
      movefile('*.mat', Where2SavePath)
      movefile('*.txt', Where2SavePath)
    end
    toc
    fprintf('Break = %d Steady = %d\n',DidIBreak,SteadyState)
%     cd /home/mws/Documents/MATLAB/Research/BG/DDFT/HRddft/Drive/IsoDiffCube
end
