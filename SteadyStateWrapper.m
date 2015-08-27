clear
clc

CurrentDir = pwd;
addpath( genpath( CurrentDir) );

SaveMe = 1;
PlotMe = 1;
BCstr = 'DirVn'; % 'Dir','Vn','DirVn'

trial  = 1;
%Parameter you can edit

KDinv = 1e4 ;
Koff  = 1e1;
Kon  = KDinv * Koff;
nu  = 0.1;
AL  = 2e-4;
AR  = 0;
Bt  = 2e-3;
NxPDE  = 128;
NxODE  = (NxPDE-1) .* 10 + 1;
Lbox = 1;
Paramstr = sprintf('Kon=%.1e\nKoff=%.1e\nnu=%.2e\n',...
    Kon,Koff,nu);
Concstr = sprintf('Bt=%.1e\nAL=%.1e\nAR=%.2e',...
    Bt,AL,AR);
Gridstr = sprintf('NxODE = %d\nNxPDE = %d',...
    NxODE,NxPDE);
%% Objects
% Put Parameters in a structure
ParamObj   = struct('trial',trial,'SaveMe',SaveMe,...
    'NxODE',NxODE,'NxPDE',NxPDE,'Lbox',Lbox,...
    'BCstr',BCstr,...
    'Kon', Kon, 'Koff', Koff,'KDinv',Kon/Koff,...
    'nu',nu,'Bt',Bt,'AL',AL,'AR',AR);
if SaveMe
    diary('RunDiary.txt')
    disp(ParamObj)
end

%%%%%%%% MATLAB'S ODE SOLVER%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% linear
linearEqn = 1;
[AlinOde,ClinOde,xOde] = RdSsSolverMatBvFunc(...
    Kon,Koff,nu,AL,AR,Bt,Lbox,BCstr,NxODE,linearEqn);
% non-linear
linearEqn = 0;
[AnlOde,CnlOde,xOde] = RdSsSolverMatBvFunc(...
    Kon,Koff,nu,AL,AR,Bt,Lbox,BCstr,NxODE,linearEqn);
fprintf('MATLAB method done\n');

%%%%%%%% MIKE'S ODE SOLVER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[AlinAnMtrx, ClinAnMtrx] = RdSsSolverLinMatrix(Kon,Koff,Bt,nu,Lbox,AL,AR,xOde);
fprintf('Matrix method done\n')

%%%%%%%% Run PDE forever %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Nx          = NxPDE;
% time
dt          = (Lbox/(Nx-1))^2;   % time step
t_tot       = 1000*Lbox^2;      % total time
t_rec       = t_tot / 100;  % time interval for recording dynamics
ss_epsilon  = 1e-12;   % steady state condition
NumPlots    = 10;      % For the accumulation plot subroutine

% keyboard
ChemOnEndPts    = 1;
SaveMeTemp      = 0;
Lr = 0;
Dnl = 1;
A_BC = 'Dir';
C_BC = 'VN';

% "Analysis" subroutines
TrackAccumFromFlux = 0;TrackAccumFromFluxPlot = 0;PlotMeMovAccum = 0;
PlotMeLastConcAccum  = 0; PlotMeLastConc = 0; QuickMovie = 0;
CheckConservDen = 0; PlotMeRightRes = 0; ShowRunTime = 1;

[TimeObj] = TimeObjMakerRD(dt,t_tot,t_rec,ss_epsilon,NumPlots);
[AnalysisObj] = AnalysisObjMakerRD(TrackAccumFromFlux,...
    TrackAccumFromFluxPlot, PlotMeMovAccum, PlotMeLastConcAccum,...
    PlotMeLastConc,QuickMovie,CheckConservDen,PlotMeRightRes,ShowRunTime);

%%%%% Non Linear
NLcoup = 1;

[ParamObjTemp] = ParamObjMakerRD(SaveMeTemp,ChemOnEndPts,Nx,Lbox,Lr,A_BC,C_BC,Kon,Koff,nu,Dnl,...
    NLcoup,Bt,AL,AR,trial);

if strcmp(A_BC,'Dir') && strcmp(C_BC,'VN')
[A,C,DidIBreak,SteadyState] = ChemDiffMainDirVn(ParamObjTemp,TimeObj,AnalysisObj);
else
    fprintf('Not running non-linear pde steady state\n')
end

if SteadyState == 1
    AnlPde = A';
    CnlPde = C';
else 
    fprintf('I did not reach steady state. Trying again\n')
    [TimeObj] = TimeObjMakerRD(dt,2*t_tot,t_rec,ss_epsilon,NumPlots);
    [A,C,DidIBreak,SteadyState] = ChemDiffMainDirVn(ParamObjTemp,TimeObj,AnalysisObj);
    if SteadyState == 1
    AnlPde = A';
    CnlPde = C';
    
    else
    fprintf('I did not reach steady state. Giving up\n')
    end
end
fprintf('NL PDE method done\n');

%%%%% Linear
NLcoup = 0;

[ParamObjTemp] = ParamObjMakerRD(SaveMeTemp,ChemOnEndPts,Nx,Lbox,Lr,A_BC,C_BC,Kon,Koff,nu,Dnl,...
    NLcoup,Bt,AL,AR,trial);

if strcmp(A_BC,'Dir') && strcmp(C_BC,'VN')
    [x,dx]  = Gridmaker1DVn(ParamObj.Lbox,Nx);
[A,C,DidIBreak,SteadyState] = ChemDiffMainDirVn(ParamObjTemp,TimeObj,AnalysisObj);
else
    fprintf('Not running linear pde steady state\n')
end


if SteadyState == 1
    AlinPde  = A';
    ClinPde  = C';
else 
    fprintf('I did not reach steady state. Trying again\n')
    [TimeObj] = TimeObjMakerRD(dt,2*t_tot,t_rec,ss_epsilon,NumPlots);
    [A,C,DidIBreak,SteadyState] = ChemDiffMainDirVn(ParamObjTemp,TimeObj,AnalysisObj);
    if SteadyState == 1
    AlinPde = A';
    ClinPde = C';    
    else
    fprintf('I did not reach steady state. Giving up\n')
    end
end
fprintf('Linear PDE method done\n');
xPde = x;

%% Make Steady state object
SSobj = struct('AlinOde',AlinOde,'ClinOde',ClinOde,...
    'AnlOde',AnlOde,'CnlOde',CnlOde,'AlinAnMtrx',AlinAnMtrx,...
    'ClinAnMtrx',ClinAnMtrx,'AlinPde',AlinPde,'ClinPde',ClinPde,...
    'AnlPde',AnlPde,'CnlPde',CnlPde,'xPde',xPde,'xOde',xOde);

if SaveMe
    dirstr = './Outputs/SteadyState';
    mkdir(dirstr)
    SaveStr = sprintf('SsKon%.1eKoff%.1enu%.1e.mat',...
    Kon,Koff,nu);
    save(SaveStr,'ParamObj','SSobj')
    movefile('*.mat',dirstr)
    movefile('*.txt',dirstr)
    diary off
end

%% Plot routine
if PlotMe
SSplotterCmpr(SSobj,ParamObj,SSobj.xPde,SSobj.xOde);
end