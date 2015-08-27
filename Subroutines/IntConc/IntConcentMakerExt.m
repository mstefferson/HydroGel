
function [A,C] = ...
    IntConcentMakerExt(AL, AR, Nt,LBind,RBind)

%Initialize
A                   = zeros(1,Nt);
C                   = zeros(1,Nt);

%Set-up like experiment
A(1:LBind)         = AL;
A(LBind+1:RBind-1) = 0;
A(RBind:Nt)        = AR;

end