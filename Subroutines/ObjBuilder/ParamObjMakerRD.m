% Builds the parameter object for the reaction diffusion equation

function [ParamObj] = ParamObjMakerRD(SaveMe,ChemOnEndPts,Nx,Lbox,Lr,A_BC,C_BC,Kon,Koff, Da,Dc,...
Dnl,NLcoup,Bt,Btc,AL,AR,trial,BindSiteDistFlag,BtDepDiff,sigma)

% Put Parameters in a structure
ParamObj   = struct('trial',trial,'SaveMe',SaveMe, 'ChemOnEndPts',ChemOnEndPts,...
    'Nx',Nx,'Lbox',Lbox,'Lr',Lr,...
'A_BC',A_BC,'C_BC',C_BC,...
'Kon', Kon, 'Koff', Koff,'KDinv',Kon/Koff,'Da',Da,...
    'Dc',Dc,'Dnl',Dnl,'NLcoup',NLcoup,...
    'Bt',Bt,'Btc',Btc,'AL',AL,'AR',AR,...
    'BindSiteDistFlag',BindSiteDistFlag, 'BtDepDiff',BtDepDiff,'sigma',sigma);
end

