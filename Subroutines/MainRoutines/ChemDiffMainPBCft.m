% ChemDiffMainPBCft
% A bc VN C bc VN
function [A,C,DidIBreak,SteadyState] = ChemDiffMainPBCft(ParamObj,TimeObj,AnalysisObj)
% Define commonly used variables
DidIBreak = 1;
Nx = ParamObj.Nx;
% Fix LR
ParamObj.Lr = 0;
% keyboard
%Spatial grid
[x,dx]  = Gridmaker1DPBC(ParamObj.Lbox,Nx);
kx      = -pi / dx:  2 * pi / ParamObj.Lbox: pi/dx -2 * pi / ParamObj.Lbox;

GridObj = struct('Nx',Nx, 'Lbox',ParamObj.Lbox,'Lr', ParamObj.Lr,...
    'dx', dx, 'x', x,'kx',kx,'VNcoef', TimeObj.dt/dx^2);
Gridstr = sprintf('Nx=%d\nLbox=%.1f',...
    GridObj.Nx,GridObj.Lbox);
% Strings
BCstr    = sprintf('A_BC: %s \nC_BC = %s',ParamObj.A_BC,ParamObj.C_BC);
Paramstr = sprintf('Kon=%.1e\nKoff=%.1e\nnu=%.2e\nDnl=%.1e',...
    ParamObj.Kon,ParamObj.Koff,ParamObj.nu,ParamObj.Dnl);
Concstr = sprintf('ParamObj.ParamObj.Bt=%.1e\nAL=%.1e\nAR=%.2e',...
    ParamObj.Bt,ParamObj.AL,ParamObj.AR);

%Inital Densisy
A = ParamObj.AL .* exp(-x.^2);
if ParamObj.Kon ~= 0
    epsilonperp = 0.1;
    C = ParamObj.Kon * ParamObj.Bt .* ...
        ( A ./ (ParamObj.Koff + ParamObj.Kon .* A)  +...
        epsilonperp .* ParamObj.AL ./ ...
        (ParamObj.Koff + ParamObj.Kon .* ParamObj.AL)* cos(pi*x) );
else
    C = zeros(1,length(x));
end
v = [A C];
Aft = fftshift(fft(A));
Cft = fftshift(fft(C));

% Concentration records
A_rec   = zeros(Nx,TimeObj.N_rec);
C_rec   = zeros(Nx,TimeObj.N_rec);
Aft_rec   = zeros(Nx,TimeObj.N_rec);
Cft_rec   = zeros(Nx,TimeObj.N_rec);
A_rec(:,1)   = A;
C_rec(:,1)   = C;
Aft_rec(:,1) = Aft;
Cft_rec(:,1) = Cft;
j_record = 2;

%Build operators and matrices
Aprop   = exp(-kx.^2 * TimeObj.dt);
Cprop   = exp(-ParamObj.nu * kx.^2 * TimeObj.dt);
% NonLinear Include endpoints Dirichlet, then set = 0
if ParamObj.NLcoup
    [Chem] = ...
        CoupChemAllCalc([A C],ParamObj.Bt,ParamObj.Kon,ParamObj.Koff,Nx);
else
    [Chem] = ...
        CoupChemAllCalcLin([A C],ParamObj.Bt,ParamObj.Kon,ParamObj.Koff,Nx);
end


ANL_FT = fftshift(fft( Chem(1:Nx)' ));
CNL_FT = fftshift(fft( Chem(Nx+1:2*Nx)' ));
% Step
Anext_FT = Aprop .* Aft + TimeObj.dt.* ANL_FT;
Cnext_FT = Cprop .* Cft + TimeObj.dt.* CNL_FT;

% Time loop
SteadyState = 0;
if AnalysisObj.ShowRunTime; tic; end
for t = 1: TimeObj.N_time - 1 % t * dt  = time
    
    % Update
    Aprev_FT = Aft;
    Cprev_FT = Cft;
    
    Aft = Anext_FT;
    Cft = Cnext_FT;
    
    A = real( ifft(ifftshift(Aft)) );
    C = real( ifft(ifftshift(Cft)) );
    
    ChemPrev = Chem;
    
    %Non linear. Include endpoints, then set = 0
    if ParamObj.NLcoup
        [Chem] = ...
            CoupChemAllCalc([A C],ParamObj.Bt,ParamObj.Kon,ParamObj.Koff,Nx);
    else
        [Chem] = ...
            CoupChemAllCalcLin([A C],ParamObj.Bt,ParamObj.Kon,ParamObj.Koff,Nx);
    end
    ANL_FT = fftshift(fft( Chem(1:Nx)' ));
    CNL_FT = fftshift(fft( Chem(Nx+1:2*Nx)' ));
    
    % Step
    Anext_FT = Aprop .* (Aft + TimeObj.dt.* ANL_FT);
    Cnext_FT = Cprop .* (Cft + TimeObj.dt.* CNL_FT);
    
    % Save stuff
    if (mod(t,TimeObj.N_count)== 0)
        Anext = real( ifft(ifftshift( Anext_FT )) );
        Cnext = real( ifft(ifftshift( Cnext_FT )) );
        v = [A C];
        vNext = [Anext Cnext];
        
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
            
            A_rec(:,j_record)   = A;
            C_rec(:,j_record)   = C;
            Aft_rec(:,j_record) = Aft;
            Cft_rec(:,j_record) = Cft;
            % Check for steady state. max() is ok with NaN
            if max( abs( (v-vNext)./v ) ) < TimeObj.ss_epsilon
                A_rec = A_rec(:,1:j_record);
                C_rec = C_rec(:,1:j_record);
                SteadyState = 1;
                TimeRec = TimeObj.t_rec .* [0:j_record-1];
                fprintf('Steady State time = %.1f\n',TimeObj.dt*t)
                %             keyboard
                break
            end % end steady state
            
            j_record = j_record + 1;
            
        end % save stuff
    end % time loop
    % keyboard
    if AnalysisObj.ShowRunTime; toc; end
    % Last step
    t = t+1;
    
    if (mod(t,TimeObj.N_count)==0)
        Anext = real( ifft(ifftshift( Anext_FT )) );
        Cnext = real( ifft(ifftshift( Cnext_FT )) );
        A_rec(:,j_record)   = Anext;
        C_rec(:,j_record)   = Cnext;
        Aft_rec(:,j_record) = Aft;
        Cft_rec(:,j_record) = Cft;
    end

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
    'Aft_rec',Aft_rec,'Cft_rec',Cft_rec,'TimeRec',TimeRec,'SteadyState',SteadyState);

%Check for negative densities
[DidIBreak] =  NegDenChecker(A_rec,C_rec,B_rec,ParamObj.trial);

% keyboard
if ParamObj.SaveMe
    saveStr = sprintf('ConsPBCNL%d_t%d',ParamObj.NLcoup,ParamObj.trial);
    save(saveStr,'ParamObj','GridObj','TimeObj','AnalysisObj','RecObj')
    %     movefile('*.mat', OutputDir)
end

if AnalysisObj.QuickMovie
    MAll = ConcenMovieMakerTgthr1D(A_rec, C_rec,...
        x,TimeRec,TimeObj.N_rec,Nx,ParamObj.Kon,ParamObj.Koff,...
        ParamObj.Dnl,ParamObj.nu,ParamObj.Bt,ParamObj.KDinv);
end

if AnalysisObj.CheckConservDen
    ConservCheckerPBC(x,A_rec,C_rec,TimeRec)
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


