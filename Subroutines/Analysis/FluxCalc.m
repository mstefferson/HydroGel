% Need to rewrite

function [JA_rec,JC_rec,JT_rec] = FluxCalc(A_rec,C_rec,ParamVec,N_rec,N,x,ND)
% Calculate fluxes
JA_rec = zeros(N_rec,N+1);
JC_rec = zeros(N_rec,N+1);

dx = x(2) - x(1);
for i = 1:N_rec   
    if ND
        Jatemp = -1 .* ...
            ( A_rec(i,2:end) - A_rec(i,1:end-1) ) / (dx );
        Jctemp = -ParamVec(2) .* ...
            ( C_rec(i,2:end) - C_rec(i,1:end-1) ) / (dx );
    else
        Jatemp = -ParamVec(3) .* ...
            ( A_rec(i,2:end) - A_rec(i,1:end-1) ) / (dx );
        Jctemp = -ParamVec(4) .* ...
            ( C_rec(i,2:end) - C_rec(i,1:end-1) ) / (dx );
    end
    JA_rec(i,:) = Jatemp ;
    JC_rec(i,:) = Jctemp ;
    
end

% Total flux
JT_rec = JA_rec + JC_rec;
