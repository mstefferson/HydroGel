% Returns fluxes between gridpoints

function [JA_rec,JC_rec,JT_rec] = ...
    FluxCalcExt(A_rec,C_rec,ParamVec,N_rec,Nt,dxl,dxm,dxr,L,R,LBind,RBind)
% Calculate fluxes
JA_rec = zeros(N_rec,Nt-1);
JC_rec = zeros(N_rec,Nt-1);

Jatemp = zeros(1,Nt-1);
Jctemp = zeros(1,Nt-1);


for i = 1:N_rec   
% A
        Jatemp(1:LBind-1) = -L .* ...
            ( A_rec(i,2:LBind) - A_rec(i,1:LBind-1 ) ) / dxl;
        
        Jatemp(LBind:RBind-1) = -1 .* ...
            ( A_rec(i,LBind+1:RBind) - A_rec(i,LBind:RBind-1) ) / dxm;
        
        Jatemp(RBind:Nt-1) = -R .* ...
            ( A_rec(i,RBind+1:Nt) - A_rec(i,RBind:Nt-1) ) / dxr;
% C     
        
        Jatemp(LBind+1:RBind-2) = -ParamVec(2) .* ...
            ( C_rec(i,LBind+2:RBind-1) - C_rec(i,LBind+1:RBind-2) ) / dxm;
  
    JA_rec(i,:) = Jatemp ;
    JC_rec(i,:) = Jctemp ;
    
end

% Total flux
JT_rec = JA_rec + JC_rec;
