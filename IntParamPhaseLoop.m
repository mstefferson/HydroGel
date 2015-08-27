clear
clc

CurrentDir = pwd;
addpath( genpath( CurrentDir) );

trial    = 501;
SteadyStateODE = 0;

% Turn things on
SaveAll          = 1;
NLcoup  = 1;
ChemOnEndPts = 1;

% "Analysis" subroutines
TrackAccumFromFlux     = 0;
TrackAccumFromFluxPlot = 0;
PlotMeMovAccum         = 0;
PlotMeLastConcAccum    = 0;
PlotMeLastConc         = 0;
QuickMovie             = 0;
CheckConservDen        = 0;
PlotMeRightRes         = 0;
ShowRunTime            = 0;

%Spatial grid
Lbox  = 1;             % Gel length
Nx    = floor(128*Lbox); %Internal gridpoints. Does not include endpoints
% Lr        = Lbox * LrMult;   % Reservior length
Lr = 64;

%Non Dimensional and Concentration
KDinvVec = [10^(3)];                           % Binding affinity
% KDinvVec = [1];                           % Binding affinity
KoffVec  = [0 logspace(1,2,1)];         % scaled koff
% Kon   = 1e4;        % scaled kon
% Koff  = 1e1;        % scaled koff
nuVec    = [0:1:10];        % Dc/Da
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
if SteadyStateODE; Nx = Nx * 10;t_tot = 0; end

% Boudary conditions: 'Dir', 'VN', 'Res','PBC'
A_BC = 'Dir';
C_BC = 'VN';
BCstr = 'DirVn';
fprintf('trial:%d A_BC: %s C_BC: %s\n', trial,A_BC, C_BC)
% Initialize things
KDinvNum       = length(KDinvVec);
KoffNum        = length(KoffVec);
nuNum          = length(nuVec);
Flux4PhaseMat  = zeros( KDinvNum,KoffNum, nuNum);
SteadyStateMat = zeros( KDinvNum,KoffNum, nuNum);
NxMat  = zeros( KDinvNum,KoffNum, nuNum);
% keyboard


FileDir = sprintf('PhaseLoopKdinv%dKoff%dnu%d',KDinvNum,KoffNum,nuNum);
Where2SavePath    = sprintf('%s/%s/%s',pwd,'Outputs',FileDir);
% disp( max(dt * (Nx/Lbox)^2,nu * dt * (Nx/Lbox)^2) )

if SaveAll
    diary('RunDiary.txt')
    disp('KDinv');disp(KDinvVec);disp('Koff:');disp(KoffVec);...
        disp('nu:');disp(nuVec);
end

tic
for ii = 1:KDinvNum
    KDinv = KDinvVec(ii);
    if KDinv == 0 % Diffusion
        Koff  = 0;
        Kon   = 0;
        nu = 0;
        if SteadyStateODE
            SteadyState = 1;
            [Ass,Css,x] = RdSsSolverMatBvFunc(...
                Kon,Koff,nu,AL,AR,Bt,Lbox,BCstr,Nx,NLcoup);
            FluxDiff = ( Ass(end-1) - Ass(end) ) ./ (x(2) - x(1));
        else
            %Build Objects
            [ParamObj] = ParamObjMakerRD(0,ChemOnEndPts,Nx,Lbox,Lr,A_BC,C_BC,Kon,Koff,nu,Dnl,...
                NLcoup,Bt,AL,AR,trial);
            [TimeObj] = TimeObjMakerRD(dt,t_tot,t_rec,ss_epsilon,NumPlots);
            [AnalysisObj] = AnalysisObjMakerRD(TrackAccumFromFlux,...
                TrackAccumFromFluxPlot, PlotMeMovAccum, PlotMeLastConcAccum,...
                PlotMeLastConc,QuickMovie,CheckConservDen,PlotMeRightRes,ShowRunTime);
            %Run it
            [A,C,DidIBreak,SteadyState] = ChemDiffMainDirVn(ParamObj,TimeObj,AnalysisObj);
            FluxMeasuredEnd = ( A(end) - A(end-1) ) .* (Nx-1)./ Lbox;
            FluxDiff = FluxMeasuredEnd;
        end
        
        Flux4PhaseMat(ii,:,:) = FluxDiff;
        fprintf('Diffusion SteadyState = %d\n',SteadyState)
        SteadyStateMat(ii,:,:) = SteadyState;
    else % Possibly not diffusion
        for jj = 1:KoffNum
            Koff = KoffVec(jj);
            Kon  = KDinv .* Koff;
            if Kon == 0 % Diffusion
                nu = 0;
                if SteadyStateODE
                    SteadyState = 1;
                    [Ass,Css,x] = RdSsSolverMatBvFunc(...
                        Kon,Koff,nu,AL,AR,Bt,Lbox,BCstr,Nx,NLcoup);
                    FluxDiff = ( Ass(end-1) - Ass(end) ) ./ (x(2) - x(1));
                else
                    %Build Objects
                    [ParamObj] = ParamObjMakerRD(0,ChemOnEndPts,Nx,Lbox,Lr,A_BC,C_BC,Kon,Koff,nu,Dnl,...
                        NLcoup,Bt,AL,AR,trial);
                    [TimeObj] = TimeObjMakerRD(dt,t_tot,t_rec,ss_epsilon,NumPlots);
                    [AnalysisObj] = AnalysisObjMakerRD(TrackAccumFromFlux,...
                        TrackAccumFromFluxPlot, PlotMeMovAccum, PlotMeLastConcAccum,...
                        PlotMeLastConc,QuickMovie,CheckConservDen,PlotMeRightRes,ShowRunTime);
                    %Run it
                    [A,C,DidIBreak,SteadyState] = ChemDiffMainDirVn(ParamObj,TimeObj,AnalysisObj);
                    FluxMeasuredEnd = ( A(end) - A(end-1) ) .* (Nx-1)./ Lbox;
                    FluxDiff = FluxMeasuredEnd;
                end
%                 NxMat(ii,jj,:) = length(x);
                Flux4PhaseMat(ii,jj,:) = FluxDiff;
%                 fprintf('Diffusion SteadyState = %d\n',SteadyState)
                SteadyStateMat(ii,jj,:) = SteadyState;
            else % Not diffusion
                for kk = 1:nuNum
                    nu = nuVec(kk);
                    if SteadyStateODE
                        SteadyState = 1;
                        [Ass,Css,x] = RdSsSolverMatBvFunc(...
                            Kon,Koff,nu,AL,AR,Bt,Lbox,BCstr,Nx,NLcoup);
                        FluxMeasuredEnd = ( Ass(end-1) - Ass(end) ) ./ (x(2) - x(1));
                    else
                        %Build Objects
                        [ParamObj] = ParamObjMakerRD(0,ChemOnEndPts,Nx,Lbox,Lr,A_BC,C_BC,Kon,Koff,nu,Dnl,...
                            NLcoup,Bt,AL,AR,trial);
                        [TimeObj] = TimeObjMakerRD(dt,t_tot,t_rec,ss_epsilon,NumPlots);
                        [AnalysisObj] = AnalysisObjMakerRD(TrackAccumFromFlux,...
                            TrackAccumFromFluxPlot, PlotMeMovAccum, PlotMeLastConcAccum,...
                            PlotMeLastConc,QuickMovie,CheckConservDen,PlotMeRightRes,ShowRunTime);
                        %Run it
                        [A,C,DidIBreak,SteadyState] = ChemDiffMainDirVn(ParamObj,TimeObj,AnalysisObj);
                        FluxMeasuredEnd = ( A(end) - A(end-1) ) .* (Nx-1)./ Lbox;
              
                    end
%                     NxMat(ii,jj,kk) = length(x);
                    Flux4PhaseMat(ii,jj,kk) = FluxMeasuredEnd;
                    SteadyStateMat(ii,jj,kk) = SteadyState;
                    %                     fprintf('KDinv: %d/%d Koff: %d/%d nu = %d/%d SteadyState = %d\n',...
                    %                         ii,length(KDinvVec),jj,length(KoffVec),kk,length(nuVec),SteadyState)
                end %nu loop
            end% if Kon == 0
        end % Koff Loop
    end %if KDinv == 0
end % KDinv loop
% keyboard
[nu2D,Koff2D] = meshgrid(nuVec,KoffVec);
PhaseMat = Flux4PhaseMat ./ FluxDiff;


if SaveAll
    if SteadyStateODE
    savestr = sprintf('PPNx%dKDinv%dNu%dKoff%dSSode.mat',...
                Nx,KDinvNum, nuNum,KoffNum);
    else
        savestr = sprintf('PPNx%dKDinv%dNu%dKoff%dSSpde.mat',...
                Nx,KDinvNum, nuNum,KoffNum);
    end
    save(savestr,'PhaseMat','KoffVec','nuVec','KDinv',...
            't_tot','Lbox','Nx')
            
    MaxPhaseParam = max(max(max(Flux4PhaseMat ./ FluxDiff )));
    for ii = 1:KDinvNum
        PhaseMatKdFix = reshape(Flux4PhaseMat(ii,:,:),[KoffNum nuNum] ) ./ FluxDiff;
        SteadyStateKdFix = reshape(SteadyStateMat(ii,:,:),[KoffNum nuNum] ) ;
        KDinv = KDinvVec(ii);
        if SteadyStateODE
            savestr = sprintf('PPKoffVaryKD1e%dNx%dNu%dKoff%dSSode',...
                log10(KDinv),Nx,nuNum,KoffNum);
        elseif SteadyStateKdFix
            savestr = sprintf('PPKoffVaryKD1e%dNx%dNu%dKoff%dSS',...
                log10(KDinv),Nx,t_tot,nuNum,KoffNum);
        else
            savestr = sprintf('PPKoffVaryKD1e%dNx%dt%dNu%dKoff%d',...
                log10(KDinv),Nx,t_tot,nuNum,KoffNum);
        end
        
        save(strcat(savestr,'.mat'),'PhaseMatKdFix','SteadyStateODE',...
            'SteadyStateKdFix',...
            'MaxPhaseParam','KoffVec','nuVec','KDinv',...
            't_tot','Lbox','Nx','-mat')
    end
    
end %Save all

fprintf('Finished run\n')
toc
% ChemDiffMainPBCft
if SaveAll
    diary off
    mkdir(Where2SavePath)
    movefile('*.mat', Where2SavePath)
    movefile('*.txt', Where2SavePath)
end





