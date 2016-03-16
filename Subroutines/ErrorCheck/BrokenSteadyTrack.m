function [DidIBreak, SteadyState] = BrokenSteadyTrack(epsilon)


global v;
global vNext;

DidIBreak  = 0;
SteadyState = 0;

if min(v) < 0
    fprintf('Something went negative\n')
    DidIBreak = 1;
end
if find(~isfinite(v)) ~= 0
    fprintf('Something blew up\n')
    DidIBreak = 1;
end
% Check for steady state. max() is ok with NaN
if max( abs( (v-vNext)./v ) ) < epsilon
    SteadyState = 1;    
end


end
