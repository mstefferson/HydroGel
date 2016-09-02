% Doesn't account for spatially varying Bt. Currently this isn't implimented...

function [Nldiff1, NldiffN] = NlDiffBcFixer(A_BC,C_BC, Dnl, Bt, v, dx)

if strcmp(A_BC,'Dir') && strcmp(C_BC,'Vn')
    NLdiff1 = 0; 
    NldiffN = 0;
elseif strcmp(A_BC,'Mx') && strcmp(C_BC,'Vn')
    NLdiff1 = 0; 
    NldiffN = (Dnl - 1) / Bt * ...
        (v(2*Nx-1) + v(2*Nx) ) .* (v(Nx-1) - v(Nx) ) / ( dx^2 );
elseif strcmp(A_BC,'Dir') && strcmp(C_BC,'Dir')
    NLdiff1 = 0; 
    NldiffN = 0;
elseif strcmp(A_BC,'Vn') && strcmp(C_BC,'Vn')
    NLdiff1 = (Dnl - 1) / Bt * ...
        (v(Nx+1) + v(Nx+2) ) .* (v(2) - v(1) ) / ( dx^2 );
    NldiffN = (Dnl - 1) / Bt * ...
        (v(2*Nx-1) + v(2*Nx) ) .* (v(Nx-1) - v(Nx) ) / ( dx^2 );
elseif strcmp(A_BC,'Res') && strcmp(C_BC,'Vn')
    NLdiff1 = (paramObj.Dnl - 1) / paramObj.Bt * ...
        (v(Nx+1) + v(Nx+2) ) / 2 .* (v(2) - v(1) ) / ( dx * (dx/2+paramObj.Lr) );
    NldiffN = (paramObj.Dnl - 1) / paramObj.Bt * ...
        (v(2*Nx-1) + v(2*Nx) ) / 2 .* (v(Nx-1) - v(Nx) ) / ( dx * (dx/2+paramObj.Lr) );
elseif strcmp(A_BC,'PBC') && strcmp(C_BC,'PBC')
  %Unknown
  Nldiff1 = 0; NldiffN = 0;
end

