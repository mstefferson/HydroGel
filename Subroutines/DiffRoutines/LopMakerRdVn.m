% Description :  returns the coupled chemistry operator for no flux BC

function [Lop] = LopMakerRdVn(N,dx,Bt,kon,koff,Da,Dc)

% Create operator. Use sparse
% LopCoup   = sparse(2*N,2*N);
% LopDiff = sparse(2*N,2*N);

LopCoup   = zeros(2*N,2*N);
LopDiff = zeros(2*N,2*N);

    % Diffusion by diag chemistry
    % A Diag
    LopDiff(1 : 2*N+1 : 2*N*N) = -kon * Bt -2*Da/dx^2;%
    % C Diag
    LopDiff( (2*N)*N + N + 1 : 2*N+1 : (2*N )*(2*N) )   = -koff -2*Dc/dx^2; 
    % SubDiagonal
    %  A Sub Diag
    LopDiff(2 : 2*N+1 : (N-1)*(2*N)) = Da/dx^2;  
    LopDiff(N,N-1) = 2*Da/dx^2;
    %  C Sub Diag
    LopDiff( (2*N)* N + N + 2 : 2*N+1 : (2*N )*(2*N-1) ) = Dc/dx^2;  
    LopDiff(2*N,2*N-1) = 2*Dc/dx^2;
    
    % Super Diagonal
    % A Super Diag
    LopDiff(2*N+1 : 2*N+1 : (2*N)*N-1) = Da/dx^2;  
    LopDiff(1,2) = 2*Da/dx^2;
    % C Super Diag
    LopDiff( (2*N)*(N+1)+ N + 1 : 2*N+1 : (2*N)*(2*N) - 1)  = Dc/dx^2;  
    LopDiff(N+1,N+2) = 2*Dc/dx^2;
    
    % Chemistry Coupling % Chem on endpoints
   LopCoup( N+1 : 2*(N) +1: (2*N) * (N) ) = kon*Bt; % Chem on endpoints
   LopCoup( (2*N)*(N) + 1 : 2*N +1: (2*N ) * (2*N) - N   ) = koff;

   %No chem on endpoints
   % LopCoup( 2*N+N+2 : 2*(N) +1: (2*N) * (N-1) -1 ) = kon*Bt; 
   % LopCoup( (2*N)*(N+1) + 2 : 2*N +1: (2*N ) * (2*N-1) - N-1   ) = koff;


Lop = LopDiff + LopCoup;

% keyboard
end