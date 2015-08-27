%Calculates just the nonlinear part of the chemistry term

function [NL] = CoupChemNLCalc(v,kon,N)
% keyboard
NL = zeros(2*N,1);
NL(1:N)     =  kon .* v(1:N) .* v(N+1:2*N);
NL(N+1:end) = -kon .* v(1:N) .* v(N+1:2*N);
% keyboard
end