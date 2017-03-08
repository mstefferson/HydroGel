% Make a parameter matrix for parfor (Hydrogel) 

function [paramMat, numRuns ] = MakeParamMat( paramObj,flags)
%Find number parameters be careful with nu and Llp
if flags.BoundTetherDiff 
  nuVec = paramObj.Llp;
else
  nuVec = paramObj.nu;
end
% Get all combinations
%paramMat = combvec( nuVec, paramObj.Koff, paramObj.KonBt, paramObj.Bt );
paramMat = combvec( nuVec, paramObj.kinVar1, paramObj.kinVar2, paramObj.Bt );
% fix things up if varying ka
if strcmp( paramObj.fixedVar, 'koff')
  btTemp = paramMat(4,:);
  kaTemp = paramMat(3,:);
  konBtTemp = paramMat(2,:);
  koffTemp = konBtTemp ./ ( kaTemp .* btTemp );
  paramMat(3,:) = koffTemp;
elseif strcmp( paramObj.fixedVar, 'konBt')
  btTemp = paramMat(4,:);
  koffTemp = paramMat(2,:);
  kaTemp = paramMat(3,:);
  konBtTemp = kaTemp .*  koffTemp .* btTemp; 
  paramMat(2,:) = konBtTemp;
  paramMat(3,:) = koffTemp;
end
[~, numRuns] = size(paramMat);


