function PlotLastConc(...
    Ass,Css,x,Paramstr,Gridstr,Concstr,trial)
  
%Plot Concentration at final time step

figure()
plot(x,Ass,x,Css,x,Ass+Css )
legend('A','C','A + C')
xlabel('x'); ylabel('Concentration');
titstr =  sprintf('Concentration at last time point trial %d', trial);
title(titstr)
try
  textbp(Paramstr)
  textbp(Concstr)
  textbp(Gridstr)
catch err
    fprintf('%s', err.getReport('extended')) ;
end

end