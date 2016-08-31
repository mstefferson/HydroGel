clear
clc

CurrentDir = pwd;
% addpath( genpath( CurrentDir) );
addpath('./Subroutines');

SaveMe = 0;
PlotMe = 1;
BCstr = 'DirVn'; % 'Dir','Vn','DirVn'

ParamObj.trial  = 1;
%Parameter you can edit

ParamObj.Ka = 1e4 ;
ParamObj.Koff  = 1e1;
ParamObj.Kon  = ParamObj.Ka * ParamObj.Koff;
ParamObj.Da  = 1;
ParamObj.Dc  = 0.1;
ParamObj.AL  = 2e-4;
ParamObj.AR  = 0;
ParamObj.Bt  = 2e-3;
ParamObj.NxPDE  = 128;
ParamObj.NxODE  = (ParamObj.NxPDE-1) .* 10 + 1;
ParamObj.Lbox = 1;
ParamObj.nu = ParamObj.Dc / ParamObj.Dc;

% Strings
Paramstr = sprintf('Kon=%.1e\nKoff=%.1e\nnu=%.2e\n',...
  ParamObj.Kon,ParamObj.Koff,ParamObj.nu);
Concstr = sprintf('Bt=%.1e\nAL=%.1e\nAR=%.2e',...
  ParamObj.Bt,ParamObj.AL,ParamObj.AR);
Gridstr = sprintf('NxODE = %d\nNxPDE = %d',...
  ParamObj.NxODE,ParamObj.NxPDE);
%% Objects
if SaveMe
  diary('RunDiary.txt')
  disp(ParamObj)
end

%%%%%%%% MATLAB'S ODE SOLVER%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% linear
linearEqn = 1;
[AlinOde,ClinOde,~] = RdSsSolverMatBvFunc(...
  ParamObj.Kon,ParamObj.Koff,ParamObj.nu,...
  ParamObj.AL,ParamObj.AR,ParamObj.Bt,ParamObj.Lbox,BCstr,ParamObj.NxODE,...
  linearEqn);
% non-linear
linearEqn = 0;
[AnlOde,CnlOde,xOde] = RdSsSolverMatBvFunc(...
  ParamObj.Kon,ParamObj.Koff,ParamObj.nu,...
  ParamObj.AL,ParamObj.AR,ParamObj.Bt,ParamObj.Lbox,BCstr,ParamObj.NxODE,...
  linearEqn);
fprintf('MATLAB method done\n');

%%%%%%%% MIKE'S ODE SOLVER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[AlinAnMtrx, ClinAnMtrx] = RdSsSolverLinMatrix(...
  ParamObj.Kon,ParamObj.Koff,ParamObj.Bt,ParamObj.nu,...
  ParamObj.Lbox,ParamObj.AL,ParamObj.AR,xOde);
fprintf('Matrix method done\n')

%%%%%%%% Run PDE forever %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Nx = ParamObj.NxPDE;
ParamObj.Nx    = floor(Nx*ParamObj.Lbox); % Scale by box. Careful!!!

% time Stuff
tfac        = 100;
dtfac       = 1;
dt          = dtfac *(ParamObj.Lbox/(ParamObj.Nx))^2; % time step
t_tot       = tfac * ParamObj.Lbox^2 /  ParamObj.Da;  % to
t_rec       = t_tot / 100;  % time interval for recording dynamics
ss_epsilon  = 1e-10;   % steady state condition
NumPlots    = 10;      % For the accumulation plot subroutine
[TimeObj] = TimeObjMakerRD(dt,t_tot,t_rec,ss_epsilon,NumPlots);

ParamObj.BtDepDiff  = 0;  % Turn on if diffusion depends on Bt.
ParamObj.BindSiteDistFlag = 0; % flag turn on spatially varying binding sites
ParamObj.ChemOnEndPts    = 1;
ParamObj.SaveMe = 0;
ParamObj.Lr = 0;
ParamObj.Dnl = 1;
ParamObj.A_BC = 'Dir';
ParamObj.C_BC = 'Vn';

% "Analysis" subroutines
TrackAccumFromFlux = 0;TrackAccumFromFluxPlot = 0;PlotMeMovAccum = 0;
PlotMeLastConcAccum  = 0; PlotMeLastConc = 0; QuickMovie = 0;
CheckConservDen = 0; PlotMeRightRes = 0; ShowRunTime = 1;


% "Analysis" subroutines
AnalysisObj.QuickMovie             = 0;  % Time evolv. Movie
AnalysisObj.TrackAccumFromFlux     = 0;  % Track the flux into outlet
AnalysisObj.TrackAccumFromFluxPlot = 0;  % Plot flux vs time
AnalysisObj.PlotMeLastConc         = 0;  % Concentration at end time
AnalysisObj.PlotMeAccum            = 0;  % Concentration at Outlet vs time
AnalysisObj.PlotMeWaveFrontAccum   = 0;  % Wavefront and accum
AnalysisObj.PlotMeLastConcAccum    = 0;  % Conc at end time and accum
AnalysisObj.CheckConservDen        = 0;  % Check if density is conserved
AnalysisObj.ShowRunTime            = 1;  % Display run time

%%%%% Non Linear
ParamObj.NLcoup = 1;

pVec(1) = ParamObj.Kon;
pVec(2) = ParamObj.Koff;
pVec(3) = ParamObj.Bt;
pVec(4) = ParamObj.Dc / ParamObj.Da;
SteadyState = 0;
counter = 0;
while SteadyState == 0 && counter <= 1
  [RecObj] = ChemDiffMain('', ParamObj, TimeObj, AnalysisObj, pVec);
  A = RecObj.Afinal;
  C = RecObj.Cfinal;
  SteadyState = RecObj.SteadyState;
  counter = counter + 1;
end

if SteadyState == 0
  fprintf('I did not reach steady state. Giving up\n')
end
AnlPde  = A';
CnlPde  = C';
fprintf('NL PDE method done\n');

%%%%% Linear
ParamObj.NLcoup = 0;

SteadyState = 0;
counter = 0;
while SteadyState == 0 && counter <= 1
  [RecObj] = ChemDiffMain('', ParamObj, TimeObj, AnalysisObj, pVec);
  A = RecObj.Afinal;
  C = RecObj.Cfinal;
  SteadyState = RecObj.SteadyState;
  counter = counter + 1;
end

if SteadyState == 0
  fprintf('I did not reach steady state. Giving up\n')
end
AlinPde  = A';
ClinPde  = C';
  
fprintf('Linear PDE method done\n');
[xPde,~]  = GridMaster(ParamObj.A_BC, ParamObj.C_BC, ParamObj.Lbox, ParamObj.Nx);

%% Make Steady state object
SSobj = struct('AlinOde',AlinOde,'ClinOde',ClinOde,...
  'AnlOde',AnlOde,'CnlOde',CnlOde,'AlinAnMtrx',AlinAnMtrx,...
  'ClinAnMtrx',ClinAnMtrx,'AlinPde',AlinPde,'ClinPde',ClinPde,...
  'AnlPde',AnlPde,'CnlPde',CnlPde,'xPde',xPde,'xOde',xOde);

if SaveMe
  dirstr = './Outputs/SteadyState';
  mkdir(dirstr)
  SaveStr = sprintf('SsKon%.1eKoff%.1enu%.1e.mat',...
    ParamObj.Kon,ParamObj.Koff,ParamObj.nu);
  save(SaveStr,'ParamObj','SSobj')
  movefile('*.mat',dirstr)
  movefile('*.txt',dirstr)
  diary off
end

%% Plot routine
if PlotMe
  SSplotterCmpr(SSobj,ParamObj,SSobj.xPde,SSobj.xOde);
end
