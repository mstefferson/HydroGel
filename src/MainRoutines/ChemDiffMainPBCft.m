% ChemDiffMainPBCft
% A bc VN C bc VN
function [A,C,DidIBreak,SteadyState] = ChemDiffMainPBCft(paramObj,timeObj,analysisFlags)
% Define commonly used variables
DidIBreak = 1;
Nx = paramObj.Nx;
% Fix LR
paramObj.Lr = 0;
% keyboard
%Spatial grid
[x,dx]  = Gridmaker1DPBC(paramObj.Lbox,Nx);
kx      = -pi / dx:  2 * pi / paramObj.Lbox: pi/dx -2 * pi / paramObj.Lbox;

GridObj = struct('Nx',Nx, 'Lbox',paramObj.Lbox,'Lr', paramObj.Lr,...
    'dx', dx, 'x', x,'kx',kx,'VNcoef', timeObj.dt/dx^2);
Gridstr = sprintf('Nx=%d\nLbox=%.1f',...
    GridObj.Nx,GridObj.Lbox);
% Strings
BCstr    = sprintf('A_BC: %s \nC_BC = %s',paramObj.A_BC,paramObj.C_BC);
Paramstr = sprintf('Kon=%.1e\nKoff=%.1e\nnu=%.2e\nDnl=%.1e',...
    paramObj.kon,paramObj.koff,paramObj.nu,paramObj.Dnl);
Concstr = sprintf('paramObj.paramObj.Bt=%.1e\nAL=%.1e\nAR=%.2e',...
    paramObj.Bt,paramObj.AL,paramObj.AR);

%Inital Densisy
A = paramObj.AL .* exp(-x.^2);
if paramObj.kon ~= 0
    epsilonperp = 0.1;
    C = paramObj.kon * paramObj.Bt .* ...
        ( A ./ (paramObj.koff + paramObj.kon .* A)  +...
        epsilonperp .* paramObj.AL ./ ...
        (paramObj.koff + paramObj.kon .* paramObj.AL)* cos(pi*x) );
else
    C = zeros(1,length(x));
end
v = [A C];
Aft = fftshift(fft(A));
Cft = fftshift(fft(C));

% Concentration records
A_rec   = zeros(Nx,timeObj.N_rec);
C_rec   = zeros(Nx,timeObj.N_rec);
Aft_rec   = zeros(Nx,timeObj.N_rec);
Cft_rec   = zeros(Nx,timeObj.N_rec);
A_rec(:,1)   = A;
C_rec(:,1)   = C;
Aft_rec(:,1) = Aft;
Cft_rec(:,1) = Cft;
j_record = 2;

%Build operators and matrices
Aprop   = exp(-kx.^2 * timeObj.dt);
Cprop   = exp(-paramObj.nu * kx.^2 * timeObj.dt);
% NonLinear Include endpoints Dirichlet, then set = 0
if flags.NLcoup
    [Chem] = ...
        CoupChemAllCalc([A C],paramObj.Bt,paramObj.kon,paramObj.koff,Nx);
else
    [Chem] = ...
        CoupChemAllCalcLin([A C],paramObj.Bt,paramObj.kon,paramObj.koff,Nx);
end


ANL_FT = fftshift(fft( Chem(1:Nx)' ));
CNL_FT = fftshift(fft( Chem(Nx+1:2*Nx)' ));
% Step
Anext_FT = Aprop .* Aft + timeObj.dt.* ANL_FT;
Cnext_FT = Cprop .* Cft + timeObj.dt.* CNL_FT;

% Time loop
SteadyState = 0;
if analysisFlags.ShowRunTime; tic; end
for t = 1: timeObj.N_time - 1 % t * dt  = time
    
    % Update
    Aprev_FT = Aft;
    Cprev_FT = Cft;
    
    Aft = Anext_FT;
    Cft = Cnext_FT;
    
    A = real( ifft(ifftshift(Aft)) );
    C = real( ifft(ifftshift(Cft)) );
    
    ChemPrev = Chem;
    
    %Non linear. Include endpoints, then set = 0
    if flags.NLcoup
        [Chem] = ...
            CoupChemAllCalc([A C],paramObj.Bt,paramObj.kon,paramObj.koff,Nx);
    else
        [Chem] = ...
            CoupChemAllCalcLin([A C],paramObj.Bt,paramObj.kon,paramObj.koff,Nx);
    end
    ANL_FT = fftshift(fft( Chem(1:Nx)' ));
    CNL_FT = fftshift(fft( Chem(Nx+1:2*Nx)' ));
    
    % Step
    Anext_FT = Aprop .* (Aft + timeObj.dt.* ANL_FT);
    Cnext_FT = Cprop .* (Cft + timeObj.dt.* CNL_FT);
    
    % Save stuff
    if (mod(t,timeObj.N_count)== 0)
        Anext = real( ifft(ifftshift( Anext_FT )) );
        Cnext = real( ifft(ifftshift( Cnext_FT )) );
        v = [A C];
        vNext = [Anext Cnext];
        
        if min(v) < 0
            fprintf('Something went negative\n')
            analysisFlags.QuickMovie = 0; SaveMe = 0;
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
            if max( abs( (v-vNext)./v ) ) < timeObj.ss_epsilon
                A_rec = A_rec(:,1:j_record);
                C_rec = C_rec(:,1:j_record);
                SteadyState = 1;
                TimeRec = timeObj.t_rec .* [0:j_record-1];
                fprintf('Steady State time = %.1f\n',timeObj.dt*t)
                %             keyboard
                break
            end % end steady state
            
            j_record = j_record + 1;
            
        end % save stuff
    end % time loop
    % keyboard
    if analysisFlags.ShowRunTime; toc; end
    % Last step
    t = t+1;
    
    if (mod(t,timeObj.N_count)==0)
        Anext = real( ifft(ifftshift( Anext_FT )) );
        Cnext = real( ifft(ifftshift( Cnext_FT )) );
        A_rec(:,j_record)   = Anext;
        C_rec(:,j_record)   = Cnext;
        Aft_rec(:,j_record) = Aft;
        Cft_rec(:,j_record) = Cft;
    end

% Store the total concentrations
if ~SteadyState
    TimeRec = timeObj.t_rec .* [0:timeObj.N_rec-1];
else
    timeObj.N_rec = j_record;
end
% Total B
B_rec = paramObj.Bt - C_rec;

% RecObj
RecObj = struct('A_rec', A_rec,'B_rec',B_rec,'C_rec',C_rec,...
    'Aft_rec',Aft_rec,'Cft_rec',Cft_rec,'TimeRec',TimeRec,'SteadyState',SteadyState);

%Check for negative densities
[DidIBreak] =  NegDenChecker(A_rec,C_rec,B_rec,paramObj.trial);

% keyboard
if flags.SaveMe
    saveStr = sprintf('ConsPBCNL%d_t%d',flags.NLcoup,paramObj.trial);
    save(saveStr,'paramObj','GridObj','timeObj','analysisFlags','RecObj')
    %     movefile('*.mat', OutputDir)
end

if analysisFlags.QuickMovie
    MAll = ConcenMovieMakerTgthr1D(A_rec, C_rec,...
        x,TimeRec,timeObj.N_rec,Nx,paramObj.kon,paramObj.koff,...
        paramObj.Dnl,paramObj.nu,paramObj.Bt,paramObj.kA);
end

if analysisFlags.CheckConservDen
    ConservCheckerPBC(x,A_rec,C_rec,TimeRec)
end

if analysisFlags.PlotMeRightRes
    figure()
    %    ReservConcVsTimePlotter(TimeRec,A_rec,AllParamVec,trial)
    plot(TimeRec,A_rec(end,:)/paramObj.AL )
    titstr = sprintf('Nx = %d Lbox = %.1f',Nx,paramObj.Lbox);
    title(titstr)
end

if analysisFlags.PlotMeMovAccum
    WavefrontAndAccumPlotter(A_rec,C_rec,x,TimeRec,timeObj.N_rec,timeObj.NumPlots,...
        paramObj.kon,paramObj.koff,paramObj.nu,paramObj.Dnl,...
        paramObj.AL,paramObj.Bt)
end

if analysisFlags.PlotMeLastConcAccum
    PlotLastConcAndAccum(...
        A_rec,C_rec,x,Paramstr,Gridstr,Concstr,TimeRec,paramObj.trial)
end

if analysisFlags.PlotMeLastConc
    PlotLastConc(...
        A_rec(:,end),C_rec(:,end),x,Paramstr,Gridstr,Concstr,paramObj.trial)
end


