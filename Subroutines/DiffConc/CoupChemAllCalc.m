%Calculates just the all linear chemistry terms

function [NL] = CoupChemAllCalc(v,Bt,Kon,Koff,N)
% keyboard
NL = zeros(2*N,1);

if Kon ~= 0
NL(1:N)     =  -Kon .* v(1:N) .* ( Bt -v(N+1:end) ) + Koff .* v(N+1:end);
NL(N+1:end) =   Kon .* v(1:N) .* ( Bt -v(N+1:end) ) - Koff .* v(N+1:end);
end

end