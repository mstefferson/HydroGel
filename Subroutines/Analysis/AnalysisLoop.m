

% keyboard
VarList = ls;
Files2Analyze = VarList(3:end-1,:);

[Numfiles, ~] = size(Files2Analyze);

%Plot everything

hAx = zeros(2,2);
h = figure('Position', [100 100 1120 840]);

hAx(1,1)  = subplot(2,2,1);
TitStr = sprintf('[A+C]');
xlabel(hAx(1,1),'Time'); ylabel(hAx(1,1),'Concentration');title(hAx(1,1),TitStr);
hold on

hAx(1,2)  = subplot(2,2,2);
TitStr = sprintf('[A+C] Normalized by steady state');
xlabel(hAx(1,2),'Time'); ylabel(hAx(1,2),' Normalized Concentration');title(hAx(1,2),TitStr);
hold on

hAx(2,1)  = subplot(2,2,3);
TitStr = sprintf('J_T');
xlabel(hAx(2,1),'Time'); ylabel(hAx(2,1),'Flux');title(hAx(2,1),TitStr);
hold on

hAx(2,2)  = subplot(2,2,4);
TitStr = sprintf('J_T Normalized by steady state');
xlabel(hAx(2,2),'Time'); ylabel(hAx(2,2),'Normalized Flux');title(hAx(2,2),TitStr);
hold on

ColorMat = jet(Numfiles);

for i = 1:Numfiles
    Files2Analyze(i,:);
    load(Files2Analyze(i,:));
    
    [JA_rec,JC_rec,JT_rec] =  ...
        FluxCalc(A_rec,C_rec,AL,AR,CL,CR,ParamVec,N_rec,N,x_trim,ND);
    [JAnorm_rec,JCnorm_rec,JTnorm_rec] = ...
        FluxNormalizer(JA_rec,JC_rec,JT_rec,AL,AR,CL,CR,ParamVec,N_rec,N,x_trim,ND);
    
    T_rec     = A_rec + C_rec;
    
    Tnorm_rec = T_rec ./ ( repmat( Ass + Css,[N_rec,1] ) );
%     Tnorm_rec =
% keyboard
ConcAndFluxVsTimePlotUpdaterJustMid(hAx(1,1),hAx(2,1),hAx(1,2),hAx(2,2),...
    JT_rec, JTnorm_rec,T_rec, Tnorm_rec,TimeRec,N,trial,ColorMat(i,:))

% ConcAndFluxVsTimePlotUpdater(hAx(1,1),hAx(2,1),hAx(1,2),hAx(2,2),...
%     JT_rec, JTnorm_rec,T_rec, Tnorm_rec,TimeRec,N,trial)

end
hold off

TrialVec = 1:Numfiles;
legendCell = cellstr(num2str(TrialVec', 'Trial %d'));
legend(hAx(1,1),legendCell,'Location','best'); 
legend(hAx(2,1),legendCell,'Location','best'); 
legend(hAx(1,2),legendCell,'Location','best'); 
legend(hAx(2,2),legendCell,'Location','best');
% keyboard
legend
% legend(hAx(1),'Left end', 'Middle', 'Right end')
% legend(hAx(2),'Left end', 'Middle', 'Right end')
% legend(hAx(3),'Left end', 'Middle', 'Right end')
% legend(hAx(4),'Left end', 'Middle', 'Right end')



% keyboard

% keyboard

