% ChemDiffMain
% Handles all BCs

function [recObj] = ChemDiffMain( filename, paramObj,timeObj, flags, ...
  analysisFlags, pVec, koffVaryCell )
% get parameters from vec
paramObj.KonBt = pVec(2);
paramObj.Koff = pVec(3);
paramObj.Bt = pVec(4);
if paramObj.KonBt == 0
  paramObj.Kon = 0;
else
  paramObj.Kon = paramObj.KonBt ./ paramObj.Bt;
end
if paramObj.Kon == 0
  paramObj.Ka = 0;
else
  paramObj.Ka = paramObj.Kon / paramObj.Koff;
end
% build koffVary
koffClass = VaryKoffClass( paramObj.Koff, koffVaryCell, paramObj.Nx );
% if Koff varyies 
paramObj.Koff = koffClass.Koff;
paramSize = size( paramObj.Koff );
paramObj.Kon  = paramObj.Kon .* ones( paramSize  );
paramObj.KonBt  = paramObj.KonBt .* ones( paramSize );
paramObj.Ka = paramObj.Kon ./ paramObj.Koff;
% Calculate D if you're suppose to
if flags.BoundTetherDiff
  paramObj.Llp = pVec(1);
  paramObj.Dc =  boundTetherDiffCalc( paramObj.Llp, paramObj.Koff, paramObj.Da );
  if length( paramObj.Dc ) == 1
    paramObj.Dc = paramObj.Dc .* ones( paramSize );
  end
else
  paramObj.Dc = pVec(1) * paramObj.Da .* ones( paramSize );
  paramObj.Llp = 0;
end
paramObj.nu = paramObj.Dc ./  paramObj.Da;
% Define commonly used variables
Nx     = paramObj.Nx;
DidIBreak = 0;
SteadyState = 0;
PrintedSteady = 0;
if analysisFlags.TrackAccumFlux || analysisFlags.PlotAccumFlux
  TrackFlux = 1;
else
  TrackFlux = 0;
end
A_BC = paramObj.A_BC;
C_BC = paramObj.C_BC;
% Fix LR
[paramObj.Lr] = LrMaster(A_BC, paramObj.Lr);
%Spatial grid
[x,dx]  = GridMaster(A_BC, C_BC,paramObj.Lbox,Nx);
gridObj = struct('Nx',Nx, 'Lbox',paramObj.Lbox,'Lr', paramObj.Lr,...
  'dx', dx, 'x', x,'VNcoef', timeObj.dt/dx^2);
% set up saved matfile
if flags.SaveMe
  myfile = fullfile(pwd, filename);
  runSave = matfile(myfile, 'Writable', true );
  runSave.analysisFlags = analysisFlags;
  runSave.paramObj = paramObj;
  runSave.timeObj = timeObj;
  runSave.gridObj = gridObj;
  runSave.recObj = 0;
  runSave.A_rec   = zeros(Nx,2);
  runSave.C_rec   = zeros(Nx,2);
  % Other recs
  if TrackFlux
    runSave.FluxAccum_rec = zeros(1,2);
    runSave.Flux2Res_rec = zeros(1,2);
  else
    runSave.FluxAccum_rec  = 0;
    runSave.Flux2Res_rec  = 0;
  end
else
  runSave = [];
end
% track things regardless of saving
if TrackFlux
  FluxAccum_rec = zeros(1,timeObj.N_rec);
  Flux2Res_rec = zeros(1,timeObj.N_rec);
else
  FluxAccum_rec  = 0;
  Flux2Res_rec  = 0;
  Flux2Res = 0;
  FluxAccum = 0;
end
A_rec   = zeros(Nx,timeObj.N_rec);
C_rec   = zeros(Nx,timeObj.N_rec);
%Inital Densisy
[A,~,C,~,CL,CR] = ...
  IntConcMaker(paramObj.AL, paramObj.AR, paramObj.Bt, ...
  paramObj.Ka, paramObj.Lbox, x,flags.NLcoup);% A = Alin;
C(1) = 0; C(end) = 0;
% Blur Density check
if flags.BindSiteDistFlag == 1
  [paramObj.Bt] = BinitGelSquareBlur(paramObj.Bt, paramObj.sigma, x);
end
% Density dependent diffusion
if flags.BtDepDiff == 1
  [paramObj.Da,paramObj.Dc] = BtDepDiffBuilder(paramObj.Bt, paramObj.Btc, ...
    paramObj.Da,paramObj.Dc);
end
try
  v = [A;C];
catch
  keyboard
end
% Concentration records
A_rec(:,1)   = v(1:Nx);
C_rec(:,1)   = v(Nx+1:2*Nx);
j_record = 2;
% Store the "accumulation" from the flux
if TrackFlux
  Flux2Res   = (v(Nx-1) - v(Nx) ) / dx;
  FluxAccum   = 0;
  Flux2Res_rec(1) = Flux2Res;
  FluxAccum_rec(1) =  FluxAccum;
end
%Build operators and matrices
[Lop]  =  LopMakerMaster(Nx,dx,paramObj.Bt,paramObj.Kon,paramObj.Koff,...
  paramObj.Da,paramObj.Dc, paramObj.Lr, A_BC,C_BC);
[LMcn,RMcn] = MatMakerCN(  Lop, timeObj.dt, 2 * Nx );

% NonLinear Include endpoints Dirichlet, then set = 0
if flags.NLcoup
  [NLchem]   = CoupChemNLCalc(v,paramObj.Kon,Nx);
else
  NLchem     = zeros(2*Nx,1);
end
if paramObj.Dnl ~= 1
  [NLdiff]   = ConcDepDiffCalcNd1stOrd(v,paramObj.Dnl,paramObj.Bt,Nx,dx);
  [NLdiff(1), NLdiff(Nx) ] =  ...
    NlDiffBcFixer(A_BC,C_BC, paramObj.Dnl, paramObj.Bt, v, dx);
else
  NLdiff     = zeros(2*Nx,1);
end
NL  = NLdiff + NLchem;
[NL(1), NL(Nx), NL(Nx+1), NL(2*Nx)] = ...
  NlBcFixer(A_BC, C_BC, NL(1), NL(Nx), NL(Nx+1), NL(2*Nx) );
% Step
[vNext] = FuncStepperCnAb1(v,RMcn,LMcn,NL,timeObj.dt);
[vNext(1), vNext(Nx), vNext(Nx+1), vNext(2*Nx)] = ...
  BcFixer(A_BC, C_BC, vNext(1), vNext(Nx), vNext(Nx+1), vNext(2*Nx), ...
  paramObj.AL, paramObj.AR, CL, CR);
% Track flux
if TrackFlux % Just do Euler stepping for now
  Flux2Res   = paramObj.Da * (v(Nx-1) - v(Nx) ) / dx;
  FluxAccumNext  = paramObj.AR + timeObj.dt * Flux2Res;
end
% Time loop
if analysisFlags.ShowRunTime; RunTimeID = tic; end
% loop over time
fprintf('Starting time loop\n')
for t = 1:timeObj.N_time - 1 % t * dt  = time
  % Update
  NLprev = NL;
  v     = vNext;
  % Track flux
  if TrackFlux  % Just do Euler stepping for now
    FluxAccum     = FluxAccumNext;
    Flux2Res     = paramObj.Da * (v(Nx-1) - v(Nx) ) / dx;
    FluxAccumNext = FluxAccum + timeObj.dt * Flux2Res;
  end
  %Non linear. Include endpoints, then set = 0
  if flags.NLcoup
    [NLchem] = CoupChemNLCalc(v,paramObj.Kon,Nx);
  end
  if paramObj.Dnl ~= 1
    [NLdiff] = ConcDepDiffCalcNd1stOrd(v,paramObj.Dnl,paramObj.Bt,Nx,dx);
    [NLdiff(1), NLdiff(Nx) ] =  ...
      NlDiffBcFixer(A_BC,C_BC, paramObj.Dnl, paramObj.Bt, v, dx);
  end
  NL  = NLdiff + NLchem;
  [NL(1), NL(Nx), NL(Nx+1), NL(2*Nx)] = ...
    NlBcFixer(A_BC, C_BC, NL(1), NL(Nx), NL(Nx+1), NL(2*Nx) );
  % Step
  [vNext] = FuncStepperCnAb2(v,RMcn,LMcn,NL,NLprev,timeObj.dt);
  [vNext(1), vNext(Nx), vNext(Nx+1), vNext(2*Nx)] = ...
    BcFixer(A_BC, C_BC, vNext(1), vNext(Nx), vNext(Nx+1), vNext(2*Nx),...
    paramObj.AL, paramObj.AR, CL, CR);
  % Save stuff
  if (mod(t,timeObj.N_count)== 0)
    A_rec(:,j_record)   = v(1:Nx);
    C_rec(:,j_record)   = v(Nx+1:2*Nx);
    if  TrackFlux % Just do Euler stepping for now
      Flux2Res_rec(1,j_record) = Flux2Res;
      FluxAccum_rec(1,j_record) = FluxAccum;
    end
    if flags.SaveMe
      if  TrackFlux % Just do Euler stepping for now
        runSave.Flux2Res_rec(1,j_record) = Flux2Res;
        runSave.FluxAccum_rec(1,j_record) = FluxAccum;
      end
      % record it
      runSave.A_rec(:,j_record)   = v(1:Nx);
      runSave.C_rec(:,j_record)   = v(Nx+1:2*Nx);
      % see if it broke
      [DidIBreak, SteadyState] = BrokenSteadyTrack(v, vNext, timeObj.ss_epsilon_dt);
      if (DidIBreak == 1)
        fprintf('I broke time = %f jrec= %d \n',timeObj.dt*t,j_record)
        TimeRec = timeObj.t_rec .* (0:j_record-1);
        SteadyState = 0;
        keyboard
        break;
      end
      if (SteadyState == 1) && PrintedSteady == 0
        fprintf('Steady State time = %.1f jrec =%d\n',timeObj.dt*t,j_record);
        PrintedSteady = 1;
        if flags.BreakAtSteady
          TimeRec = timeObj.t_rec .* (0:j_record-1);
          break;
        end
      end
      
    end % saveMe
    if analysisFlags.TrackProgress
      fprintf('%.2d percent done\n', round( (j_record -1) / timeObj.N_rec * 100));
    end
    j_record = j_record + 1;
    % Check steady state
  end % save stuff
end % time loop
% Last step
t = t+1;
if TrackFlux % Just do Euler stepping for now
  FluxAccum     = FluxAccumNext;
  Flux2Res     = paramObj.Da * (v(Nx-1) - v(Nx) ) / dx;
end
if ~SteadyState || ~DidIBreak
  if (mod(t,timeObj.N_count)==0)
    v     = vNext;
    A_rec(:,j_record)   = v(1:Nx);
    C_rec(:,j_record)   = v(Nx+1:2*Nx);
    Flux2Res_rec(1,j_record) = Flux2Res;
    FluxAccum_rec(1,j_record) = FluxAccum;
    if flags.SaveMe
      if TrackFlux % Just do Euler stepping for now
        runSave.Flux2Res_rec(1,j_record) = Flux2Res;
        runSave.FluxAccum_rec(1,j_record) = FluxAccum;
      end
      runSave.A_rec(:,j_record)   = v(1:Nx);
      runSave.C_rec(:,j_record)   = v(Nx+1:2*Nx);
    end
  end
  fprintf('Finished time loop\n');
  % update time and sizes
  TimeRec = timeObj.t_rec .* [0:j_record-1];
  A_rec = A_rec(:,1:j_record);
  C_rec = C_rec(:,1:j_record);
  if TrackFlux % Just do Euler stepping for now
    Flux2Res_rec = Flux2Res_rec(1,1:j_record);
    FluxAccum_rec = FluxAccum_rec(1,1:j_record);
  end
  % Show run time
  if analysisFlags.ShowRunTime
    RunTime = toc(RunTimeID);
    fprintf('Run time %.2g min\n', RunTime / 60);
    fprintf('Sim Time Ran = %.4f\n', TimeRec(end) );
  end
  % Run analysis
  [recObj] = AnalysisMaster( filename, runSave, ...
    A_rec, C_rec, Flux2Res_rec, FluxAccum_rec,...
    v(1:Nx), v(Nx+1:2*Nx), ...
    SteadyState, DidIBreak,...
    analysisFlags, paramObj, flags, timeObj, gridObj, TimeRec);
  fprintf('Finished run \n');
end
