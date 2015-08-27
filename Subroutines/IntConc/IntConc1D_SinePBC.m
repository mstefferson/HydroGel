% Makes a gaussian concentration with Dirchlet boundary conditions

function [rho] = IntConc1D_SinePBC(x,Ngr,L_box,Norm)

x_mid = x(Ngr/2+1);
var   = x(end) / 100;
rho   = 2e-4 .* ( sin(2*pi*x/L_box) +2 ); 

% rho   = Norm ./ trapz(x,rho) .* rho;
end