function [A1, An, C1, Cn] = BcFixer(A_BC, C_BC, A1, An, C1, Cn, Al, Ar, Cl, Cr)

if strcmp(A_BC,'Dir')
  A1 = Al; 
  An = Ar;
elseif strcmp(A_BC,'Mx')
  A1 = Al;
end

if strcmp(C_BC,'Dir')
  C1 = Cl; 
  Cn = Cr;
end

end

