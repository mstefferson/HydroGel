% Make a parameter matrix for parfor (Hydrogel) 

function [paramMat, numRuns ] = MakeParamMat( paramObj )

%Find number parameters
numNu = length(paramObj.nu);
numKoff = length(paramObj.Koff);
numKonBt = length(paramObj.KonBt);
numBt = length(paramObj.Bt);

numNuKoff = numNu*numKoff;
numNuKoffKonBt = numNuKoff * numKonBt;
numRuns = numNuKoffKonBt * numBt;

% initialize
paramMat = zeros( numRuns, 4);

for i = 1:numNu
  for j = 1:numKoff
    for k = 1:numKonBt
      for l = 1:numBt
        rowInd =  1 + (i-1) + (j-1) * numNu + ( k-1) * numNuKoff + ...
          (l-1) * numNuKoffKonBt;
                    
        paramMat(rowInd,1) = paramObj.nu(i);
        paramMat(rowInd,2) = paramObj.Koff(j);
        paramMat(rowInd,3) = paramObj.KonBt(k);
        paramMat(rowInd,4) = paramObj.Bt(l);
      end
    end
  end
end

