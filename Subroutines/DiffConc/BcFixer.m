function [A1, An, C1, Cn] = NlBcFixer(A_BC, C_BC, A1, An, C1, Cn, Al, Ar, Cl, Cr)

if strcmp(A_BC,'Dir') && strcmp(C_BC,'Vn')
  A1 = Al; 
  An = Ar;
  C1 = C1;
  Cn = Cn;
elseif strcmp(A_BC,'Mx') && strcmp(C_BC,'Vn')
  A1 = Al;
  An = An;
  C1 = C1;
  Cn = Cn;
elseif strcmp(A_BC,'Dir') && strcmp(C_BC,'Dir')
  A1 = Al;
  An = Ar;
  C1 = Cl;
  Cn = Cr;
elseif strcmp(A_BC,'Vn') && strcmp(C_BC,'Vn')
  A1 = A1;
  An = An;
  C1 = C1;
  Cn = Cn;
elseif strcmp(A_BC,'Res') && strcmp(C_BC,'Vn')
  A1 = A1;
  An = An;
  C1 = C1;
  Cn = Cn;
elseif strcmp(A_BC,'PBC') && strcmp(C_BC,'PBC')
  A1 = A1;
  An = An;
  C1 = C1;
  Cn = Cn;
end

