% Description :  returns the coupled chemistry operator for dirichlet BC
% for one species and VN for another
% Linear chemistry terms are included
%
% Chemistry at Endpoints

function [Lop] = LopMakerRdDirVn(N,dx,Bt,kon,koff,Da,Dc)
% Build Diffusion
LopDiff = sparse(2*N,2*N);
% Coupling
LopCoup   = sparse(2*N,2*N);
% Fix lengths
if length(Bt) == 1
  Bt = Bt .* ones(N, 1 );
end
if length(kon) == 1
  kon = kon .* ones( N, 1 );
end
if length(koff) == 1
  koff = koff .* ones( 1, N );
end
if length(Dc) == 1
  Dc = Dc .* ones( 1, N );
end
% commonly used 
dx2 = dx^2;
% build C spatially varying diffusion contribution
% diag
cDiagDiff = zeros(N,1);
dInds = 2:N-1;
cDiagDiff(1) = - ( Dc(1) + Dc(2) ) / dx2;
cDiagDiff(dInds) = -( Dc(dInds+1) + 2 * Dc(dInds) + Dc(dInds-1) ) / ( 2*dx2) ;
cDiagDiff(N) = - ( Dc(N) + Dc(N-1) ) / dx2;
% sub
subSuperDiag = ( Dc(1:N-1) + Dc(2:N) ) / ( 2 * dx2 ) ;
cSubDiagDiff = subSuperDiag;
cSubDiagDiff(end) =  ( Dc(N) + Dc(N-1) ) / ( dx2 );
% super
cSuperDiagDiff = subSuperDiag;
cSuperDiagDiff(1) = ( Dc(1) + Dc(2) ) / ( dx2 ) ;
% A Diag
LopDiff(1 : 2*N+1 : 2*N*N) = -kon .* Bt - 2*Da/dx^2;
LopDiff(1,1) = 0; LopDiff(N,N) = 0;
% C Diag
LopDiff( (2*N)*N + N+1 : 2*N+1 : (2*N )*(2*N) ) = -koff+cDiagDiff;
% SubDiagonal
% A Sub Diag
LopDiff(2 : 2*N+1 : (N-1)*(2*N)) = Da/dx^2;
LopDiff(N,N-1) = 0;
% C Sub Diag
LopDiff( (2*N)* N + N + 2 : 2*N+1 : (2*N )*(2*N-1) ) = cSubDiagDiff;
% Super Diagonals
% A Super Diag
LopDiff(2*N+1 : 2*N+1 : (2*N)*N-1) = Da/dx^2;
LopDiff(1,2) = 0;
% C Super Diag
LopDiff( (2*N)*(N+1)+ N + 1 : 2*N+1 : (2*N)*(2*N) - 1) = cSuperDiagDiff;
% Coupling
LopCoup( N+1 : 2*(N) +1: (2*N)*N) = kon .* Bt; %Chem Eps
LopCoup( (2*N)*(N) + 1 : 2*N +1: (2*N ) * (2*N) - N  ) = koff;
% Fix A boundary
LopCoup(1, N+1) = 0;
LopCoup(N, 2*N) = 0;
% Put them together
Lop = LopDiff + LopCoup;
end

