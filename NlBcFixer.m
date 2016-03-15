function [NlA1, NlAn, NlC1, NlCn ] = NlBcFixer(A_BC, C_BC,NlA1, NlAn, NlC1, NlCn)

if strcmp(A_BC,'Dir') && strcmp(C_BC,'Vn')
  NlA1 = 0; 
  NlAn = 0;
  NlC1 = NlC1;
  NlCn = NlCn;
elseif strcmp(A_BC,'Mx') && strcmp(C_BC,'Vn')
  NlA1 = 0;
  NlAn = NlAn;
  NlC1 = NlC1;
  NlCn = NlCn;
elseif strcmp(A_BC,'Dir') && strcmp(C_BC,'Dir')
  NlA1 = 0;
  NlAn = 0;
  NlC1 = 0;
  NlCn = 0;
elseif strcmp(A_BC,'Vn') && strcmp(C_BC,'Vn')
  NlA1 = NlA1;
  NlAn = NlAn;
  NlC1 = NlC1;
  NlCn = NlCn;
elseif strcmp(A_BC,'Res') && strcmp(C_BC,'Vn')
  NlA1 = NlA1;
  NlAn = NlAn;
  NlC1 = NlC1;
  NlCn = NlCn;
elseif strcmp(A_BC,'PBC') && strcmp(C_BC,'PBC')
  NlA1 = NlA1;
  NlAn = NlAn;
  NlC1 = NlC1;
  NlCn = NlCn;
end


