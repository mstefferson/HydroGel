% Plots accumulation rate vs box length for the diffusion, nu =0, and nu = 1
% cases

%% Accum Start time on all 3
function AccumStartAll3Plotter(LboxLoop,NxMult,AccumMatDiff,AccumMatnu0,AccumMatnu1,...
   ParamStrnu0, ParamStrnu1,ParamStr2,AllParamMatnu0, SavePlot)
figure
plot(LboxLoop, AccumMatDiff(:,1),LboxLoop, AccumMatnu0(:,1),...
    LboxLoop, AccumMatnu1(:,1))
legend('Diff','nu = 0','nu = 1','Location','best')
titstr = sprintf('Accumulation start time Nx = %d for Lbox = %0.f',...
    NxMult,LboxLoop(1));
title(titstr)
xlabel('Box length'); ylabel('Time till accumulation begins');
textbp(ParamStrnu0)
textbp(ParamStrnu1)
textbp(ParamStr2)

if SavePlot
    if log10(AllParamMatnu0(1,2)) < 0
        savestr = sprintf('AcStAllCmprKn1e%dKf1em%d.jpg',...
            log10(AllParamMatnu0(1,1)),-log10(AllParamMatnu0(1,2)));
    else
        savestr = sprintf('AcStAllCmprKn1e%dKf1e%d.jpg',...
            log10(AllParamMatnu0(1,1)),log10(AllParamMatnu0(1,2)));
    end
    saveas(gcf,savestr,'jpg');
end


%
figure
loglog(LboxLoop, AccumMatDiff(:,1),LboxLoop, AccumMatnu0(:,1),...
    LboxLoop, AccumMatnu1(:,1))
legend('Diff','nu = 0','nu = 1','Location','best')
titstr = sprintf('LogLog Accumulation start time Nx = %d for Lbox = %0.f',...
    NxMult,LboxLoop(1));
xlabel('Box length'); ylabel('Time till accumulation begins');
textbp(ParamStrnu0)
textbp(ParamStrnu1)
textbp(ParamStr2)

if SavePlot
    if log10(AllParamMatnu0(1,2)) < 0
        savestr = sprintf('LLAcStAllCmprKn1e%dKf1em%d.jpg',...
            log10(AllParamMatnu0(1,1)),-log10(AllParamMatnu0(1,2)));
    else
        savestr = sprintf('LLAcStAllCmprKn1e%dKf1e%d.jpg',...
            log10(AllParamMatnu0(1,1)),log10(AllParamMatnu0(1,2)));
    end
    saveas(gcf,savestr,'jpg');
end


end