%% Movie and Accumulation PLotter

function WavefrontAndAccumPlotter(...
    A_rec,C_rec,x,TimeRec,N_rec,NumPlots,Kon,Koff,nu,Dnl,AL,Bt)

deltaN   = floor(N_rec / NumPlots);
NplotInt = 1:deltaN:N_rec-deltaN;

figure()
% Plot the concentration at certain time points
subplot(2,1,1)
plot(x,A_rec(:,NplotInt) + C_rec(:,NplotInt) )
xlabel('position'); ylabel('[A] + [C]');
title('Total Concentration in Gel vs. position at equally spaced time points')
% Plot the accumulation
subplot(2,1,2)

h = plot(TimeRec,A_rec(end,:)/AL,...
    TimeRec(NplotInt),A_rec(end,NplotInt)/AL,'x','MarkerSize',10 );
set(h(2),'linewidth',2)
xlabel('Time'); ylabel('A/A_{max}'); 
title('Accumulation in Right Reservior');

% I have no idea why I need to do this, but I get a textbp error if not
pause(0.1) 
% List the variables
ParamStr = sprintf(...
       ' Kon = %.1e \n Koff = %.1e \n nu = %.1e \n Dnl = %.1e \n  Bt = %.1e \n AL = %.1e \n ', ...
         Kon,Koff,nu,Dnl,Bt,AL);
textbp(ParamStr)
% keyboard
end