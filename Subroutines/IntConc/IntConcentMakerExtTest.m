
function [A,C] = ...
    IntConcentMakerExtTest(AL,AR,Nt,LBind,RBind,x,Lt)

%Initialize
A = zeros(1,Nt);
C = zeros(1,Nt);

%Set-up like experiment
A(1:LBind)         = AL;
A(LBind+1:RBind-1) = 0;
A(RBind:Nt)        = AR;

% A = exp( - (x-Lt/2).^2 / (Lt/100) ); 
C(LBind:RBind) = 0.0001 * exp( - (x(LBind:RBind)-Lt/2).^2 / (Lt/100) ); 



end