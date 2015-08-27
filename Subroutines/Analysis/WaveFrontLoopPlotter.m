%% Loop
clear
linear = 0;
trial_start = 53;
N_trial     = 4;
trial = trial_start;
alpha = 0.4;  % Fraction of max concentration you want to study
PlotMe = 0;

if linear
    FileStrRoot = sprintf('ConsLinNdFD_t');
else
    FileStrRoot = sprintf('ConsNLNdFD_t');
end

broken = 0;
for i = 1:N_trial
    FileStr = sprintf('%s%d.mat',FileStrRoot,trial);
    load(FileStr)
    %     keyboard
    if i == 1
        [NrecInt, NxInt] = size(A_rec);
        xTrackMat = zeros( N_trial,NrecInt);
        ALtemp = AL;
        ALprev = ALtemp;
    else
        [NrecTemp, NxTemp] = size(A_rec);
        ALtemp = AL;
        if (NrecTemp ~= NrecInt) || (NxTemp ~=  NxInt)
            fprintf('Holy Canoli Sir! The records are changing sizes!\n')
            fprintf('Trail %d: Nrec = %d Nx =%d\nTrial %d: Nrec = %d Nx =%d\n',...
                trial_start,NrecInt,NxInt, trial,NrecTemp,NxTemp)
            broken = 1;
            break
        end
        if (ALprev ~= ALtemp)
            fprintf('Holy Canoli Sir! AL is changin!\n')
            fprintf('Trail %d: AL = %.2e\nTrial %d: AL = %.2e\n',...
                trial_start,ALprev, trial,ALtemp)
        end % end if error
        
    end % end if trial
    % Track the wave front
    KDinvtemp = 1/ParamVec(1);
    nu     = ParamVec(2);
    if KDinvtemp <= 1
        LegStrTemp = sprintf('NoChem nu=%.1e',nu);
    else
        LegStrTemp = sprintf('Kdinv=%.1e nu=%.1e',KDinvtemp,nu);
    end
    
    LegendCell{i} = LegStrTemp;
    
    [xDesVsTimeTemp,DesConTemp] = WaveFrontTracker(A_rec+C_rec,TimeRec,x_trim,alpha,PlotMe);
    xTrackMat(i,:) = xDesVsTimeTemp;
    
    ALprev = ALtemp;
    trial = trial + 1;
end
trial = trial  - 1;
x2Mat = xTrackMat.^2;
 if broken == 0
figure
plot(TimeRec,x2Mat)
TitlStr = sprintf('wavefront displacement AL = %.2e Bt = %.2e',AL,Bt);
xlabel('Time'); ylabel('x^2'); title(TitlStr)
legend(LegendCell,'Location','best')
 end