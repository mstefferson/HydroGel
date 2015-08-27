% Description :  returns the coupled chemistry operator for dirichlet BC
% Linear chemistry terms are included

function [Lop] = LopMakerRdNdDir(N,dx,Bt,KDinv,nu)

% Build Diffusion
LopDiff = sparse(2*N,2*N);
% Coupling
Lcoup   = sparse(2*N,2*N);
%


if KDinv ~= 0 % Chem
    % Diagonal
    %A Diag
    LopDiff(1 : 2*N+1 : 2*N*N) = -KDinv * Bt -2/dx^2;
    LopDiff(1,1) = 0; LopDiff(N,N) = 0;
    % C Diag
    LopDiff( (2*N)*N + N+1 : 2*N+1 : (2*N )*(2*N) ) = ...
        -1-2*nu/dx^2; 
    LopDiff(N+3,N+3) = 0; LopDiff(2*N,2*N) = 0;
    % SubDiagonal
    %  A Sub Diag
    LopDiff(2 : 2*N+1 : (N-1)*(2*N)) = 1/dx^2;
    LopDiff(N,N+1) = 0;
    % C Sub Diag
    LopDiff( (2*N)* N + N + 2 : 2*N+1 : (2*N )*(2*N-1) ) =...
        nu/dx^2;  
    LopDiff(2*N,2*N-1) = 0;
    
    % Super Diagonal
    % A Super Diag
    LopDiff(2*N+1 : 2*N+1 : (2*N)*N-1) = 1/dx^2;
    LopDiff(1,2) = 0;
    % C Super Diag
    LopDiff( (2*N)*(N+1)+ N + 1 : 2*N+1 : (2*N)*(2*N) - 1) =...
        nu/dx^2;
    LopDiff(N+1,N+2) = 0;
    Lcoup( (N+1)*(2*N)+2  : 2*N +1 : (2*N) * (2*N-1)-N  ) = 1;
    Lcoup( 2*N + N + 2 : 2*N +1 : 2*(N-1) * N ) = KDinv*Bt;
    
else % No chem
    
    %A Diag
    LopDiff(1 : 2*N+1 : 2*N*N) = -2/dx^2;%
    LopDiff(1,1) = 0; LopDiff(N,N) = 0;
    % C Diag
    LopDiff( (2*N)*N + N + 1 : 2*N+1 : (2*N )*(2*N) ) = ...
        -2*nu/dx^2; 
    LopDiff(N+3,N+3) = 0; LopDiff(2*N,2*N) = 0;
    % SubDiagonal
    %  A Sub Diag
    LopDiff(2 : 2*N+1 : (N-1)*(2*N)) = 1/dx^2;
    LopDiff(N,N+1) = 0;
    % C Sub Diag
    LopDiff( (2*N)* N + N + 2 : 2*N+1 : (2*N )*(2*N-1) ) =...
        nu/dx^2;  
    LopDiff(2*N,2*N-1) = 0;
    
    % Super Diagonal
    % A Super Diag
    LopDiff(2*N+1 : 2*N+1 : (2*N)*N-1) = 1/dx^2;
    LopDiff(1,2) = 0;
    % C Super Diag
    LopDiff( (2*N)*(N+1)+ N + 1 : 2*N+1 : (2*N)*(2*N) - 1) =...
        nu/dx^2;
    LopDiff(N+1,N+2) = 0;
    
end

% Put them together
Lop = LopDiff + Lcoup;

end

