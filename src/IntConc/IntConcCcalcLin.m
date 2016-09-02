function [C,Css,Cp,CpFT,CL,CR] = IntConcCcalcLin(A,AL,AR,Ass,Bt,L_box,x,Ka,linear)

CL  = Ka .* (AL * Bt) ./ (1 + Ka .* AL);
CR  = Ka .* (AR * Bt) ./ (1 + Ka .* AR);
 
if linear
    C   = Ka .* (A * Bt) ;
    CL  = Ka .* (AL * Bt) ;
    CR  = Ka .* (AR * Bt) ;
   
else
    C   = Ka .* (A * Bt)  ./ (1 + Ka .* A);
    CL  = Ka .* (AL * Bt) ./ (1 + Ka .* AL);
    CR  = Ka .* (AR * Bt) ./ (1 + Ka .* AR);

end

Css = ( CR - CL ) / L_box .* x + CL;

% keyboard
Cp  = C - Css;

CpFT = dst( Cp );
% keyboard
end


