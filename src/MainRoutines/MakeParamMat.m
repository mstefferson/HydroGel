% Make a parameter matrix for parfor (Hydrogel) 

function [paramMat, numRuns ] = MakeParamMat( paramObj,flags)
%Find number parameters be careful with nu and Llp
if flags.BoundTetherDiff 
  numNu = length(paramObj.Llp);
  nuVec = paramObj.Llp;
else
  numNu = length(paramObj.nu);
  nuVec = paramObj.nu;
end
numKoff = length(paramObj.Koff);
numKonBt = length(paramObj.KonBt);
numBt = length(paramObj.Bt);
% Commonly used multiples
numNuKoff = numNu*numKoff;
numNuKoffKonBt = numNuKoff * numKonBt;
numRuns = numNuKoffKonBt * numBt;
% initialize
paramMat = zeros( numRuns, 4);
% Loop over parameters and put them in a matrix
for i = 1:numNu
  for j = 1:numKoff
    for k = 1:numKonBt
      for l = 1:numBt
        % Find the row
        rowInd =  1 + (i-1) + (j-1) * numNu + ( k-1) * numNuKoff + ...
          (l-1) * numNuKoffKonBt;
        % Put in a matrix                    
        paramMat(rowInd,1) = nuVec(i);
        paramMat(rowInd,2) = paramObj.Koff(j);
        paramMat(rowInd,3) = paramObj.KonBt(k);
        paramMat(rowInd,4) = paramObj.Bt(l);
      end
    end
  end
end

