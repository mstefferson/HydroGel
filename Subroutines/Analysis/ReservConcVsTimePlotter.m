function ReservConcVsTimePlotter(TimeRec,A_rec,AllParamVec,trial)
   
maxA = max(max(A_rec));

% keyboard
   [hAx H1 H2] = plotyy( TimeRec, A_rec(:,1) ./ maxA,...
                         TimeRec, A_rec(:,end) ./ maxA );
   set(hAx(1),'YLim',[0 1]);set(hAx(2),'YLim',[0 1]);
   set(hAx(1),'YTick',[0 0.5 1]);set(hAx(2),'YTick',[0 0.5 1]);
   
   ylabel(hAx(1),'Left reservoir'); ylabel(hAx(2),'Right reservoir')  
   ParamStr = sprintf('KDinv = %.2e nu = %.2e  AL = %.2e Bt = %.2e t%d',...
        AllParamVec(1),AllParamVec(2),AllParamVec(3),AllParamVec(4),trial);
   titstr = sprintf('Concen in Reserv vs time %s',ParamStr);
   title(titstr);xlabel('Time'); 
   
   
end