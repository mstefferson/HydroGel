function [kdVec, nulplcVec, jNorm ] = getDataFluxSummary( ...
  fluxSummary, kdScale, lScale )
% set params
kinParams = fluxSummary.kinParams;
kdVec =  1 ./ kinParams.kinVarInput2;
kdVec = kdScale .* kdVec;
jMax = fluxSummary.jNorm;
nulplcVec = kinParams.p1Vec;
if strcmp( fluxSummary.paramObj.DbParam{1}, 'lplc' )
  nulplcVec = lScale * nulplcVec;
end
% get size
[ numLpLc, ~, numKa ] = size( jMax );
jNorm = zeros( numLpLc, numKa );
% build data matrix
for ii = 1:numLpLc
  for jj = 1:numKa
    jNorm(ii,jj) = jMax(ii, 1, jj );
  end
end
