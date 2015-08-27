
function [A,B,C] = ...
    IntConcentMakerExtTrip(AL, AR, Bt, Nt,LBind,RBind)

%Initialize
A                   = zeros(1,Nt);
B                   = zeros(1,Nt);
C                   = zeros(1,Nt);

%Set-up like experiment
A(1:LBind-1)   = AL;
A(LBind:RBind) = 0;
A(RBind+1:Nt)  = AR;

B(LBind:RBind) = Bt;

end