function [paramObj, runParams] = ...
  paramInputMaster( paramObj, paramFile, flags )
% load it
load(paramFile)
konBt = paramFile(:,1);


% Get correct kinetic params
if flags.BoundTetherDiff
  p1name = '$$ Ll_p $$';
  nuVec = paramObj.Llp;
else
  p1name = '$$ \nu $$';
  nuVec = paramObj.nu;
end
[ runParams, koffObj ] =  kineticParams( nuVec, paramObj.KonBt, koffObj, ...
  paramObj.Ka, paramObj.Bt );
% put p1 name in runParams
runParams.p1name = p1name; 
runParams.numP1 = length( nuVec );
% set parameters
paramObj.KonBt = runParams.konBt;
paramObj.Koff = runParams.koff;
paramObj.KoffObj = koffObj;
paramObj.Ka = runParams.kA;
paramObj.Bt = runParams.Bt;
