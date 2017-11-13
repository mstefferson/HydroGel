function [paramObj, runParams] = ...
  paramInputMaster( paramObj, paramFile, flags )
% load it
load(paramFile)
nu = paramFile(:,1);
konBt = paramFile(:,2);
koff = paramFile(:,3);
bt = paramFile(:,4);
ka = konBt ./ ( bt .* koff );

% Get correct kinetic params
if flags.BoundTetherDiff
  p1name = '$$ Ll_p $$';
else
  p1name = '$$ \nu $$';
end

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
runParams.konBt = konbt;
runParams.kon = kon;
runParams.koff = koff;
runParams.koff = koffInds;
runParams.kA =  kaRuns;
runParams.Bt =  BtRuns;
runParams.nuLlp =  nuRuns;
runParams.p1Vec = nuVec;
runParams.numP1 = length(nu);
runParams.numP2 = length(kon);
runParams.numP3 = length(koff);
% put p1 name in runParams
runParams.p1name = p1name; 
runParams.nuLlp = nu;
runParams.numP1 = length( nuVec );
% set parameters
paramObj.KonBt = runParams.konBt;
paramObj.Koff = runParams.koff;
paramObj.KoffObj = koffObj;
paramObj.Ka = runParams.kA;
paramObj.Bt = runParams.Bt;
paramObj.nu = nu;

