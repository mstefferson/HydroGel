function [Lop]    =  LopMakerMaster(N,dx,Bt,kon,koff, Da, Dc, Lr,A_BC,C_BC)


if strcmp(A_BC,'Dir') && strcmp(C_BC,'Vn')
[Lop] = LopMakerRdDirVn(N,dx,Bt,kon,koff,Da,Dc);
elseif strcmp(A_BC,'Mx') && strcmp(C_BC,'Vn')
[Lop] = LopMakerRdMxVn(N,dx,Bt,kon,koff,Da,Dc);
elseif strcmp(A_BC,'Dir') && strcmp(C_BC,'Dir')
[Lop] = LopMakerRdDir(N,dx,Bt,kon,koff,Da,Dc);
elseif strcmp(A_BC,'Vn') && strcmp(C_BC,'Vn')
[Lop] = LopMakerRdVn(N,dx,Bt,kon,koff,Da,Dc);
elseif strcmp(A_BC,'Res') && strcmp(C_BC,'Vn')
[Lop] = LopMakerRdAResCvnChemOnEnd(N,dx,Bt,kon,koff,Da,Dc,Lr);
elseif strcmp(A_BC,'PBC') && strcmp(C_BC,'PBC')
[Lop] = LopMakerRdVn(N,dx,Bt,kon,koff,Da,Dc);
end

