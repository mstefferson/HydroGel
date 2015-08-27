% Compare three plots at the same box length
% 

function CmprAll3SameLboxPlotter(AvsTMatDiff,AvsTMatnu0,AvsTMatnu1,...
    ParamStrDiff,ParamStrnu0,ParamStrnu1,ParamStr2,LboxLoop,NxVec,...
    TimeRecFit,IndHolder, AllParamMatnu0, SavePlot)


figure()
plot(TimeRecFit,AvsTMatDiff(IndHolder,:),TimeRecFit,AvsTMatnu0(IndHolder,:),...
    TimeRecFit,AvsTMatnu1(IndHolder,:))
legend('Diff','nu = 0', 'nu = 1')
textbp(ParamStrDiff);textbp(ParamStrnu0);textbp(ParamStrnu1);
textbp(ParamStr2);
titstr =  sprintf('Accum vs Time Compare Lbox = %.1f Nx = %d',...
    LboxLoop(IndHolder),NxVec(IndHolder) );
title(titstr); xlabel('time'); ylabel('A/Amax')

if SavePlot
    if log10(AllParamMatnu0(1,2)) < 0
        savestr = sprintf('AvTCmprKn1e%dKf1em%dt%d.jpg',...
            log10(AllParamMatnu0(1,1)),-log10(AllParamMatnu0(1,2)),IndHolder);
    else
        savestr = sprintf('AvTCmprKn1e%dKf1e%dt%d.jpg',...
            log10(AllParamMatnu0(1,1)),log10(AllParamMatnu0(1,2)),IndHolder);
    end
    saveas(gcf,savestr,'jpg');
end

figure()
loglog(TimeRecFit,AvsTMatDiff(IndHolder,:),TimeRecFit,AvsTMatnu0(IndHolder,:),...
    TimeRecFit,AvsTMatnu1(IndHolder,:))
legend('Diff','nu = 0', 'nu = 1')
textbp(ParamStrDiff);textbp(ParamStrnu0);textbp(ParamStrnu1);
textbp(ParamStr2);
titstr =  sprintf('LL Accum vs Time Compare Lbox = %.1f Nx = %d',...
    LboxLoop(IndHolder),NxVec(IndHolder) );
title(titstr); xlabel('time'); ylabel('A/Amax')

if SavePlot
    if log10(AllParamMatnu0(1,2)) < 0
        savestr = sprintf('LLAvTCmprKn1e%dKf1em%dt%d.jpg',...
            log10(AllParamMatnu0(1,1)),-log10(AllParamMatnu0(1,2)),IndHolder);
    else
        savestr = sprintf('LLAvTCmprKn1e%dKf1e%dt%d.jpg',...
            log10(AllParamMatnu0(1,1)),log10(AllParamMatnu0(1,2)),IndHolder);
    end
    saveas(gcf,savestr,'jpg');
end



end