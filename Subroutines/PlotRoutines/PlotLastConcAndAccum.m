function PlotLastConcAndAccum(...
    A_rec,C_rec,x,Paramstr,Gridstr,Concstr,TimeRec,trial)


%Parameter strings
%Plot Concentration at final time step
figure()
subplot(1,2,1)
plot(x,A_rec(:,end),x,C_rec(:,end),x,A_rec(:,end)+C_rec(:,end) )
legend('A','C','A + C')
xlabel('x'); ylabel('Concentration');
titstr =  sprintf('Concentration at last time point trial %d', trial);
title(titstr)
textbp(Paramstr)
pause(0.1)
textbp(Concstr)

%Plot accumulation
subplot(1,2,2)
plot( TimeRec, A_rec(end,:)/max(max(A_rec)) )
xlabel('t');ylabel('A/A_{max}'); title('Accumulation')
set(gca,'xLim',[0,TimeRec(end)])
textbp(Gridstr)
end