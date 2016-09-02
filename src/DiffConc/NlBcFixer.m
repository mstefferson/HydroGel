function [NlA1, NlAn, NlC1, NlCn ] = ...
    NlBcFixer(A_BC, C_BC, NlA1, NlAn, NlC1, NlCn)

if strcmp(A_BC,'Dir')
  NlA1 = 0; 
  NlAn = 0;
elseif strcmp(A_BC,'Mx')
  NlA1 = 0;
end

if strcmp(C_BC,'Dir')
  NlC1 = 0;
  NlCn = 0;
end


