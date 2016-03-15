function [Lr] = LrMaster(A_BC, C_BC, Lr);

if ~strcmp(A_BC,'Res') 
  Lr = 0;
end
