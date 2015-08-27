% Description :  returns the coupled chemistry operator for dirichlet BC
% Linear chemistry terms are included
% Nx: Number of internal gridpoints
function [Lop] = LopMakerRdDir(N,dx,Bt,kon,koff,Da,Dc)

N = N+2;
% Build Diffusion
LopDiff = sparse(2*N,2*N);
% Coupling
LopCoup   = sparse(2*N,2*N);

    % Diagonal
    %A Diag
    LopDiff(1 : 2*N+1 : 2*N*N) = -kon* Bt -2*Da/dx^2;
    LopDiff(1,1) = 0; LopDiff(N,N) = 0;
    % C Diag
    LopDiff( (2*N)*N + N+1 : 2*N+1 : (2*N )*(2*N) ) = -koff-2*Dc/dx^2; 
    LopDiff(N+1,N+1) = 0; LopDiff(2*N,2*N) = 0;
    % SubDiagonal
    %  A Sub Diag
    LopDiff(2 : 2*N+1 : (N-1)*(2*N)) = Da/dx^2;
    LopDiff(N,N-1) = 0;
    % C Sub Diag
    LopDiff( (2*N)* N + N + 2 : 2*N+1 : (2*N )*(2*N-1) ) = Dc/dx^2;  
    LopDiff(2*N,2*N-1) = 0;
    
    % Super Diagonal
    % A Super Diag
    LopDiff(2*N+1 : 2*N+1 : (2*N)*N-1) = Da/dx^2;
    LopDiff(1,2) = 0;
    % C Super Diag
    LopDiff( (2*N)*(N+1)+ N + 1 : 2*N+1 : (2*N)*(2*N) - 1) = Dc/dx^2;
    LopDiff(N+1,N+2) = 0;
    % Coupling
    LopCoup( 2*N+N+2 : 2*(N) +1: (2*N) * (N-1) -1 ) = kon*Bt;
    LopCoup( (2*N)*(N+1) + 2 : 2*N +1: (2*N ) * (2*N-1) - N-1   ) = koff;
    
    
%     keyboard
% Put them together
Lop = LopDiff + LopCoup;

end

