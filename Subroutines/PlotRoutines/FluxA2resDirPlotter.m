% Plots the flux of A at the end of the box vs time and what the
% acuumulation would be from that flux vs. time

function FluxA2resDirPlotter(...
    AL,Bt,AR,v,Nx,nu,Lbox,dx,AccumMax,Flux2ResR,TimeRec,...
    FluxAccum_rec,Flux2ResR_rec,Paramstr,Gridstr)

    FluxMax = (AL + Bt - AR) / Lbox;
    FluxC   = ( v(2*Nx-1) - v(2*Nx) ) ./ dx;
%     AccumMax = (AL + Bt - AR) / Lbox .* t*dt; 

    FluxMeasured = Flux2ResR;
    if nu == 1
        FluxCalculate = ( (v(1) + v(Nx+1) ) - (v(Nx) + v(2*Nx) ) ) / Lbox;
        
        FluxStr = sprintf('steady state\njA Meas =%.3e\n jC Meas =%.3e \n jA Calc=%.3e',...
            FluxMeasured,FluxC,FluxCalculate);
  
    elseif nu == 0
        FluxCalculate = ( v(1) - v(Nx) ) / Lbox;
        FluxStr = sprintf('steady state\njA Measured=%.3e\n jA Calc=%.3e',...
            FluxMeasured,FluxCalculate);
    else
        FluxStr = sprintf('j Measured=%.3e\n S.S. ?? flux\n',FluxMeasured);
    end
    
    
    figure
    [AX,H1,H2] = plotyy(TimeRec,FluxAccum_rec,TimeRec,Flux2ResR_rec);
    ylabel(AX(1),'Accumluation');ylabel(AX(2),'Flux');xlabel('Time')
    title('Flux and "Accumulation" into Outlet (Dir BC on A)')
    YfluxTick =  0:FluxMax/10:FluxMax;
    YAccumTick =  0:AccumMax/10:AccumMax;
    set(AX(2),'YLim',[0 FluxMax],'YTick',YfluxTick)
    set(AX(1),'YLim',[0 AccumMax],'YTick',YAccumTick)
    textbp(FluxStr)
    textbp(Paramstr)
    textbp(Gridstr)
    
end