function [C] = IntConcCcalcEqlPBC(A,Bt,KDinv,linear)

if linear
    C   = KDinv .* (A * Bt) ;
else
    C   = KDinv .* (A * Bt)  ./ (1 + KDinv .* A);  
end

% keyboard
end


