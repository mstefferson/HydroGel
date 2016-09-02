function [C] = IntConcCcalcEqlPBC(A,Bt,Ka,linear)

if linear
    C   = Ka .* (A * Bt) ;
else
    C   = Ka .* (A * Bt)  ./ (1 + Ka .* A);  
end

% keyboard
end


