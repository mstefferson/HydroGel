%% FluxPhasePlotter
SteadyStateODE = 0;

PlotPhasePort = 1;
PlotVal       = 0;
SaveFig       = 0;

t4load        = 1;
N4load        = 2^10;
Kd4load       = 5;
nuNum         = 11;
KoffNum       = 6;



% Nx = 128;
% loadStr = sprintf('PhasePortKoffVaryKD1e%dNx%dt%d',Kd4load,N4load,t4load);
% loadStr = sprintf('PPKoffVaryKD1e%dNx%dt%dNu%dKoff%d',...
%     Kd4load,N4load,t4load,nuNum,KoffNum);
loadStr = sprintf('PPKoffVaryKD1e%dNx2500Nu%dKoff%dSSode',Kd4load,nuNum,KoffNum);
% loadStr = sprintf('PPKoffVaryKD1e%dNx2500Nu21Koff21SSode',Kd4load);

load(loadStr)
% Lbox = 1;
if SteadyStateODE 
    titstr = sprintf('j/j_{diff} KDinv = %.1e Nx = %d S.S. ODE',...
        KDinv,Nx);
        savestr = sprintf('PPKoffVaryKD1e%dNx%dnu%dKoff%dSSode',...
                log10(KDinv),Nx,nuNum,KoffNum);
elseif SteadyStateKdFix
    titstr = sprintf('j/j_{diff} KDinv = %.1e Nx = %d S.S.',...
        KDinv,Nx);
    savestr = sprintf('PPKoffVaryKD1e%dNx%dnu%dKoff%dSS',...
        log10(KDinv),Nx,nuNum,KoffNum);
else
    titstr = sprintf('j/j_{diff} KDinv = %.1e Nx = %d t_{run} = %d',...
        KDinv,Nx,t_tot);
    savestr = sprintf('PPKoffVaryKD1e%dNx%dnu%dKoff%dt%d',...
        log10(KDinv),Nx,nuNum,KoffNum,t_tot);
end

% MaxPhaseParam = 10;
% PhaseMat = PhaseMatTemp;
PhaseMat = PhaseMatKdFix;
[n,m] = size(PhaseMat);
KoffNum = n;
nuNum = m;
PhaseMat2Plot = zeros(n+1,m+1);
PhaseMat2Plot(1:n,1:m) = PhaseMat;

% PhaseMat = PhaseMatKdFix;

if PlotPhasePort
    figure();
    Ax = gca;
%     pcolor([nuVec 0],1:length(KoffVec)+1,PhaseMat2Plot);
    surf(1:length(nuVec)+1,1:length(KoffVec)+1,PhaseMat2Plot);
%     pcolor(PhaseMat2Plot) 
    colorbar
    xlabel('nu');ylabel('K_{off}');title(titstr);
    
    
    
    % Fix the axis
    Ax.XTick      = 1: floor(length(nuVec)/10): length(nuVec);
    Ax.XTickLabel = num2cell(nuVec(1: floor(length(nuVec)/10): length(nuVec) ) );
    
    Ax.YTick      = 1:length(KoffVec);
    Ax.YTickLabel = num2cell(KoffVec);
    
    hcb=colorbar;
    colorTitleHandle = get(hcb,'Title');
    ColortitleString = 'j/j_{diff}';
    set(colorTitleHandle ,'String',ColortitleString);
    Ax.CLim = [0 MaxPhaseParam];
    Ax.FontSize = 14;
    
    if SaveFig
        saveas(gcf,strcat(savestr,'.jpg'),'jpg')
    end
    
end

if PlotVal
    figure('color', 'w')
    % With numbers
    
    for i=1:KoffNum
        h(i) = subplot(length(KoffVec),1,i);
        plot(nuVec, PhaseMat(KoffNum + 1-i,:));
        Ax = gca;
        Ax.YLim  = [0 MaxPhaseParam];
        Ax.YTick = 0:MaxPhaseParam/4:MaxPhaseParam;
        ylabel( num2str(KoffVec(KoffNum + 1-i)))
    end
    
   if SteadyStateODE 
    titstr = sprintf('j/j_{diff} KDinv = %.1e Nx = %d S.S. ODE',...
        KDinv,Nx);
        savestr = sprintf('PhaseNumKoffVaryKD1e%dNx%dnu%dKoff%dSSode',...
                log10(KDinv),Nx,nuNum,KoffNum);
elseif SteadyStateKdFix
    titstr = sprintf('j/j_{diff} KDinv = %.1e Nx = %d S.S.',...
        KDinv,Nx);
    savestr = sprintf('PhaseNumKoffVaryKD1e%dNx%dnu%dKoff%dSS',...
        log10(KDinv),Nx,nuNum,KoffNum);
else
    titstr = sprintf('j/j_{diff} KDinv = %.1e Nx = %d t_{run} = %d',...
        KDinv,Nx,t_tot);
    savestr = sprintf('PhaseNumeKoffVaryKD1e%dNx%dnu%dKoff%dt%d',...
        log10(KDinv),Nx,nuNum,KoffNum,t_tot);
   end

    xlabel('nu');title(h(1),titstr);
    
    if SaveFig
        saveas(gcf,strcat(savestr,'.jpg'),'jpg')
    end
end