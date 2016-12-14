% Plots the flux of A at the end of the box vs time and what the
% acuumulation would be from that flux vs. time

function FluxA2resDirPlotter(...
    AL,Bt,AR,A_tend,C_tend, nu,Lbox,dx, TimeRec,...
    FluxAccum_rec,Flux2ResR_rec,Paramstr,Concstr,Gridstr)

    % Calculate some fluxes
    FluxMax = (AL + Bt(1) - AR) / Lbox; % Max possible flux
    FluxC   = ( C_tend(end-1) - C_tend(end) ) ./ dx; % Flux from C

    FluxMeasured = Flux2ResR_rec(end);
    % If nu = 1,0 we know what the flux should be
    if nu == 1
        FluxCalculate = ...
        ( (A_tend(1) + C_tend(1) ) - ( A_tend(end) + C_tend(end) ) ) / Lbox;
        FluxStr = sprintf('steady state \n jA Meas =%.3e \n jC Meas =%.3e \n jA Calc=%.3e',...
            FluxMeasured,FluxC,FluxCalculate);
    elseif nu == 0
        FluxCalculate = ( A_tend(1) - A_tend(end) ) / Lbox;
        FluxStr = sprintf('steady state \n jA Measured=%.3e \n jA Calc=%.3e',...
            FluxMeasured,FluxCalculate);
    else
        FluxStr = sprintf('j Measured=%.3e \n S.S. ?? flux\n',FluxMeasured);
    end
    
    % Plot
    figure
    [AX,~,~] = plotyy(TimeRec,FluxAccum_rec,TimeRec,Flux2ResR_rec);
    ylabel(AX(1),'Accumluation');ylabel(AX(2),'Flux');xlabel('Time')
    title('Flux and "Accumulation" into Outlet (Dir BC on A)')
%     YfluxTick =  0:FluxMax/10:FluxMax;
%     YAccumTick =  0:AccumMax/10:AccumMax;
%     set(AX(2),'YLim',[0 FluxMax],'YTick',YfluxTick)
%     set(AX(1),'YLim',[0 AccumMax],'YTick',YAccumTick)
try
    textbp(FluxStr)
    textbp(Paramstr)
    textbp(Concstr)
    textbp(Gridstr)
catch
  fprintf('Issues with textbp, no parameter strings\n');
end
    
end
