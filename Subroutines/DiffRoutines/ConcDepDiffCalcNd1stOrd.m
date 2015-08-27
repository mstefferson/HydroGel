% Function: ConcDepDiffCalcNd1stOrd.m
% Description: Calculates just the nonlinear part of a concentration 
% dependent diffusion coefficient  with two species when the
% equations have been nondimensionalized.
% The presences of one species linearly enhances diffusion.
% Program approximates the flux between gridpoints and takes
% the gradient of it.
% Note: It does not include the effect on 
% endpoints because that depends on boundary conditions
%
% Inputs:
% v: The concentration vector of two species A-C v = [A C]
% beta = Dmax/Di ratio of max diffusion and bare
% Csat: the concentration C can saturate to
% N: number of spatial grid points
% dx: The spatial gridspacing

% Outputs:
% NL: The nonlinear contribution to the diffusion

% Explanation of diffusion:
% Let A be the species that has enhanced diffusion due to 
% the presence of C:
% Flux_{A} = - DA * dA/dx
% If Da/Do =  1 + (Dmax-D0)/ (D0 *Csat) * C 
% This gives DNL = (beta- 1)/ (Csat) * C
% coefficient  with two species. The presences of one species linearly
% enhances diffusion

function [NL] = ConcDepDiffCalcNd1stOrd(v,beta,Csat,N,dx)
%Initialize
NL = zeros(2*N,1);
%Calculate flux
dAdx           = ( v(2:N) - v(1:N-1) ) / dx;
Cbtwnpts       = ( v(N+1:2*N-1) + v(N+2:2*N) ) / 2;
NlDiffCoeff    = (beta - 1) / Csat * Cbtwnpts;
Flux           = -NlDiffCoeff .* dAdx;
% Take gradient
NL(2:N-1)      = ( Flux(1:N-2) - Flux(2:N-1) ) ./ dx; % -dFlux/dx

end
