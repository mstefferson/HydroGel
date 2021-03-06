% IntConcAcalc.m
% 
% Description: returns the initial 
%
% Inputs
% AL     =  concentration on the left
% AR     =  concentration on the right
% L_box  =  box size
% x      = position no endpoints
% lambda = decay constant. should be like (L_box * 100)

function [A,Ass,Ap,ApFT] = IntConcAcalcExp(AL, AR, L_box,x,lambda)


% For now, just a steep exponential
A   = (AL - AR) .* exp(-lambda * x) + AR;
Ass = ( AR - AL ) / L_box .* x + AL;
Ap  = A - Ass;
ApFT = dst( Ap );

% keyboard
end
% 