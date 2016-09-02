% Max slope of accumulation
function AccumMaxAccRate3Plotter(LboxLoop,NxMult,SlopeMatDiff,SlopeMatnu0,SlopeMatnu1,...
   ParamStrnu0, ParamStrnu1,ParamStr2,AllParamMatnu0,SavePlot)
figure
plot( LboxLoop, SlopeMatDiff(:,1), LboxLoop, SlopeMatnu0(:,1), ...
   LboxLoop, SlopeMatnu1(:,1) )
legend('Diff','nu = 0','nu = 1','Location','best')
titstr = sprintf('Max Accumulation Rate Nx = %d for Lbox = %0.f',...
    NxMult,LboxLoop(1));
title(titstr)
xlabel('Box length'); ylabel('Max Accumulation Rate');
textbp(ParamStrnu0)
textbp(ParamStrnu1)
textbp(ParamStr2)

if SavePlot
    if log10(AllParamMatnu0(1,2)) < 0
        savestr = sprintf('AcMxRtAllCmprKn1e%dKf1em%d.jpg',...
            log10(AllParamMatnu0(1,1)),-log10(AllParamMatnu0(1,2)));
    else
        savestr = sprintf('AcMxRtAllCmprKn1e%dKf1e%d.jpg',...
            log10(AllParamMatnu0(1,1)),log10(AllParamMatnu0(1,2)));
    end
    saveas(gcf,savestr,'jpg');
end


figure
loglog(LboxLoop, SlopeMatDiff(:,1), LboxLoop, SlopeMatnu0(:,1), ...
   LboxLoop, SlopeMatnu1(:,1) );
legend('Diff','nu = 0','nu = 1','Location','best')
titstr = sprintf('LogLog Max Accumulation Rate Nx = %d for Lbox = %0.f',...
    NxMult,LboxLoop(1));
title(titstr)
xlabel('Box length'); ylabel('Max Accumulation Rate');
textbp(ParamStrnu0)
textbp(ParamStrnu1)
textbp(ParamStr2)

if SavePlot
    if log10(AllParamMatnu0(1,2)) < 0
        savestr = sprintf('LLAcMxRtAllCmprKn1e%dKf1em%d.jpg',...
            log10(AllParamMatnu0(1,1)),-log10(AllParamMatnu0(1,2)));
    else
        savestr = sprintf('LLAcMxRtAllCmprKn1e%dKf1e%d.jpg',...
            log10(AllParamMatnu0(1,1)),log10(AllParamMatnu0(1,2)));
    end
    saveas(gcf,savestr,'jpg');
end


end
