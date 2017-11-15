function PlotLastConc(...
    Ass,Css,x,paramStr,gridStr,concStr )
  
%Plot Concentration at final time step

figure()
plot(x,Ass,x,Css,x,Ass+Css )
legend('A','C','A + C')
xlabel('x'); ylabel('Concentration');
titstr =  ['Concen. ' gridStr];
title(titstr)
try
  textbp(paramStr)
  textbp(gridStr)
  textbp(concStr)
catch err
    fprintf('%s', err.getReport('extended')) ;
end

end
