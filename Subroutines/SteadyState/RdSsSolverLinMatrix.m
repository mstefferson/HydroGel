function [AlinMat, ClinMat] = ...
    RdSsSolverLinMatrix(Kon,Koff,Bt,nu,Lbox,AL,AR,x)

if nu ~= 0
    M = [ 0 0 1 0;0 0 0 1; Kon*Bt -Koff 0 0; -Kon*Bt/nu Koff/nu 0 0];
    
    % v = [A C dA/dx dC/dx]
    PropAtLHS = expm(M*Lbox);
    
    M2Inv = [PropAtLHS(1,2) 0 PropAtLHS(1,3) 0;...
        PropAtLHS(2,2) -1 PropAtLHS(2,3) 0;...
        PropAtLHS(3,2) 0 PropAtLHS(3,3) -1;...
        PropAtLHS(4,2) 0 PropAtLHS(4,3) 0];
    
    v = [AR-PropAtLHS(1,1)*AL;-PropAtLHS(2,1)*AL;...
        -PropAtLHS(3,1)*AL;-PropAtLHS(4,1)*AL];
    
    BVS = M2Inv\v;
    CL = BVS(1);
    CR = BVS(2);
    
    v0 = [AL;CL;BVS(3);0];
    
    AlinMat = ones(1,length(x));
    ClinMat = ones(1,length(x));
    for i = 1: length(x)
        
        vx = expm(M*x(i)) * v0;
        AlinMat(i) = vx(1);
        ClinMat(i) = vx(2);
    end
    
else
    AlinMat = (AR-AL)./Lbox .* x + AL;
    ClinMat = KDinv .* Bt .* Alin;
end