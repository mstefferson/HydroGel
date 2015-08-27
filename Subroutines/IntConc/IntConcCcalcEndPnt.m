% IntConcCcalc.m
% 
% Description: returns the initial 
%
% Inputs
% CL     =  concentration on the left
% CR     =  concentration on the right
% L_box  =  box size
% x      = position. no endpoints
% lambda = decay constant. should be like (L_box * 100)

function [C,Css,Cp,CpFT] = IntConcCcalcEndPnt(CL, CR, L_box,x,lambda)

% For now, just a steep exponential
C   = CL .* exp(-lambda * x) + CR;
Css = ( CR - CL ) / L_box .* x + CL;
Cp  = C - Css;
CpFT = dst( Cp );

end
% 