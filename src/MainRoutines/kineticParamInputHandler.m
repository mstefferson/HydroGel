% Kinetic parameters are set by cells in paramObj. Take these cells,
% and put the correct parameter vecs into paramObj.
%
function paramObj = kineticParamInputHandler( paramObj )

% make sure 2/3 kinetic parameters are accounted for
% with a check vec.
checkVec = [0 0 0]; % konbt, koff, kA/kD 
combinedParams = {paramObj.kinParam1, paramObj.kinParam2};
combinedStr = {paramObj.kinParam1{1}, paramObj.kinParam2{1}};
% check konBt
checkInd = 1;
paramstr = 'konBt';
[paramObj.konBt, checkVal]  = checkAndReturnParam( paramstr, ...
  combinedStr, combinedParams );
checkVec(checkInd) =  checkVal;
% check koff
checkInd = 2;
paramstr = 'koff';
[paramObj.koff, checkVal]  = checkAndReturnParam( paramstr, ...
  combinedStr, combinedParams );
checkVec(checkInd) =  checkVal;
% check kA
checkInd = 3;
paramstr = 'kA';
[paramObj.kA, checkVal]  = checkAndReturnParam( paramstr, ...
  combinedStr, combinedParams );
checkVec(checkInd) =  checkVal;
% check kD based on whether kA is set or not
if checkVal
  paramObj.kD  = 1 ./ paramObj.kA;
else
  % check kD
  paramstr = 'kD';
  [paramObj.kD, checkVal]  = checkAndReturnParam( paramstr, ...
    combinedStr, combinedParams );
  checkVec(checkInd) =  checkVal;
  if checkVal
    paramObj.kA  = 1 ./ paramObj.kD;
  end
end
% set other parameters
if checkVec == [1 1 0]
  paramObj.kA = [];
  paramObj.kD = [];
  fprintf('Varying konbt and koff \n');
elseif checkVec == [1 0 1]
  paramObj.koff = [];
  fprintf('Varying konbt and kA/kD \n');
elseif checkVec == [0 1 1]
  paramObj.konBt = [];
  fprintf('Varying koff and kA/kD \n');
else
  strOut = 'Error, incorrect number of inputs';
  fprintf( [ strOut '\n'] )
  error(strOut)
end

function [paramVal, checkVal] = checkAndReturnParam( paramstr, combinedStr, combinedParams )
logInds = strcmp( paramstr, combinedStr );
if logInds
  strOut = ['both input parameters set to ' paramstr ];
  fprintf( [ strOut '\n'] )
  error(strOut)
elseif any( logInds )
  checkVal = 1;
  paramVal = combinedParams{ logInds }{2};
else
  checkVal = 0;
  paramVal = [];
end
