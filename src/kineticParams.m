% returns permutation of kinetic parameters and the correct varying kinetic parameters

function [kinMat, kinParams] =  kineticParams( konBt, koff, kA, Bt )
%%
% konBt = [ 1 2 3];
% koff = [ 1 ];
% kA = [2];
% Bt = [7 8];
% find lengths
numKonBt = length( konBt );
numKoff = length( koff );
numKa = length( kA );
numBt = length( Bt );
% only let the max two vary
sizeVec = [numKonBt numKoff numKa];
sumVec = [sizeVec(1)*sizeVec(2) sizeVec(1)*sizeVec(3) sizeVec(2)*sizeVec(3)];
% find max
[sumMax, indMax] = max(sumVec);
% kinMat: [Bt konBt, koff, kA]
kinMat = zeros( 4, sumMax .* numBt);
% konbt koff vary
if indMax == 1
  kinParams.fixedVar = 'kA';
  combMat = combvec(  Bt, konBt, koff );
  BtTemp = combMat(1,:);
  konBtTemp = combMat(2,:);
  koffTemp = combMat(3,:);
  kinMat(1,:) = BtTemp; 
  kinMat(2,:) = konBtTemp;
  kinMat(3,:) = koffTemp;
  kinMat(4,:) = konBtTemp ./ ( BtTemp .* koffTemp );
% konBt and ka vary
elseif indMax == 2
  kinParams.fixedVar = 'koff';
  combMat = combvec( Bt, konBt, kA );
  BtTemp = combMat(1,:);
  konBtTemp = combMat(2,:);
  kaTemp = combMat(3,:);
  kinMat(1,:) = BtTemp; 
  kinMat(2,:) = konBtTemp;
  kinMat(4,:) = kaTemp;
  kinMat(3,:) = konBtTemp ./ ( BtTemp .* kaTemp );
% koff ka vary
else
  kinParams.fixedVar = 'konBt';
  combMat = combvec( Bt, koff, kA );
  BtTemp = combMat(1,:);
  koffTemp = combMat(2,:);
  kaTemp = combMat(3,:);
  kinMat(1,:) = BtTemp; 
  kinMat(3,:) = koffTemp;
  kinMat(4,:) = kaTemp;
  kinMat(2,:) = kaTemp .* BtTemp .* koffTemp;
end
kinParams.Bt = unique( kinMat(1,:) );
kinParams.konBt = unique( kinMat(2,:) );
kinParams.koff = unique( kinMat(3,:) );
kinParams.kA = unique( kinMat(4,:) );

