function ReservConcVsTimeSubPlotter(TimeRec,A_rec,AllParamVec,trial)
   
maxA = max(max(A_rec));
ParamStr = sprintf('KDinv = %.2e nu = %.2e  AL = %.2e Bt = %.2e t%d',...
        AllParamVec(1),AllParamVec(2),AllParamVec(3),AllParamVec(4),trial);
   
    
% keyboard
subplot(2,1,1)
   plot( TimeRec, A_rec(:,1) ./ maxA);
   set(gca,'YLim',[0 1]);
   set(gca,'YTick',[0 0.5 1]);
   xlabel('Time'); ylabel('Left Reservior [A]/AL');
   titstr = sprintf('Concen in Reserv vs time %s',ParamStr);
   title(titstr);
   
   subplot(2,1,2)
   plot( TimeRec, A_rec(:,end) ./ maxA);
   set(gca,'YLim',[0 1]);
   set(gca,'YTick',[0 0.5 1]);
   xlabel('Time'); ylabel('Right Reservior [A]/AL');
   
   
end