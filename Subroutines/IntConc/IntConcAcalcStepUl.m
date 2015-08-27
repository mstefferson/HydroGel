% IntConcAcalcStepL.m
% 
% Description: returns the initial 
%
% Inputs
% AL     =  concentration on the left
% AR     =  concentration on the right
% L_box  =  box size
% x      = position no endpoints
% lambda = decay constant. should be like (L_box * 100)

function [AuL] = IntConcAcalcStepUl(AuLi,x)

% keyboard
% For now, just a steep exponential
AuL    = AuLi .* ones(1,length(x));
% A(1) = Ass(1);

end
% 