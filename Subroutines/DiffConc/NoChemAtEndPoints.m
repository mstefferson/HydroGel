% Turn off chemistry terms at the endpoints

function [NLchem] = NoChemAtEndPoints(NLchem,Nx)
    % Set A to zero
    NLchem(1)  = 0;
    NLchem(Nx) = 0;
    %
    NLchem(Nx+1)  = 0;
    NLchem(2*Nx) = 0;
end