% Description :  returns the coupled chemistry operator for mixed BC 
% (Dir on left and Vn on right)
% for one species and VN for another
% Linear chemistry terms are included
%
% Chemistry at Endpoints

function [Lop] = LopMakerRdMxVn(N,dx,Bt,kon,koff,Da,Dc)


% Build Diffusion
% LopDiff = sparse(2*N,2*N);
% Coupling
% LopCoup   = sparse(2*N,2*N);
% Build Diffusion
LopDiff = zeros(2*N,2*N);
% Coupling
LopCoup   = zeros(2*N,2*N);

if length(Bt) == 1
    Bt =  Bt * ones(1,N);
end

if length(Da) == 1
    Da =  Da * ones(1,N);
end


if length(Dc) == 1
    Dc =  Dc * ones(1,N);
end
    % Diagonal
    %A Diag
    
    %LopDiff(1 : 2*N+1 : 2*N*N) = -kon * Bt(1:N) -2*Da(1:N)/dx^2;
    LopDiff(1 + 2*N+1 : 2*N+1 : 2*N*N - (2*N+1) ) = ...
    -kon *  Bt(2:N-1)  - ( Da(1:N-2) + 2 * Da(2:N-1) + Da(3:N) )  / (2*dx^2);
    LopDiff(1,1) = 0; 
    LopDiff(N,N) = ...
    -kon *  Bt(N)  - ( Da(N-1) + Da(N) )  / ( dx^2 );
 
    % C Diag
    %LopDiff( (2*N)*N + N+1 : 2*N+1 : (2*N )*(2*N) ) = -koff-2*Dc(1:N)/dx^2; 
    LopDiff( (2*N)*N + N+1 + 2*N+1: 2*N+1 : (2*N )*(2*N) - (2*N-1) ) =...
    -koff - ( Dc(1:N-2) + 2 * Dc(2:N-1) + Dc(3:N) )  / (2*dx^2);
    LopDiff(N+1,N+1) = ...
    -koff - ( Dc(1) + Dc(2) )  / (dx^2);
    LopDiff(2*N,2*N) = ...
    -koff - ( Dc(N-1) + Dc(N) )  / (dx^2);
     %LopDiff(N+1,N+1) = -2*Dc/dx^2; LopDiff(2*N,2*N) = -2*Dc/dx^2; %No chem
    % points

    % SubDiagonal
    %  A Sub Diag
    %LopDiff(2 : 2*N+1 : (N-1)*(2*N)) = Da(2:N)/dx^2;
    LopDiff(2 : 2*N+1 : (N-1)*(2*N)) = ( Da(1:N-1) + Da(2:N) ) / (2*dx^2);
    LopDiff(N,N-1) = (Da(N-1) +  Da(N) ) / dx^2;
    % C Sub Diag
    LopDiff( (2*N)* N + N + 2 : 2*N+1 : (2*N )*(2*N-1) ) =...
        (Dc(1:N-1) + Dc(2:N)) / (2*dx^2);  
    LopDiff(2*N,2*N-1) = (Dc(N-1) + Dc(N)) / (dx^2);
    
    % Super DiagonalS
    % A Super Diag
    %LopDiff(2*N+1 : 2*N+1 : (2*N)*N-1) = ( Da(1:N-1) + D(2:N) ) / (2*dx)^2;
    LopDiff(2*N+1 : 2*N+1 : (2*N)*N-1) = ( Da(1:N-1) + Da(2:N) ) / (2*dx ^2);
    LopDiff(1,2) = 0;
    % C Super Diag
    LopDiff( (2*N)*(N+1)+ N + 1 : 2*N+1 : (2*N)*(2*N) - 1) = ...
    ( Dc(1:N-1) + Dc(2:N) ) / (2*dx^2);
    LopDiff(N+1,N+2) = ( Dc(N-1) + Dc(N) ) /dx^2;
   
    % Coupling
   % LopCoup( 2*N+N+2 : 2*(N) +1: (2*N) * (N-1) -1 ) = kon*Bt; %No chem Eps
 
    LopCoup( N+1 : 2*(N) +1: (2*N)*N) = kon*Bt(1:N); %Chem Eps
    LopCoup( (2*N)*(N+1) + 2 : 2*N +1: (2*N ) * (2*N) - N   ) = koff;
       
%     keyboard
% Put them together
Lop = LopDiff + LopCoup;

end

