function [kdVec, lplcVec, jNorm ] = getDataFluxSummary( ...
  fluxSummary, kdScale, lScale )
% set params
kinParams = fluxSummary.kinParams;
kdVec =  1 ./ kinParams.kinVarInput2;
kdVec = kdScale .* kdVec;
jMax = fluxSummary.jNorm;
lplcVec = kinParams.p1Vec;
lplcVec = lScale * lplcVec;
% get size
[ numLpLc, ~, numKa ] = size( jMax );
jNorm = zeros( numLpLc, numKa );
% build data matrix
for ii = 1:numLpLc
  for jj = 1:numKa
    jNorm(ii,jj) = jMax(ii, 1, jj );
  end
end

