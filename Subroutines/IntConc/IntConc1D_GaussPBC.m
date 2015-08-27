% Makes a gaussian concentration with Dirchlet boundary conditions

function [rho] = IntConc1D_GaussPBC(x,Ngr,Norm)

x_mid = x(Ngr/2+1);
var   = x(end) / 100;
rho   = exp( -1/2 * ( ( x - x_mid ) ./ var ).^ 2 ); 

rho   = Norm ./ trapz(x,rho) .* rho;
end