clear
clc

CurrentDir = pwd;
addpath( genpath( CurrentDir) );

trial    = 1;

% Turn things on
NLcoup        = 1;
RunMe         = 1;
ChemOnEndPts  = 1;
SaveMe        = 1;

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

%Spatial grid
Lbox  = 1;             % Gel length
Nx    = 128;
Nx    = floor(Nx*Lbox); %Internal gridpoints. Does not include endpoints
Lr = 10;


%Non Dimensional and Concentration
KDinv = 1e4;           % Binding affinity
Koff  = 1e2;           % scaled koff
Kon   = KDinv * Koff;  % scaled kon
Da    = 1;             % Diffusion of species A (unbound)
Dc    = 1;             % Dc/Da
Dnl   = 1;             % Dsat/DA. Only used for nonlinear diffusion beta  > 1?
Bt    = 2e-3;          % molar (old: 1e-2) (new: 1e-3)
AL    = 2e-4;          % concentration of inlet
AR    = 0;             % concentration of outlet

% Binding flag 0: constant. 1: Square blurr
BindSiteDistFlag = 1; % flag turn on spatially varying binding sites
alpha  = 0.1;         % length scale (frac of box) where binding sites change

BtDepDiff  = 0;
Btc   = Bt;

if BindSiteDistFlag ~= 0
    sigma  = alpha * Lbox ;
else
    BtDepDiff = 0;
    sigma = 0;
end

% time
tfac        = 1;
dt          = tfac*(Lbox/(Nx-1))^2;   % time step
t_tot       = 1 * tfac * Lbox^2 /  Da;      % total time
t_rec       = t_tot / 100;  % time interval for recording dynamics
ss_epsilon  = 1e-12;   % steady state condition
NumPlots    = 10;      % For the accumulation plot subroutine

% Boundary conditions: 'Dir', 'Vn', 'Res','PBC', 'Mx'
A_BC = 'Dir';
C_BC = 'Vn';

fprintf('trial:%d A_BC: %s C_BC: %s\n', trial,A_BC, C_BC)
% Calculate other parameters
KDinv = Kon/Koff; %Binding affinity

% Build Objects
[ParamObj] = ParamObjMakerRD(SaveMe,ChemOnEndPts,Nx,Lbox,Lr,A_BC,C_BC,Kon,Koff,Da,Dc,Dnl,...
    NLcoup,Bt,Btc, AL,AR,trial,BindSiteDistFlag,BtDepDiff,sigma);
[TimeObj] = TimeObjMakerRD(dt,t_tot,t_rec,ss_epsilon,NumPlots);
[AnalysisObj] = AnalysisObjMakerRD(TrackAccumFromFlux,...
    TrackAccumFromFluxPlot, PlotMeMovAccum, PlotMeLastConcAccum,...
    PlotMeLastConc,QuickMovie,CheckConservDen,PlotMeRightRes,ShowRunTime);

FileDir = sprintf('RdNx%dA%sC%st%d',Nx,A_BC,C_BC,trial);
Where2SavePath    = sprintf('%s/%s/%s',pwd,'Outputs',FileDir);
% disp( max(dt * (Nx/Lbox)^2,nu * dt * (Nx/Lbox)^2) ) 

if SaveMe
    diary('RunDiary.txt')
    disp(ParamObj)
end
% keyboard
if RunMe == 1
    tic

fprintf('Starting run \n')
[A_rec,C_rec,DidIBreak,SteadyState] = ChemDiffMain(ParamObj,TimeObj,AnalysisObj);
fprintf('Finished run\n')

% ChemDiffMainPBCft
    if SaveMe 
      diary off
      mkdir(Where2SavePath)
      movefile('*.mat', Where2SavePath)
      movefile('*.txt', Where2SavePath)
      movefile('*.avi', Where2SavePath)
    end
    toc
    fprintf('Break = %d Steady = %d\n',DidIBreak,SteadyState)
%     cd /home/mws/Documents/MATLAB/Research/BG/DDFT/HRddft/Drive/IsoDiffCube
end



    
