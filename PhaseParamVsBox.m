clear
clc

CurrentDir = pwd;
addpath( genpath( CurrentDir) );

SaveMe = 1;
PlotMe = 0;
BCstr = 'DirVn'; % 'Dir','Vn','DirVn'

trial  = 1;
%Parameter you can edit

KDinv = 1e4;
Koff  = 1e1;
Kon  = KDinv * Koff;
nu  = 1;
AL  = 2e-4;
AR  = 0;
Bt  = 2e-3;
NxODE  = 1000;
LboxVec = logspace(0,2,20);



%% Objects
% Put Parameters in a structure
ParamObj   = struct('trial',trial,'SaveMe',SaveMe,...
    'NxODE',NxODE,'LboxVec',LboxVec,...
    'BCstr',BCstr,...
    'Kon', Kon, 'Koff', Koff,'KDinv',Kon/Koff,...
    'nu',nu,'Bt',Bt,'AL',AL,'AR',AR);
Paramstr = sprintf('Kon=%.1e\nKoff=%.1e\nnu=%.2e\n',...
    ParamObj.Kon,ParamObj.Koff,ParamObj.nu);
Concstr = sprintf('Bt=%.1e\nAL=%.1e\nAR=%.2e',...
    ParamObj.Bt,ParamObj.AL,ParamObj.AR);
Gridstr = sprintf('NxODE = %d\n',...
    ParamObj.NxODE);

if SaveMe
    diary('RunDiary.txt')
    disp(ParamObj)
end

% Initialize
FluxDivSS = zeros(1,length(LboxVec));
FluxDiffSS = zeros(1,length(LboxVec));
FluxRDSS = zeros(1,length(LboxVec));

for i = 1:length(LboxVec)
    
%%%%%%%% MATLAB'S ODE SOLVER%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[AnlOde,CnlOde,~] = RdSsSolverMatBvFunc(...
    Kon,Koff,nu,AL,AR,Bt,LboxVec(i),BCstr,NxODE.*LboxVec(i),0);
[ADiffOde,DiffOde,xOde] = RdSsSolverMatBvFunc(...   
    0,0,0,AL,AR,Bt,LboxVec(i),BCstr,NxODE.*LboxVec(i),0);
% keyboard
FluxRDSS(i)   = ( AnlOde(end-1) - AnlOde(end) ) ./ ( xOde(end)-xOde(end-1) );
FluxDiffSS(i) = ( ADiffOde(end-1) - ADiffOde(end) ) ./ ( xOde(end)-xOde(end-1) );
FluxDivSS(i) = ( AnlOde(end-1) - AnlOde(end) ) ./ ( ADiffOde(end-1) - ADiffOde(end) ); 
end

figure
[ax,h1,h2] = plotyy(LboxVec,FluxDivSS,LboxVec,[FluxRDSS' FluxDiffSS']);
legend(h2,'Reactions','Pure Diffusion','location','best')
xlabel('box length');ylabel(ax(1),'j/j_{diff}'); ylabel(ax(2),'flux')
title('j/j_{diff} and fluxes at steady state vs Lbox')
set(ax(1),'YLim',[0,10],'YTick',1:10)
set(ax(2),'YLim',[0,1e-3],'YTick',0:1e-4:1e-3)

textbp(Paramstr);
pause(0.1)
textbp(Concstr)

if SaveMe
    dirstr = './Outputs/FluxVsBox';
    mkdir(dirstr)
    SaveStr = sprintf('SsKon%.1eKoff%.1enu%.1e',...
    ParamObj.Kon,ParamObj.Koff,ParamObj.nu);
    saveas(gcf,strcat(SaveStr,'.jpg'),'jpeg')
    save(strcat(SaveStr,'.mat'),'ParamObj','FluxRDSS','FluxDiffSS', 'FluxDivSS')
end

figure
subplot(1,2,1)
loglog(LboxVec,FluxDivSS);
xlabel('box length');ylabel('j/j_{diff}');
title('j/j_{diff} at steady state vs Lbox')
textbp(Paramstr);
set(gca,'YLim',[0,10])
subplot(1,2,2)
loglog(LboxVec,FluxRDSS,LboxVec,FluxDiffSS);
xlabel('box length');ylabel('j');
title('j at steady state vs Lbox')
legend('Reactions','Pure Diffusion','location','best')
textbp(Concstr)
set(gca,'YLim',[0,1e-3])

if SaveMe
    dirstr = './Outputs/FluxVsBox';
    mkdir(dirstr)
    SaveStr = sprintf('SsLogKon%.1eKoff%.1enu%.1e',...
    ParamObj.Kon,ParamObj.Koff,ParamObj.nu);
    saveas(gcf,strcat(SaveStr,'.jpg'),'jpeg')
%     save(strcat(SaveStr,'.mat'),'ParamObj','FluxRDSS','FluxDiffSS', 'FluxDivSS')
    movefile('*.mat',dirstr)
     movefile('*.txt',dirstr)
     movefile('*.jpg',dirstr)
     diary off
end

%% Plot routine
if PlotMe
SSplotterCmpr(SSobj,ParamObj,SSobj.xPde,SSobj.xOde);
end