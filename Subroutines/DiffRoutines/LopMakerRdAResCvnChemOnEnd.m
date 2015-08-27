% Description: returns the double diffusion operator for no flux BC.
% Both A has a reservior. There can be flux into the boundaries, but it
% doesn't act as a reservior. C can take a value on
% the boundary
% Includes chemistry, even on endpoints
% No dimensionalized

function [Lop] = LopMakerRdAResCvnChemOnEnd(N,dx,Bt,kon,koff,Da,Dc,Lr)

% Initialize
LopDiff = sparse(2*(N),2*(N));
LopCoup = sparse(2*(N),2*(N));

% LopDiff = zeros(2*(N),2*(N));
% LopCoup = zeros(2*(N),2*(N));

% A Diag
LopDiff(1:2*(N)+1:2*(N)*(N)) = -kon*Bt - 2*Da/dx^2;%
LopDiff(1,1) = -kon * Bt * dx / ( dx + 2 * Lr ) - Da / (dx * (dx/2 + Lr ) ); 
LopDiff(N,N) = -kon * Bt * dx / ( dx + 2 * Lr ) - Da / (dx * (dx/2 + Lr ) );
% C Diag
LopDiff( (2*N)*(N) + N + 1:2*(N)+1:(2*N )*(2*N) )   = -koff-2*Dc/dx^2; % C Diag
LopDiff(N+1,N+1) = -koff -2*Dc/dx^2;
LopDiff(2*N,2*N) = -koff- 2*Dc/dx^2;

% SubDiagonal
%  A Sub Diag
LopDiff(2:2*(N)+1:(N-1)*(2*(N))) = Da/dx^2;
LopDiff(N,N-1)= Da / (dx * (dx/2 + Lr ) );
%  C Sub Diag
LopDiff( (2*(N))* (N) + N + 2:2*(N)+1:(2*N )*(2*N-1) ) = Dc/dx^2;
LopDiff(2*N,2*N-1)   =  2 * Dc/dx^2;

% Super Diagonal
% A Super Diag
LopDiff(2*(N)+1:2*(N)+1:(2*(N))*(N)-1) = Da/dx^2;
LopDiff(1,2) =  Da / (dx * (dx/2 + Lr ) );
% C Super Diag
LopDiff( (2*N)*(N+1)+ N + 1:2*(N)+1:(2*N)*(2*N) - 1)  = Dc/dx^2;
LopDiff(N+1,N+2) =  2 * Dc / dx^2;

% Coupling Chem on endpoints
LopCoup( N+1 : 2*(N) +1: (2*N) * (N) ) = kon*Bt;
LopCoup( (2*N)*(N) + 1 : 2*N +1: (2*N ) * (2*N) - N   ) = koff;
% Fix endpoints
% LopCoup( N+1) = kon * Bt * dx / ( dx + 2 * Lr ) ;
% LopCoup( (2*N) * (N) ) = kon * Bt * dx / ( dx + 2 * Lr );
LopCoup( (2*N)*(N) + 1 ) = koff * dx / ( dx + 2 * Lr ) ;
LopCoup( (2*N ) * (2*N) - N   ) = koff * dx / ( dx + 2 * Lr ) ;

Lop = LopDiff+ LopCoup;

% keyboard
end