clear
clc

CurrentDir = pwd;
addpath( genpath( CurrentDir) );

trial    = 501;

% Turn things on
NLcoup  = 1
RunMe              = 1;
ChemOnEndPts       = 1;
SaveMe             = 1;

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
Nx    = floor(128*Lbox); %Internal gridpoints. Does not include endpoints
% Lr        = Lbox * LrMult;   % Reservior length
Lr = 64;

%Non Dimensional and Concentration
KDinv = 1e4;           % Binding affinity
Koff  = 1e1;           % scaled koff
Kon   = KDinv * Koff;  % scaled kon
% Kon   = 1e4;        % scaled kon
% Koff  = 1e1;        % scaled koff
nu    = 0.1;        % Dc/Da
Dnl   = 1;      % Dsat/DA. Only used for nonlinear diffusion beta  > 1?
Bt    = 2e-3;     % molar (old: 1e-2) (new: 1e-3)
AL    = 2e-4;     % molar 2e-5
AR    = 0;

% time
dt          = (Lbox/(Nx-1))^2;   % time step
t_tot       = 1*Lbox^2;      % total time
t_rec       = t_tot / 100;  % time interval for recording dynamics
ss_epsilon  = 1e-12;   % steady state condition
NumPlots    = 10;      % For the accumulation plot subroutine

% Boudary conditions: 'Dir', 'VN', 'Res','PBC'
A_BC = 'VN';
C_BC = 'VN';

fprintf('trial:%d A_BC: %s C_BC: %s\n', trial,A_BC, C_BC)
% Calculate other parameters
KDinv = Kon/Koff; %Binding affinity

% keyboard
% Build Objects
[ParamObj] = ParamObjMakerRD(SaveMe,ChemOnEndPts,Nx,Lbox,Lr,A_BC,C_BC,Kon,Koff,nu,Dnl,...
    NLcoup,Bt,AL,AR,trial);
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
%     keyboard
 %     ChemDiffMainAResVn
%     ChemDiffMainDir
%     ChemDiffMainVn

fprintf('Starting run \n')
if strcmp(A_BC,'Dir') && strcmp(C_BC,'VN')
[A,C,DidIBreak,SteadyState] = ChemDiffMainDirVn(ParamObj,TimeObj,AnalysisObj);
elseif strcmp(A_BC,'Dir') && strcmp(C_BC,'Dir')
[A,C,DidIBreak,SteadyState] = ChemDiffMainDir(ParamObj,TimeObj,AnalysisObj);
elseif strcmp(A_BC,'VN') && strcmp(C_BC,'VN')
[A,C,DidIBreak,SteadyState] = ChemDiffMainVn(ParamObj,TimeObj,AnalysisObj);
elseif strcmp(A_BC,'Res') && strcmp(C_BC,'VN')
[A,C,DidIBreak,SteadyState] = ChemDiffMainResVn(ParamObj,TimeObj,AnalysisObj);
elseif strcmp(A_BC,'PBC') && strcmp(C_BC,'PBC')
ParamObj.Nlcoup = 1; % Currently, Nl coup turns on all chem    
[A,C,DidIBreak,SteadyState] = ChemDiffMainPBCft(ParamObj,TimeObj,AnalysisObj);
end
fprintf('Finished run\n')

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



    
