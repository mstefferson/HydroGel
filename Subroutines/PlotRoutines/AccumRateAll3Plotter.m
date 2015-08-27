% Plots accumulation rate vs box length for the diffusion, nu =0, and nu = 1
% cases

%% Accum Rate on all 3
function AccumRateAll3Plotter(LboxLoop,NxMult,AccumMatDiff,AccumMatnu0,AccumMatnu1,...
    ParamStrnu0, ParamStrnu1,ParamStr2,AllParamMatnu0,SavePlot)
figure
plot(LboxLoop, AccumMatDiff(:,2),LboxLoop, AccumMatnu0(:,2),...
    LboxLoop, AccumMatnu1(:,2))
legend('Diff','nu = 0','nu = 1','Location','best')
titstr = sprintf('Accumulation rate Nx = %d for Lbox = %0.f',...
    NxMult,LboxLoop(1));
title(titstr)
xlabel('Box length'); ylabel('rate');
textbp(ParamStrnu0)
textbp(ParamStrnu1)
textbp(ParamStr2)
if SavePlot
    if log10(AllParamMatnu0(1,2)) < 0
        savestr = sprintf('AcRtAllCmprKn1e%dKf1em%d.jpg',...
            log10(AllParamMatnu0(1,1)),-log10(AllParamMatnu0(1,2)));
    else
        savestr = sprintf('AcRtAllCmprKn1e%dKf1e%d.jpg',...
            log10(AllParamMatnu0(1,1)),log10(AllParamMatnu0(1,2)));
    end
    saveas(gcf,savestr,'jpg');
end

%
figure
loglog(LboxLoop, AccumMatDiff(:,2),LboxLoop, AccumMatnu0(:,2),...
    LboxLoop, AccumMatnu1(:,2))
legend('Diff','nu = 0','nu = 1','Location','best')
titstr = sprintf('Log log Accumulation rate Nx = %d for Lbox = %0.f',...
    NxMult,LboxLoop(1));
title(titstr)
xlabel('Box length'); ylabel('Time till accumulation begins');
textbp(ParamStrnu0)
textbp(ParamStrnu1)
textbp(ParamStr2)


if SavePlot
    if log10(AllParamMatnu0(1,2)) < 0
        savestr = sprintf('LLAcRtAllCmprKn1e%dKf1em%d.jpg',...
            log10(AllParamMatnu0(1,1)),-log10(AllParamMatnu0(1,2)));
    else
        savestr = sprintf('LLAcRtAllCmprKn1e%dKf1e%d.jpg',...
            log10(AllParamMatnu0(1,1)),log10(AllParamMatnu0(1,2)));
    end
    saveas(gcf,savestr,'jpg');
end

end