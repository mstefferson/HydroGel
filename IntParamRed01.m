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
Exp_rec = kymoRed_01;

% Experimental Position stuff
NxM     = 128;
xDiS    = 467; % Indice for the start of the gel
xDiE    = 489; % Indice for the end of the gel
Exp_rec = Exp_rec(:,xDiS:xDiE);
NxE     = xDiE - xDiS +1;
x_exp   = 1e-6 * pos_01(xDiS:xDiE); %Microns. Trimmed to gel
LboxExp = x_exp(end) - x_exp(1);   % Gel length
L       = LboxExp;        % Scaling factor
x_expS  = (x_exp - x_exp(1) ) ./ L; % Scaled. Start it at zero

% Time stuff
NtE       = 200; % Num of experiment record
t_exp     = 60 * time_01(1:NtE); % Seconds
t_endExp  = t_exp(NtE);
tau       = t_endExp;  % Scaling factor
t_expS    = time_01(1:NtE) / tau ; % Scaled

%%

%Dimensionalful and Concentration
KDinv   = 0;           % Binding affinity
Koff_D  = 0;           % scaled koff
Kon_D   = KDinv * Koff_D;  % scaled kon
DA_D    = 1e-11;
nu      = 0;        % Dc/Da
Dnl     = 1;      % Dsat/DA. Only used for nonlinear diffusion beta  > 1?
Bt      = 2e-3;     % molar (old: 1e-2) (new: 1e-3)
ALfac   = 1;
ALres   = 2e-4;
AL      = ALfac*ALres ;     % molar 2e-5
AR      = 0;
AddDen  = 0.05;

% Scaled variables
Koff  = Koff_D * tau;           % scaled koff
Kon   = Kon_D * tau;  % scaled kon
DA    = DA_D * tau / L^2;

% Scaled box
Lbox = 1;
Lr   = Lbox *100;

% Scaled
dt      =  0.0001;   % time step
t_start = 0.1;
t_end   = t_start + 1;

% approx # of record points before experiment
NtEx      = ceil (t_start * NtE / (t_end - t_start) ); 
N_recTemp = NtE + NtEx;
t_rec     = ceil( t_end / ( dt * ( N_recTemp - 1) ) ) * dt;
t_end     = ceil( t_end/t_rec ) * t_rec;
N_rec     = round(t_end/t_rec) + 1;
t_start   = ( N_rec - NtE ) * t_rec;

% Steady state and plotting stuff
ss_epsilon  = 1e-12;   % steady state condition
NumPlots    = 10;      % For the accumulation plot subroutine

% Build the object
[TimeObj] = TimeObjMakerRD(dt,t_end,t_rec,ss_epsilon,NumPlots);
Tmod      = 0:TimeObj.t_rec:t_end;
% keyboard
if TimeObj.N_rec <= NtE
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
[A_rec,C_rec,DidIBreak,SteadyState] = ...
ChemDiffMainDirVn(ParamObj,TimeObj,AnalysisObj);
fprintf('Finished run\n')

% Rotate
A_rec = A_rec';
C_rec = C_rec';

% Movie
Mov = VideoWriter('temp.avi');
% Set the frame rate (frames per second).
Mov.FrameRate = 4;
% Open the video writer before beginning.
open(Mov);

% Rec to plot
Mod_rec = (A_rec + C_rec) ./ ALres + AddDen;
timeRec = TimeObj.t_rec * (0:TimeObj.N_rec-1);

MaxExp = max(max( Exp_rec )) ;
MaxYlim = max(max( Mod_rec ));



figure()
% keyboard
%%
for i = 1:TimeObj.N_rec;
 
    if i <= (TimeObj.N_rec - NtE)
    h1 = plot(xMod,Mod_rec(i,:),'-',...
        xExp, Exp_rec(1,:),'--' );
    timeExpstr = sprintf( 't_E = 0\n');
    else
%     keyboard
    h1 = plot(xMod,Mod_rec(i,:),'-',...
        xExp, Exp_rec(TimeObj.N_rec - NtE + i,:),'--' );
    timeExpstr = sprintf( 't_E = %.2e\n',...
        t_expS(NtE - TimeObj.N_rec + i) );
    end    
    timeModstr = sprintf( 't_M = %.2e\n',timeRec(i) );
    
    timestr = [ timeExpstr timeModstr ];
    
    
    textbp(timestr);
    legend('Model','Exp','location','best')
    Ax = gca;
    Ax.YLim = [0 MaxYlim]; 
        
    pause(0.1)
    F = getframe;
    % Add the frame to the movie.
    writeVideo(Mov,F);
%     keyboard
    % Get rid of trace and annotation without closing figure.
    if i ~= TimeObj.N_rec
    delete(h1);
    end    
end
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
