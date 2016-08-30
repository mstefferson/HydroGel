% Makes the initial concentration with known boundary concentrations of
% species A

function [A,Alin,C,Clin,CL,CR] = ...
    IntConcMaker(AL, AR, Bt, Ka, Lbox, x,NLEq)

% [A,Ass,Ap,ApFT] = IntConcAcalcExp(AL, AR, L_box,x,lambda);
% [A,Ass,Ap,ApFT] = IntConcAtanhStep(AL, AR, L_box,x,lambda);
[A,Alin] = IntConcAcalcStep(AL, AR, Lbox,x);
% keyboard

[C,Clin,CL,CR] = IntConcCcalcEql(A,AL,AR,Bt,Ka,NLEq,Lbox,x);
% C(1) = 0; C(end) = 0;

end