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
% set inds once
ind0 = 1;
ind1 = 2;
ind2 = 3;
ind3 = 4;
% konbt koff vary
if indMax == 1
  % store str info
  runParams.fixedVar = 'kA';
  runParams.kinVarInput1 = konBt;
  runParams.kinVar1 = konBt;
  runParams.kinVarCell1 = num2cell( konBt );
  runParams.kinVarInput2 = koffObj.BulkValAllRuns;
  runParams.kinVar2 = koffObj.BulkValAllRuns;
  runParams.kinVarCell2 = koffObj.InfoCell;
  runParams.kinVar1str = 'konBt';
  runParams.kinVar1strTex = '$$ k_{on} B_t \tau $$';
  runParams.kinVar2str = 'koff';
  runParams.kinVar2strTex = '$$ k_{off} \tau $$';
  % get combinations
  combMat = combvec( nuVec, Bt, konBt, koffObj.Inds );
  nuRuns = combMat(ind0,:);
  BtRuns = combMat(ind1,:);
  konBtRuns = combMat(ind2,:);
  koffInds = combMat(ind3,:);
  koffRuns = koffObj.BulkValAllRuns(koffInds);
  kaRuns = konBtRuns ./ ( BtRuns .* koffRuns );
  % konBt and ka vary
elseif indMax == 2
  % get multiplier from koff if it exists
  otherParamRep = koffObj.NumMult;
  kAStore = reshape( repmat( kA, [ otherParamRep 1] ), ...
    [1 otherParamRep * length(kA) ] );
  % store str info
  runParams.fixedVar = 'koff';
  runParams.koffMult = otherParamRep;
  runParams.kinVarInput1 = konBt;
  runParams.kinVar1 = konBt;
  runParams.kinVarCell1 = num2cell( konBt );
  runParams.kinVarInput2 = kA;
  runParams.kinVar2 = kAStore;
  runParams.kinVarCell2 = num2cell( kAStore );
  runParams.kinVar1str = 'konBt';
  runParams.kinVar1strTex = '$$ k_{on} B_t \tau $$';
  runParams.kinVar2str = 'Ka';
  runParams.kinVar2strTex = '$$ K_A $$';
  % get combinations
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
  otherParamRep = koffObj.NumMult;
  nuRuns = reshape( repmat( nuRuns, [ otherParamRep 1] ), ...
    [1 koffObj.NumTot] );
  BtRuns = reshape( repmat( BtRuns, [ otherParamRep 1] ), ...
    [1 koffObj.NumTot] );
  konBtRuns = reshape( repmat( konBtRuns, [ otherParamRep 1] ), ...
    [1 koffObj.NumTot] );
  kaRuns = reshape( repmat( kaRuns, [ otherParamRep 1] ), ...
    [1 koffObj.NumTot] );
  % koff ka vary
else
  % store str info
  runParams.fixedVar = 'konBt';
  runParams.kinVarInput1 = koffObj.BulkValAllRuns;
  runParams.kinVar1 = koffObj.BulkValAllRuns;
  runParams.kinVarCell1 = koffObj.InfoCell;
  runParams.kinVarInput2 = kA;
  runParams.kinVar2 = kA;
  runParams.kinVarCell2 = num2cell( kA );
  runParams.kinVar1strTex = '$$ k_{off} \tau $$';
  runParams.kinVar1str = 'koff';
  runParams.kinVar2str = 'Ka';
  runParams.kinVar2strTex = '$$ K_A $$';
  % get combinations
  combMat = combvec( nuVec, Bt, koffObj.Inds, kA );
  nuRuns = combMat(ind0,:);
  BtRuns = combMat(ind1,:);
  koffInds = combMat(ind2,:);
  kaRuns = combMat(ind3,:);
  koffRuns = koffObj.BulkValAllRuns(koffInds);
  konBtRuns = kaRuns .* BtRuns .* koffRuns;
end
fprintf('%s fixed\n', runParams.fixedVar);
runParams.konBt = konBtRuns;
runParams.kon = konBtRuns ./ BtRuns ;
runParams.koff = koffRuns;
runParams.koffInds = koffInds;
runParams.kA =  kaRuns;
runParams.Bt =  BtRuns;
runParams.nuLlp =  nuRuns;
runParams.p1Vec = nuVec;
runParams.numRuns = length( nuRuns );
runParams.numP1 = length(nuVec);
runParams.numP2 = length(runParams.kinVarCell1);
runParams.numP3 = length(runParams.kinVarCell2);