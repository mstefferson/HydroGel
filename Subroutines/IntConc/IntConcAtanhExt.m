
function [A,C] = IntConcAtanhExt(AL, AR, Ll,Nt,x)

lambda = 1;

%Initialize
A                   = zeros(1,Nt);
C                   = zeros(1,Nt);

% For now, just a steep exponential
A   = (AL - AR) / 2 .* ( tanh( - lambda * (x-Ll) ) + 1) + AR;

% keyboard

end