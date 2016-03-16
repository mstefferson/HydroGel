% ChemDiffMain
% Handles all BCs

function [A,C,DidIBreak,SteadyState] = ChemDiffMain(ParamObj,TimeObj,AnalysisObj)

% Global variables
global Nx;
global v;
global vNext;
global A_rec;
global C_rec;
global j_record;
global Flux2ResR_rec;
global FluxAccum_rec;

% Define commonly used variables
DidIBreak = 0;
SteadyState = 0;
TrackFlux = AnalysisObj.TrackAccumFromFlux;
A_BC = ParamObj.A_BC;
C_BC = ParamObj.C_BC;

% Init global
Nx     = ParamObj.Nx;
A_rec   = zeros(Nx,TimeObj.N_rec);
C_rec   = zeros(Nx,TimeObj.N_rec);

% Other recs
if (AnalysisObj.TrackAccumFromFlux)
    FluxAccum_rec = zeros(1,TimeObj.N_rec);
    Flux2ResR_rec = zeros(1,TimeObj.N_rec);
else
    FluxAccum_rec  = 0;
    Flux2ResR_rec  = 0;
end

% Fix LR
[ParamObj.Lr] = LrMaster(A_BC, ParamObj.Lr);

%Spatial grid
[x,dx]  = GridMaster(A_BC, C_BC,ParamObj.Lbox,Nx);
GridObj = struct('Nx',Nx, 'Lbox',ParamObj.Lbox,'Lr', ParamObj.Lr,...
    'dx', dx, 'x', x,'VNcoef', TimeObj.dt/dx^2);
Gridstr = sprintf('Nx=%d\nLbox=%.1f',GridObj.Nx,GridObj.Lbox);
% Strings
BCstr    = sprintf('A_BC: %s \nC_BC = %s',A_BC,C_BC);
Paramstr = sprintf('Kon=%.1e\nKoff=%.1e\nDc=%.2e\nDnl=%.1e',...
    ParamObj.Kon,ParamObj.Koff,ParamObj.Dc,ParamObj.Dnl);
Concstr = sprintf('ParamObj.ParamObj.Bt=%.1e\nAL=%.1e\nAR=%.2e',...
    ParamObj.Bt,ParamObj.AL,ParamObj.AR);

%Inital Densisy
[A,~,C,~,CL,CR] = ...
    IntConcMaker(ParamObj.AL, ParamObj.AR, ParamObj.Bt, ...
    ParamObj.KDinv, ParamObj.Lbox, x,ParamObj.NLcoup);% A = Alin;
% C(1) = CL; C(end) = CR;
C(1) = 0; C(end) = 0;
% keyboard

% Blur Density check
if ParamObj.BindSiteDistFlag == 1
    [ParamObj.Bt] = BinitGelSquareBlur(ParamObj.Bt, ParamObj.sigma, x);
end

% Blur Density check
if ParamObj.BtDepDiff == 1
    [ParamObj.Da,ParamObj.Dc] = BtDepDiffBuilder(ParamObj.Bt, ParamObj.Btc, ...
        ParamObj.Da,ParamObj.Dc);
end

v = [A';C'];

% Concentration records
A_rec(:,1)   = A;
C_rec(:,1)   = C;
j_record = 2;

% Store the "accumulation" from the flux
if AnalysisObj.TrackAccumFromFlux
    Flux2ResR   = (v(Nx-1) - v(Nx) ) / dx;
    FluxAccum   = 0;
    Flux2ResR_rec(1) = Flux2ResR;
    FluxAccum_rec(1) =  FluxAccum;
end

% keyboard
%Build operators and matrices
[Lop]    =  LopMakerMaster(Nx,dx,ParamObj.Bt,ParamObj.Kon,ParamObj.Koff,...
    ParamObj.Da,ParamObj.Dc, ParamObj.Lr, A_BC,C_BC);
[LMcn,RMcn] = MatMakerCN(  Lop, TimeObj.dt, 2 * Nx );
% keyboard
% NonLinear Include endpoints Dirichlet, then set = 0
if ParamObj.NLcoup
    [NLchem]   = CoupChemNLCalc(v,ParamObj.Kon,Nx);
else
    NLchem     = zeros(2*Nx,1);
end

if ParamObj.Dnl ~= 1
    [NLdiff]   = ConcDepDiffCalcNd1stOrd(v,ParamObj.Dnl,ParamObj.Bt,Nx,dx);
    [NLdiff(1), NLdiff(Nx) ] =  ...
        NlDiffBcFixer(A_BC,C_BC, ParamObj.Dnl, ParamObj.Bt, v, dx);
else
    NLdiff     = zeros(2*Nx,1);
end

NL  = NLdiff + NLchem;
[NL(1), NL(Nx), NL(Nx+1), NL(2*Nx)] = ...
    NlBcFixer(A_BC, C_BC, NL(1), NL(Nx), NL(Nx+1), NL(2*Nx) );

% Step
[vNext] = FuncStepperCnAb1(v,RMcn,LMcn,NL,TimeObj.dt);
[vNext(1), vNext(Nx), vNext(Nx+1), vNext(2*Nx)] = ...
    BcFixer(A_BC, C_BC, vNext(1), vNext(Nx), vNext(Nx+1), vNext(2*Nx), ...
    ParamObj.AL, ParamObj.AR, CL, CR);

if TrackFlux % Just do Euler stepping for now
    Flux2ResR   = (v(Nx-1) - v(Nx) ) / dx;
    FluxAccumNext  = ParamObj.AR + TimeObj.dt * Flux2ResR;
end

% Time loop
if AnalysisObj.ShowRunTime; tic; end

for t = 1: TimeObj.N_time - 1 % t * dt  = time
    
    % Update
    vPrev = v;
    NLprev = NL;
    v     = vNext;
    
    %     keyboard
    if TrackFlux  % Just do Euler stepping for now
        FluxAccum     = FluxAccumNext;
        Flux2ResR     = (v(Nx-1) - v(Nx) ) / dx;
        FluxAccumNext = FluxAccum + TimeObj.dt * Flux2ResR;
    end
    %Non linear. Include endpoints, then set = 0
    if ParamObj.NLcoup
        [NLchem] = CoupChemNLCalc(v,ParamObj.Kon,Nx);
    end
    if ParamObj.Dnl ~= 1
        [NLdiff] = ConcDepDiffCalcNd1stOrd(v,ParamObj.Dnl,ParamObj.Bt,Nx,dx);
        [NLdiff(1), NLdiff(Nx) ] =  ...
            NlDiffBcFixer(A_BC,C_BC, ParamObj.Dnl, ParamObj.Bt, v, dx);
    end
    
    NL  = NLdiff + NLchem;
    [NL(1), NL(Nx), NL(Nx+1), NL(2*Nx)] = ...
        NlBcFixer(A_BC, C_BC, NL(1), NL(Nx), NL(Nx+1), NL(2*Nx) );
    
    % Step
    %     keyboard
    [vNext] = FuncStepperCnAb2(v,RMcn,LMcn,NL,NLprev,TimeObj.dt);
    [vNext(1), vNext(Nx), vNext(Nx+1), vNext(2*Nx)] = ...
        BcFixer(A_BC, C_BC, vNext(1), vNext(Nx), vNext(Nx+1), vNext(2*Nx),...
        ParamObj.AL, ParamObj.AR, CL, CR);
    
    % Save stuff
    if (mod(t,TimeObj.N_count)== 0)
        if  TrackFlux % Just do Euler stepping for now
            Flux2ResR_rec(j_record) = Flux2ResR;
            FluxAccum_rec(j_record) = FluxAccum;
        end
        
        A_rec(:,j_record)   = v(1:Nx);
        C_rec(:,j_record)   = v(Nx+1:2*Nx);
        
        [DidIBreak, SteadyState] = BrokenSteadyTrack(TimeObj.ss_epsilon);
        
        if (DidIBreak == 1); break; end;
        if (SteadyState == 1)
            TimeRec = TimeObj.t_rec .* (0:j_record-1);
            fprintf('Steady State time = %.1f\n',TimeObj.dt*t);
            break;
        end
        j_record = j_record + 1;
        % Check steady state
    end % save stuff
end % time loop

% keyboard
% keyboard
if AnalysisObj.ShowRunTime; toc; end

% Last step
t = t+1;

if TrackFlux % Just do Euler stepping for now
    FluxAccum     = FluxAccumNext;
    Flux2ResR     = (v(Nx-1) - v(Nx) ) / dx;
end

if (mod(t,TimeObj.N_count)==0)
    v     = vNext;
    if TrackFlux % Just do Euler stepping for now
        Flux2ResR_rec(j_record) = Flux2ResR;
        FluxAccum_rec(j_record) = FluxAccum;
    end
    A_rec(:,j_record)   = v(1:Nx);
    C_rec(:,j_record)   = v(Nx+1:2*Nx);
    
end
% Save A and C
A = v(1:Nx);
C = v(Nx+1:end);

% Store the total concentrations
% keyboard
if ~SteadyState
    TimeRec = TimeObj.t_rec .* [0:TimeObj.N_rec-1];
end

fprintf('Sim Time Ran = %.2f\n', TimeRec(end) );

%Check for negative densities
if DidIBreak == 1 || SteadyState == 1;
    A_rec = A_rec(:,1:j_record);
    C_rec = C_rec(:,1:j_record);
     if  TrackFlux
        Flux2ResR_rec = Flux2ResR_rec(1:j_record);
        FluxAccum_rec = FluxAccum_rec(1:j_record);
     end
    TimeObj.N_rec = j_record;
end

% Run analysis
AnalysisMaster( ParamObj.SaveMe, SteadyState, DidIBreak,...
    AnalysisObj,ParamObj,TimeRec, TimeObj,GridObj,...
    x,Paramstr,Gridstr,Concstr)

end
