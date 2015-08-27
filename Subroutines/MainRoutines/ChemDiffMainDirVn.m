% ChemDiffMainDirVn
% A bc Dir C bc VN
function [A,C,DidIBreak,SteadyState] = ChemDiffMainDirVn(ParamObj,TimeObj,AnalysisObj)
% Define commonly used variables
DidIBreak = 0;
Nx = ParamObj.Nx;
% Fix LR
ParamObj.Lr = 0;
% keyboard
%Spatial grid
[x,dx]  = Gridmaker1DVn(ParamObj.Lbox,Nx);
GridObj = struct('Nx',Nx, 'Lbox',ParamObj.Lbox,'Lr', ParamObj.Lr,...
    'dx', dx, 'x', x,'VNcoef', TimeObj.dt/dx^2);
Gridstr = sprintf('Nx=%d\nLbox=%.1f',...
    GridObj.Nx,GridObj.Lbox);
% Strings
BCstr    = sprintf('A_BC: %s \nC_BC = %s',ParamObj.A_BC,ParamObj.C_BC);
Paramstr = sprintf('Kon=%.1e\nKoff=%.1e\nnu=%.2e\nDnl=%.1e',...
    ParamObj.Kon,ParamObj.Koff,ParamObj.nu,ParamObj.Dnl);
Concstr = sprintf('ParamObj.ParamObj.Bt=%.1e\nAL=%.1e\nAR=%.2e',...
    ParamObj.Bt,ParamObj.AL,ParamObj.AR);

%Inital Densisy
[A,~,C,~,~,~] = ...
    IntConcMaker(ParamObj.AL, ParamObj.AR, ParamObj.Bt, ...
   ParamObj.KDinv, ParamObj.Lbox, x,ParamObj.NLcoup);% A = Alin;
% C(1) = CL; C(end) = CR;
C(1) = 0; C(end) = 0;
% keyboard
v = [A';C'];

% Concentration records
A_rec   = zeros(Nx,TimeObj.N_rec);
C_rec   = zeros(Nx,TimeObj.N_rec);
A_rec(:,1)   = A;
C_rec(:,1)   = C;
j_record = 2;

% Store the "accumulation" from the flux
if AnalysisObj.TrackAccumFromFlux
    FluxAccum_rec = zeros(1,TimeObj.N_rec);
    Flux2ResR_rec = zeros(1,TimeObj.N_rec);
    Flux2ResR   = (v(Nx-1) - v(Nx) ) / dx;
    FluxAccum  = v(Nx);
    Flux2ResR_rec(1) = Flux2ResR;
    FluxAccum_rec(1) =  FluxAccum;
else
    FluxAccum_rec = 0;
    Flux2ResR_rec = 0;
end

%Build operators and matrices
[Lop]    = LopMakerRdDirVn(Nx,dx,ParamObj.Bt,ParamObj.Kon,ParamObj.Koff,1,ParamObj.nu);
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
NLdiff(1) = (Dnl - 1) / Bt * ...
        (v(Nx+1) + v(Nx+2) ) .* (v(2) - v(1) ) / ( dx^2 );
    NLdiff(Nx) = (Dnl - 1) / Bt * ...
        (v(2*Nx-1) + v(2*Nx) ) .* (v(Nx-1) - v(Nx) ) / ( dx^2 );
else
    NLdiff     = zeros(2*Nx,1);
end
NL  = NLdiff + NLchem;
NL(1) = 0; NL(Nx) = 0;

% Step
[vNext] = FuncStepperCnAb1(v,RMcn,LMcn,NL,TimeObj.dt);
vNext(1) = ParamObj.AL; vNext(Nx) = ParamObj.AR;

if AnalysisObj.TrackAccumFromFlux % Just do Euler stepping for now
    Flux2ResR   = (v(Nx-1) - v(Nx) ) / dx;
    FluxAccumNext  = ParamObj.AR + TimeObj.dt * Flux2ResR;
end

% Time loop
SteadyState = 0;
if AnalysisObj.ShowRunTime; tic; end
for t = 1: TimeObj.N_time - 1 % t * dt  = time
    
    % Update
    vPrev = v;
    NLprev = NL;
    v     = vNext;
    
    %     keyboard
    if AnalysisObj.TrackAccumFromFlux % Just do Euler stepping for now
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
NLdiff(1) = (Dnl - 1) / Bt * ...
        (v(Nx+1) + v(Nx+2) ) .* (v(2) - v(1) ) / ( dx^2 );
    NLdiff(Nx) = (Dnl - 1) / Bt * ...
        (v(2*Nx-1) + v(2*Nx) ) .* (v(Nx-1) - v(Nx) ) / ( dx^2 );
    end
    NL  = NLdiff + NLchem;
    NL(1) = 0; NL(Nx) = 0;
    % Step
    [vNext] = FuncStepperCnAb2(v,RMcn,LMcn,NL,NLprev,TimeObj.dt);
    vNext(1) = ParamObj.AL; vNext(Nx) = ParamObj.AR;
    
    % Save stuff
    if (mod(t,TimeObj.N_count)== 0)
        if min(v) < 0
            fprintf('Something went negative\n')
            AnalysisObj.QuickMovie = 0; SaveMe = 0;
            DidIBreak = 1;
            break
        end
        if find(~isfinite(v)) ~= 0
            fprintf('Something blew up\n')
            QuickMovie = 0; SaveMe = 0;
            DidIBreak = 1;
            break
        end
        
        A_rec(:,j_record)   = v(1:Nx);
        C_rec(:,j_record)   = v(Nx+1:end);
        if AnalysisObj.TrackAccumFromFlux % Just do Euler stepping for now
            Flux2ResR_rec(j_record) = Flux2ResR;
            FluxAccum_rec(j_record) = FluxAccum;
        end
        % Check for steady state. max() is ok with NaN
        if max( abs( (v-vNext)./v ) ) < TimeObj.ss_epsilon
            A_rec = A_rec(:,1:j_record);
            C_rec = C_rec(:,1:j_record);
            if AnalysisObj.TrackAccumFromFlux
                Flux2ResR_rec = Flux2ResR_rec(1:j_record);
                FluxAccum_rec = FluxAccum_rec(1:j_record);
            end
            SteadyState = 1;
            TimeRec = TimeObj.t_rec .* [0:j_record-1];
            fprintf('Steady State time = %.1f\n',TimeObj.dt*t)
            %             keyboard
            break
        end
        
        j_record = j_record + 1;
        % Check steady state
        
    end % save stuff
end % time loop
% keyboard
if AnalysisObj.ShowRunTime; toc; end
% Last step
t = t+1;
if AnalysisObj.TrackAccumFromFlux % Just do Euler stepping for now
    FluxAccum     = FluxAccumNext;
    Flux2ResR     = (v(Nx-1) - v(Nx) ) / dx;
    FluxAccumNext = FluxAccum + TimeObj.dt * Flux2ResR;
    FluxMeasuredEnd = Flux2ResR;
end

if (mod(t,TimeObj.N_count)==0)
    v     = vNext;
    A_rec(:,j_record)   = v(1:Nx);
    C_rec(:,j_record)   = v(Nx+1:end);
    if AnalysisObj.TrackAccumFromFlux % Just do Euler stepping for now
        FluxAccum     = FluxAccumNext;
        Flux2ResR     = (v(Nx-1) - v(Nx) ) / dx;
        Flux2ResR_rec(j_record) = Flux2ResR;
        FluxAccum_rec(j_record) = FluxAccum;
    end
end
% Save A and C
A = v(1:Nx);
C = v(Nx+1:end);

% Store the total concentrations
if ~SteadyState
    TimeRec = TimeObj.t_rec .* [0:TimeObj.N_rec-1];
else
    TimeObj.N_rec = j_record;
end
% Total B
B_rec = ParamObj.Bt - C_rec;

% RecObj
RecObj = struct('A_rec', A_rec,'B_rec',B_rec,'C_rec',C_rec,...
    'FluxAccum_rec',FluxAccum_rec,'Flux2ResR_rec',Flux2ResR_rec,...
    'TimeRec',TimeRec,'SteadyState',SteadyState);

%Check for negative densities
[DidIBreak] =  NegDenChecker(A_rec,C_rec,B_rec,ParamObj.trial);

% keyboard
if ParamObj.SaveMe
    saveStr = sprintf('ConsDirVnNL%d_t%d',ParamObj.NLcoup,ParamObj.trial);
    save(saveStr,'ParamObj','GridObj','TimeObj','AnalysisObj','RecObj')
%     movefile('*.mat', OutputDir)
end

if AnalysisObj.QuickMovie
    MAll = ConcenMovieMakerTgthr1D(A_rec, C_rec,...
        x,TimeRec,TimeObj.N_rec,Nx,ParamObj.Kon,ParamObj.Koff,...
        ParamObj.Dnl,ParamObj.nu,ParamObj.Bt,ParamObj.KDinv);
end

if AnalysisObj.TrackAccumFromFluxPlot
    AccumMax = 4.5e-3;
    FluxA2resDirPlotter(...
        ParamObj.AL,ParamObj.Bt,ParamObj.AR,v,Nx,ParamObj.nu,...
        ParamObj.Lbox,dx,AccumMax,Flux2ResR,TimeRec,...
        FluxAccum_rec,Flux2ResR_rec,Paramstr,Gridstr)
end

if AnalysisObj.CheckConservDen
    ConservCheckerAres(x,A_rec,C_rec,TimeRec,ParamObj.Lr)
end

if AnalysisObj.PlotMeRightRes
    figure()
    %    ReservConcVsTimePlotter(TimeRec,A_rec,AllParamVec,trial)
    plot(TimeRec,A_rec(end,:)/ParamObj.AL )
    titstr = sprintf('Nx = %d Lbox = %.1f',Nx,ParamObj.Lbox);
    title(titstr)
end

if AnalysisObj.PlotMeMovAccum
    WavefrontAndAccumPlotter(A_rec,C_rec,x,TimeRec,TimeObj.N_rec,TimeObj.NumPlots,...
        ParamObj.Kon,ParamObj.Koff,ParamObj.nu,ParamObj.Dnl,...
        ParamObj.AL,ParamObj.Bt)
end

if AnalysisObj.PlotMeLastConcAccum
    PlotLastConcAndAccum(...
        A_rec,C_rec,x,Paramstr,Gridstr,Concstr,TimeRec,ParamObj.trial)
end

if AnalysisObj.PlotMeLastConc
    PlotLastConc(...
        A_rec(:,end),C_rec(:,end),x,Paramstr,Gridstr,Concstr,ParamObj.trial)
end


