function [x,dx] = GridMaster(A_BC,C_BC,Lbox,N)

if strcmp(A_BC,'PBC') && strcmp(C_BC,'PBC')
  [x,dx] =  Gridmaker1DPBC(Lbox,N);
else
  [x,dx] =  Gridmaker1DVn(Lbox,N);
end


end
