clear
clc

CurrentDir = pwd;
% addpath( genpath( CurrentDir) );
addpath('./Subroutines');

SaveMe = 0;
PlotMe = 1;
BCstr = 'DirVn'; % 'Dir','Vn','DirVn'

paramObj.trial  = 1;
%Parameter you can edit

paramObj.kA = 1e4 ;
paramObj.koff  = 1e1;
paramObj.kon  = paramObj.kA * paramObj.koff;
paramObj.Da  = 1;
paramObj.Dc  = 0.1;
paramObj.AL  = 2e-4;
paramObj.AR  = 0;
paramObj.Bt  = 2e-3;
paramObj.NxPDE  = 128;
paramObj.NxODE  = (paramObj.NxPDE-1) .* 10 + 1;
paramObj.Lbox = 1;
paramObj.nu = paramObj.Dc / paramObj.Dc;

% Strings
Paramstr = sprintf('Kon=%.1e\nKoff=%.1e\nnu=%.2e\n',...
  paramObj.kon,paramObj.koff,paramObj.nu);
Concstr = sprintf('Bt=%.1e\nAL=%.1e\nAR=%.2e',...
  paramObj.Bt,paramObj.AL,paramObj.AR);
Gridstr = sprintf('NxODE = %d\nNxPDE = %d',...
  paramObj.NxODE,paramObj.NxPDE);
%% Objects
if SaveMe
  diary('RunDiary.txt')
  disp(paramObj)
end

%%%%%%%% MATLAB'S ODE SOLVER%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% linear
linearEqn = 1;
[AlinOde,ClinOde,~] = RdSsSolverMatBvFunc(...
  paramObj.kon,paramObj.koff,paramObj.nu,...
  paramObj.AL,paramObj.AR,paramObj.Bt,paramObj.Lbox,BCstr,paramObj.NxODE,...
  linearEqn);
% non-linear
linearEqn = 0;
[AnlOde,CnlOde,xOde] = RdSsSolverMatBvFunc(...
  paramObj.kon,paramObj.koff,paramObj.nu,...
  paramObj.AL,paramObj.AR,paramObj.Bt,paramObj.Lbox,BCstr,paramObj.NxODE,...
  linearEqn);
fprintf('MATLAB method done\n');

%%%%%%%% MIKE'S ODE SOLVER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[AlinAnMtrx, ClinAnMtrx] = RdSsSolverLinMatrix(...
  paramObj.kon,paramObj.koff,paramObj.Bt,paramObj.nu,...
  paramObj.Lbox,paramObj.AL,paramObj.AR,xOde);
fprintf('Matrix method done\n')

%%%%%%%% Run PDE forever %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Nx = paramObj.NxPDE;
paramObj.Nx    = floor(Nx*paramObj.Lbox); % Scale by box. Careful!!!

% time Stuff
tfac        = 100;
dtfac       = 1;
dt          = dtfac *(paramObj.Lbox/(paramObj.Nx))^2; % time step
t_tot       = tfac * paramObj.Lbox^2 /  paramObj.Da;  % to
t_rec       = t_tot / 100;  % time interval for recording dynamics
ss_epsilon  = 1e-10;   % steady state condition
NumPlots    = 10;      % For the accumulation plot subroutine
[timeObj] = timeObjMakerRD(dt,t_tot,t_rec,ss_epsilon,NumPlots);

flags.BtDepDiff  = 0;  % Turn on if diffusion depends on Bt.
flags.BindSiteDistFlag = 0; % flag turn on spatially varying binding sites
flags.ChemOnEndPts    = 1;
flags.SaveMe = 0;
paramObj.Lr = 0;
paramObj.Dnl = 1;
paramObj.A_BC = 'Dir';
paramObj.C_BC = 'Vn';

% "Analysis" subroutines
TrackAccumFromFlux = 0;TrackAccumFromFluxPlot = 0;PlotMeMovAccum = 0;
PlotMeLastConcAccum  = 0; PlotMeLastConc = 0; QuickMovie = 0;
CheckConservDen = 0; PlotMeRightRes = 0; ShowRunTime = 1;


% "Analysis" subroutines
analysisFlags.QuickMovie             = 0;  % Time evolv. Movie
analysisFlags.TrackAccumFromFlux     = 0;  % Track the flux into outlet
analysisFlags.TrackAccumFromFluxPlot = 0;  % Plot flux vs time
analysisFlags.PlotMeLastConc         = 0;  % Concentration at end time
analysisFlags.PlotMeAccum            = 0;  % Concentration at Outlet vs time
analysisFlags.PlotMeWaveFrontAccum   = 0;  % Wavefront and accum
analysisFlags.PlotMeLastConcAccum    = 0;  % Conc at end time and accum
analysisFlags.CheckConservDen        = 0;  % Check if density is conserved
analysisFlags.ShowRunTime            = 1;  % Display run time

%%%%% Non Linear
flags.NLcoup = 1;

pVec(1) = paramObj.kon;
pVec(2) = paramObj.koff;
pVec(3) = paramObj.Bt;
pVec(4) = paramObj.Dc / paramObj.Da;
SteadyState = 0;
counter = 0;
while SteadyState == 0 && counter <= 1
  [RecObj] = ChemDiffMain('', paramObj, timeObj, analysisFlags, pVec);
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
flags.NLcoup = 0;

SteadyState = 0;
counter = 0;
while SteadyState == 0 && counter <= 1
  [RecObj] = ChemDiffMain('', paramObj, timeObj, analysisFlags, pVec);
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
[xPde,~]  = GridMaster(paramObj.A_BC, paramObj.C_BC, paramObj.Lbox, paramObj.Nx);

%% Make Steady state object
SSobj = struct('AlinOde',AlinOde,'ClinOde',ClinOde,...
  'AnlOde',AnlOde,'CnlOde',CnlOde,'AlinAnMtrx',AlinAnMtrx,...
  'ClinAnMtrx',ClinAnMtrx,'AlinPde',AlinPde,'ClinPde',ClinPde,...
  'AnlPde',AnlPde,'CnlPde',CnlPde,'xPde',xPde,'xOde',xOde);

if SaveMe
  dirstr = './Outputs/SteadyState';
  mkdir(dirstr)
  SaveStr = sprintf('SsKon%.1eKoff%.1enu%.1e.mat',...
    paramObj.kon,paramObj.koff,paramObj.nu);
  save(SaveStr,'paramObj','SSobj')
  movefile('*.mat',dirstr)
  movefile('*.txt',dirstr)
  diary off
end

%% Plot routine
if PlotMe
  SSplotterCmpr(SSobj,paramObj,SSobj.xPde,SSobj.xOde);
end
