% Rescale the chemistry terms at the endpoints

function [NLchem] = ResChemAtEndPoints(NLchem,Lr,Nx,dx)
    
    NLchem(1)  = ( dx / ( 2 * Lr  + dx ) ) .* NLchem(1);
    NLchem(Nx) = ( dx / ( 2 * Lr  + dx ) ) .* NLchem(Nx) ;
    
end