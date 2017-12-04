function [paramObj, runParams] = ...
  paramInputMaster( paramObj, koffVary )
% grab kinetic parameter cell info and put it into paramObj
paramObj = kineticParamInputHandler( paramObj );
% build koff
koffObj = BuildKoffInput( paramObj.koff, koffVary );
% Get correct kinetic params
if strcmp( paramObj.DbParam{1}, 'lplc' )  
  p1nameTex = '$$ l_cl_p $$';
  p1name = 'lclp';
else
  p1name = 'nu';
  p1nameTex = '$$ \nu $$';
end
nuVec = paramObj.DbParam{2};
[ runParams, koffObj ] =  kineticParams( nuVec, paramObj.konBt, koffObj, ...
  paramObj.kA, paramObj.Bt );
% put p1 name in runParams
runParams.p1nameTex = p1nameTex; 
runParams.p1name = p1name;
runParams.numP1 = length( nuVec );
% set parameters
paramObj.runParams = runParams;
paramObj.nulplc = p1name; 
paramObj.nulplcVal = runParams.nuLlp; 
paramObj.konBt = runParams.konBt;
paramObj.koff = runParams.koff;
paramObj.koffObj = koffObj;
paramObj.kA = runParams.kA;
paramObj.kD = 1 ./ paramObj.kA;
paramObj.Bt = runParams.Bt;
