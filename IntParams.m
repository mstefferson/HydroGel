clear
clc

CurrentDir = pwd;
addpath( genpath( CurrentDir) );

trial    = 505;

% Turn things on
NLcoup  = 1;
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
Nx    = floor(8*Lbox); %Internal gridpoints. Does not include endpoints
% Lr        = Lbox * LrMult;   % Reservior length
Lr = 1;

% Binding flag 0: constant. 1: Square blurr
 
BindSiteDistFlag = 0;
alpha  = 0.1;

if BindSiteDistFlag ~= 0
    sigma  = alpha * Lbox ;
else
    sigma = 0;
end


%Non Dimensional and Concentration
KDinv = 1e5;           % Binding affinity
Koff  = 1e2;           % scaled koff
% KDinv = 0;           % Binding affinity
% Koff  = 0;           % scaled koff
Kon   = KDinv * Koff;  % scaled kon
% Kon   = 0;        % scaled kon
% Koff  = 0;        % scaled koff
DA    = 0.01;
Dc    = 0.1;        % Dc/Da
Dnl   = 1;      % Dsat/DA. Only used for nonlinear diffusion beta  > 1?
Bt    = 2e-3;     % molar (old: 1e-2) (new: 1e-3)
AL    = 2e-4;     % molar 2e-5
AR    = 0;

% time
tfac        = 0.1;
dt          = tfac*(Lbox/(Nx-1))^2;   % time step
t_tot       = 0.1 * tfac * Lbox^2 /  DA;      % total time
t_rec       = t_tot / 100;  % time interval for recording dynamics
ss_epsilon  = 1e-12;   % steady state condition
NumPlots    = 10;      % For the accumulation plot subroutine

% Boudary conditions: 'Dir', 'Vn', 'Res','PBC', 'Mx'
A_BC = 'Dir';
C_BC = 'Vn';

fprintf('trial:%d A_BC: %s C_BC: %s\n', trial,A_BC, C_BC)
% Calculate other parameters
KDinv = Kon/Koff; %Binding affinity

% keyboard
% Build Objects
[ParamObj] = ParamObjMakerRD(SaveMe,ChemOnEndPts,Nx,Lbox,Lr,A_BC,C_BC,Kon,Koff,DA,Dc,Dnl,...
    NLcoup,Bt,AL,AR,trial,BindSiteDistFlag,sigma);
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
if strcmp(A_BC,'Dir') && strcmp(C_BC,'Vn')
[A_rec,C_rec,DidIBreak,SteadyState] = ChemDiffMainDirVn(ParamObj,TimeObj,AnalysisObj);
elseif strcmp(A_BC,'Mx') && strcmp(C_BC,'Vn')
[A_rec,C_rec,DidIBreak,SteadyState] = ChemDiffMainMxVn(ParamObj,TimeObj,AnalysisObj);
elseif strcmp(A_BC,'Dir') && strcmp(C_BC,'Dir')
[A_rec,C_rec,DidIBreak,SteadyState] = ChemDiffMainDir(ParamObj,TimeObj,AnalysisObj);
elseif strcmp(A_BC,'Vn') && strcmp(C_BC,'Vn')
[A_rec,C_rec,DidIBreak,SteadyState] = ChemDiffMainVn(ParamObj,TimeObj,AnalysisObj);
elseif strcmp(A_BC,'Res') && strcmp(C_BC,'Vn')
[A_rec,C_rec,DidIBreak,SteadyState] = ChemDiffMainResVn(ParamObj,TimeObj,AnalysisObj);
elseif strcmp(A_BC,'PBC') && strcmp(C_BC,'PBC')
ParamObj.Nlcoup = 1; % Currently, Nl coup turns on all chem    
[A_rec,C_rec,DidIBreak,SteadyState] = ChemDiffMainPBCft(ParamObj,TimeObj,AnalysisObj);
end
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



    
