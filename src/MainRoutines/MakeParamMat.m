% Make a parameter matrix for parfor (Hydrogel) 

function [paramMat, numRuns ] = MakeParamMat( paramObj,flags)
%Find number parameters be careful with nu and Llp
if flags.BoundTetherDiff 
  nuVec = paramObj.Llp;
else
  nuVec = paramObj.nu;
end
% Get all combinations
%paramMat = combvec( nuVec, paramObj.koff, paramObj.konBt, paramObj.Bt );
keyboard
paramMat = combvec( nuVec, paramObj.koffObj.Inds, paramObj.konBt, paramObj.Bt );
numRuns = size( paramMat,2 );

 %{% set parameters%}
  %btTemp = paramMat(4,:);
%% fix things up if varying ka
%if strcmp( paramObj.fixedVar, 'koff')
  %konBtTemp = paramMat(2,:);
  %kaTemp = paramMat(3,:);
  %koffTemp = konBtTemp ./ ( kaTemp .* btTemp );
  %paramMat(3,:) = koffTemp;
%elseif strcmp( paramObj.fixedVar, 'konBt')
  %koffTemp = paramMat(2,:);
  %kaTemp = paramMat(3,:);
  %konBtTemp = kaTemp .*  koffTemp .* btTemp; 
  %paramMat(2,:) = konBtTemp;
  %paramMat(3,:) = koffTemp;
%end
%[~, numRuns] = size(paramMat);


