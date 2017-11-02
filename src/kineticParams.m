% returns permutation of kinetic parameters and the correct varying kinetic parameters

%function [kinMat, kinParams] =  kineticParams( nu, konBt, koff, kA, Bt )
function [runParams, koffObj] =  kineticParams( nuVec, konBt, koffObj, kA, Bt )
% find lengths
numKonBt = length( konBt );
numKoff = length( koffObj.Inds );
numKa = length( kA );
% only let the max two vary
sizeVec = [numKonBt numKoff numKa];
sumVec = [sizeVec(1)*sizeVec(2) sizeVec(1)*sizeVec(3) sizeVec(2)*sizeVec(3)];
% find max
[~, indMax] = max(sumVec);
% kinMat: [Bt konBt, koff, kA]
% kinMat = zeros( 4, sumMax .* numBt);
% set inds once
ind0 = 1;
ind1 = 2;
ind2 = 3;
ind3 = 4;
% konbt koff vary
if indMax == 1
  runParams.fixedVar = 'kA';
  combMat = combvec( nuVec, Bt, konBt, koffObj.Inds );
  nuRuns = combMat(ind0,:);
  BtRuns = combMat(ind1,:);
  konBtRuns = combMat(ind2,:);
  koffInds = combMat(ind3,:);
  koffRuns = koffObj.BulkValAllRuns(koffInds);
  kaRuns = konBtRuns ./ ( BtRuns .* koffRuns );
%   kinMat(1,:) = BtRuns; 
%   kinMat(2,:) = konBtRuns;
%   kinMat(3,:) = koffTemp;
%   kinMat(4,:) = konBtRuns ./ ( BtRuns .* koffTemp );
% konBt and ka vary
elseif indMax == 2
  runParams.fixedVar = 'koff';
  combMat = combvec( nuVec, Bt, konBt, kA );
  nuRuns = combMat(ind0,:);
  BtRuns = combMat(ind1,:);
  konBtRuns = combMat(ind2,:);
  kaRuns = combMat(ind3,:);
  koffRunsTemp = konBtRuns ./ ( BtRuns .* kaRuns );
  % rebuild koff
  koffObj.rebuildKoff( koffRunsTemp );
  koffRuns = koffObj.BulkValAllRuns;
  koffInds = koffObj.Inds;
  % rep other parameters based on new number of koff
  otherParamRep = koffInds.NumTot / koffObj.NumBulkVal;
  % rep other parameters
  nuVec = repmat( nuVec, [1 otherParamRep] );
  BtRuns = repmat( BtRuns, [1 otherParamRep] );
  konBtRuns = repmat( konBtRuns, [1 otherParamRep] );
  kaRuns = repmat( kaRuns, [1 otherParamRep] );
%   kinMat(2,:) = konBtRuns;
%   kinMat(4,:) = kaRuns;
%   kinMat(3,:) = konBtRuns ./ ( BtRuns .* kaRuns );
% koff ka vary
else
  runParams.fixedVar = 'konBt';
  combMat = combvec( nuVec, Bt, koffObj.Inds, kA );
  nuRuns = combMat(ind0,:);
  BtRuns = combMat(ind1,:);
  koffInds = combMat(ind2,:);
  kaRuns = combMat(ind3,:);
  koffRuns = koffObj.BulkValAllRuns(koffinds);
  konBtRuns = kaRuns .* BtRuns .* koffRuns;
%   kinMat(1,:) = BtTemp; 
%   kinMat(3,:) = koffTemp;
%   kinMat(4,:) = kaRuns;
%   kinMat(2,:) = kaRuns .* BtTemp .* koffTemp;
end
fprintf('%s fixed\n', runParams.fixedVar);
% kinParams.Bt = unique( kinMat(1,:) );
% kinParams.konBt = unique( kinMat(2,:) );
% kinParams.koff = unique( kinMat(3,:) );
% kinParams.kA = unique( kinMat(4,:) );
% kinParams.Bt = unique( kinMat(1,:) );
% kinParams.konBt = kinMat(2,:) ;
% kinParams.koff = kinMat(3,:) ;
% kinParams.kA =  kinMat(4,:) ;
% kinParams.Bt =  kinMat(1,:) ;
%runParams.nuVec =  combMat(1,:);
runParams.konBt = konBtRuns;
runParams.kon = konBtRuns ./ BtRuns ;
runParams.koff = koffRuns;
runParams.koffInds = koffInds;
runParams.kA =  kaRuns;
runParams.Bt =  BtRuns;
runParams.nu =  nuRuns;
% runParams.runMat = combMat;
runParams.numRuns = length( nuRuns );
