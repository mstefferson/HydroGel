function [paramObj, runParams] = ...
  paramLoadMaster( paramObj, paramMat, flags )
% load it
nu = paramMat(:,1);
konBt = paramMat(:,2);
koff = paramMat(:,3);
bt = paramMat(:,4);
kon = konBt ./ bt;
kA = kon ./ ( koff );

% Get correct kinetic params
if flags.BoundTetherDiff
  p1name = '$$ Ll_p $$';
else
  p1name = '$$ \nu $$';
end
% fake koff
koffObj = BuildKoffInput( koff, {'const'} );
% store str info
runParams.fixedVar = 'n/a';
runParams.kinVarInput1 = koffObj.BulkValAllRuns;
runParams.kinVar1 = koffObj.BulkValAllRuns;
runParams.kinVarCell1 = koffObj.InfoCell;
runParams.kinVarInput2 = kA;
runParams.kinVar2 = kA;
runParams.kinVarCell2 = num2cell( kA );
runParams.kinVar1strTex = '$$ k_{on} B_t \tau $$';
runParams.kinVar1str = 'konBt';
runParams.kinVar2strTex = '$$ k_{off} \tau $$';
runParams.kinVar2str = 'koff';
runParams.numRuns = length(kon);
runParams.konBt = konBt;
runParams.kon = kon;
runParams.koff = koffObj.BulkValAllRuns;
runParams.koffInds = koffObj.Inds;
runParams.kA =  kA;
runParams.Bt =  bt;
runParams.nuLlp =  nu;
runParams.p1Vec = nu;
runParams.numP1 = length(nu);
runParams.numP2 = length(kon);
runParams.numP3 = length(koff);
% set parameters
paramObj.KonBt = runParams.konBt;
paramObj.Koff = runParams.koff;
paramObj.KoffObj = koffObj;
paramObj.Ka = runParams.kA;
paramObj.Bt = runParams.Bt;
paramObj.nu = nu;
