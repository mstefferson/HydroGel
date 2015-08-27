%% Accum Max on all 3
function AccumMaxAll3Plotter(LboxLoop,NxMult,AccumMatDiff,AccumMatnu0,AccumMatnu1,...
   ParamStrnu0, ParamStrnu1,ParamStr2,AllParamMatnu0, SavePlot)
figure
plot(LboxLoop, AccumMatDiff(:,3),LboxLoop, AccumMatnu0(:,3),...
    LboxLoop, AccumMatnu1(:,3))
legend('Diff','nu = 0','nu = 1','Location','best')
titstr = sprintf('Max Accumulation Nx = %d for Lbox = %0.f',...
    NxMult,LboxLoop(1));
title(titstr)
xlabel('Box length'); ylabel('Max Accumulation');
textbp(ParamStrnu0)
textbp(ParamStrnu1)
textbp(ParamStr2)
if SavePlot
    if log10(AllParamMatnu0(1,2)) < 0
        savestr = sprintf('AcMxAllCmprKn1e%dKf1em%d.jpg',...
            log10(AllParamMatnu0(1,1)),-log10(AllParamMatnu0(1,2)));
    else
        savestr = sprintf('AcMxAllCmprKn1e%dKf1e%d.jpg',...
            log10(AllParamMatnu0(1,1)),log10(AllParamMatnu0(1,2)));
    end
    saveas(gcf,savestr,'jpg');
end


%
figure
loglog(LboxLoop, AccumMatDiff(:,3),LboxLoop, AccumMatnu0(:,3),...
    LboxLoop, AccumMatnu1(:,3))
legend('Diff','nu = 0','nu = 1','Location','best')
titstr = sprintf('LogLog Max Accumulation Nx = %d for Lbox = %0.f',...
    NxMult,LboxLoop(1));
title(titstr)
xlabel('Box length'); ylabel('Max Accumulation');
textbp(ParamStrnu0)
textbp(ParamStrnu1)
textbp(ParamStr2)

if SavePlot
    if log10(AllParamMatnu0(1,2)) < 0
        savestr = sprintf('LLAcMxAllCmprKn1e%dKf1em%d.jpg',...
            log10(AllParamMatnu0(1,1)),-log10(AllParamMatnu0(1,2)));
    else
        savestr = sprintf('LLAcMxAllCmprKn1e%dKf1e%d.jpg',...
            log10(AllParamMatnu0(1,1)),log10(AllParamMatnu0(1,2)));
    end
    saveas(gcf,savestr,'jpg');
end


end