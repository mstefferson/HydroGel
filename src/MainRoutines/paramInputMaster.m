function [paramObj, runParams] = ...
  paramInputMaster( paramObj, koffVary )
% build koff
koffObj = BuildKoffInput( paramObj.Koff, koffVary );
% Get correct kinetic params
if strcmp( paramObj.DbParam{1}, 'lplc' )  
  p1nameTex = '$$ l_cl_p $$';
  p1name = 'lclp';
else
  p1name = 'nu';
  p1nameTex = '$$ \nu $$';
end
nuVec = paramObj.DbParam{2};
[ runParams, koffObj ] =  kineticParams( nuVec, paramObj.KonBt, koffObj, ...
  paramObj.Ka, paramObj.Bt );
% put p1 name in runParams
runParams.p1nameTex = p1nameTex; 
runParams.p1name = p1name;
runParams.numP1 = length( nuVec );
% set parameters
paramObj.runParams = runParams;
paramObj.nulplc = p1name; 
paramObj.nulplcVal = runParams.nuLlp; 
paramObj.KonBt = runParams.konBt;
paramObj.Koff = runParams.koff;
paramObj.KoffObj = koffObj;
paramObj.Ka = runParams.kA;
paramObj.Bt = runParams.Bt;
