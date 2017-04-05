function [DidIBreak, SteadyState] = BrokenSteadyTrack(v, vNext, epsilon)
% initialize
DidIBreak  = 0;
SteadyState = 0;
% check
if any( v < 0 )
    fprintf('Something went negative\n')
    DidIBreak = 1;
end
if any( isinf(v) ) || any( isnan(v) )
    fprintf('Something blew up\n')
    DidIBreak = 1;
end
% Check for steady state. max() is ok with NaN
if max( abs( (v-vNext)./v ) ) < epsilon
    SteadyState = 1;    
end
end
