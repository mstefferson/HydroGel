function [C,Clin,CL,CR] = IntConcCcalcEql(A,AL,AR,Bt,Ka,NLEqn,Lbox,x)

if isfinite(Ka) % koff = 0 
    if NLEqn %Nonlinear
        C   = Ka .* (A * Bt)  ./ (1 + Ka .* A);
        CL  = Ka .* (AL * Bt) ./ (1 + Ka .* AL);
        CR  = Ka .* (AR * Bt) ./ (1 + Ka .* AR);
        %     Cchem = Ka .* (Alin * Bt) ;
    else %Linear
        C   = Ka .* (A * Bt) ;
        CL  = Ka .* (AL * Bt) ;
        CR  = Ka .* (AR * Bt) ;
        
        %     Cchem = Ka .* (Alin * Bt)./ (1 + Ka .* Alin);
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
if Ka == 0
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





