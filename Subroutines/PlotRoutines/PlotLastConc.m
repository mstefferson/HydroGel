function PlotLastConc(...
    Ass,Css,x,Paramstr,Gridstr,Concstr,trial)


%Parameter strings
%Plot Concentration at final time step

figure()
plot(x,Ass,x,Css,x,Ass+Css )
legend('A','C','A + C')
xlabel('x'); ylabel('Concentration');
titstr =  sprintf('Concentration at last time point trial %d', trial);
title(titstr)
textbp(Paramstr)
textbp(Concstr)
textbp(Gridstr)
end