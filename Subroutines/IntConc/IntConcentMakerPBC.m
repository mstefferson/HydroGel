
function [A,C,A_FT,C_FT] = ...
    IntConcentMakerPBC( Bt, KDinv, x,linear,N,L_box)

Norm = 1;


% [A] = IntConc1D_GaussPBC(x,N,Norm);
[A] = IntConc1D_SinePBC(x,N,L_box,Norm);

%[A,Ass,Ap,ApFT] = IntConcAcalcStep(AL, AR, L_box,x);
% keyboard
[C] = IntConcCcalcEqlPBC(A,Bt,KDinv,linear);

A_FT = fftshift( fft( A ) );
C_FT = fftshift( fft( C ) );
% [C,Css,Cp,CpFT] = IntConcCcalc(CL, CR, L_box,x,lambda);
% keyboard
end