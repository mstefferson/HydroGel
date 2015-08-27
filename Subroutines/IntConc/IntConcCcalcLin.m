function [C,Css,Cp,CpFT,CL,CR] = IntConcCcalcLin(A,AL,AR,Ass,Bt,L_box,x,KDinv,linear)

CL  = KDinv .* (AL * Bt) ./ (1 + KDinv .* AL);
CR  = KDinv .* (AR * Bt) ./ (1 + KDinv .* AR);
 
if linear
    C   = KDinv .* (A * Bt) ;
    CL  = KDinv .* (AL * Bt) ;
    CR  = KDinv .* (AR * Bt) ;
   
else
    C   = KDinv .* (A * Bt)  ./ (1 + KDinv .* A);
    CL  = KDinv .* (AL * Bt) ./ (1 + KDinv .* AL);
    CR  = KDinv .* (AR * Bt) ./ (1 + KDinv .* AR);

end

Css = ( CR - CL ) / L_box .* x + CL;

% keyboard
Cp  = C - Css;

CpFT = dst( Cp );
% keyboard
end


