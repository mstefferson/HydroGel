% Makes the initial concentration with known boundary concentrations of
% species A

function [A,Alin,C,Clin,CL,CR] = ...
    IntConcMaker(AL, AR, Bt, Ka, Lbox, x,NLEq)

[A,Alin] = IntConcAcalcStep(AL, AR, Lbox,x);

% turn A to col vector
if isrow(A)
  A = A';
end

[C,Clin,CL,CR] = IntConcCcalcEql(A,AL,AR,Bt,Ka,NLEq,Lbox,x);

% turn C to col vector
if isrow(C)
  C = C';
end

end