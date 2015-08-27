function [C,Clin,CL,CR] = IntConcCcalcEql(A,AL,AR,Bt,KDinv,NLEqn,Lbox,x)

if isfinite(KDinv) % koff = 0 
    if NLEqn %Nonlinear
        C   = KDinv .* (A * Bt)  ./ (1 + KDinv .* A);
        CL  = KDinv .* (AL * Bt) ./ (1 + KDinv .* AL);
        CR  = KDinv .* (AR * Bt) ./ (1 + KDinv .* AR);
        %     Cchem = KDinv .* (Alin * Bt) ;
    else %Linear
        C   = KDinv .* (A * Bt) ;
        CL  = KDinv .* (AL * Bt) ;
        CR  = KDinv .* (AR * Bt) ;
        
        %     Cchem = KDinv .* (Alin * Bt)./ (1 + KDinv .* Alin);
    end % end if linear    
    
else
    C = zeros(1,length(A));
    CR = 0;
    CL = 0;
    if AR == 0 
        CR = 0;
    end
end %end if koff = 0
% if kon = 0;
if KDinv == 0
    C = zeros(1,length(A));
    CR = 0;
    CL = 0;
    if AR == 0 
        CR = 0;
    end
end
Clin = ( CR - CL ) / Lbox .* x + CL;

% keyboard
end %end functionS





