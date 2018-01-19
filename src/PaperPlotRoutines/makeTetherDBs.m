%% Plot DB as a function of KD for analytic model, several tether lengths
% lc in mum
% da = (mum)^2 / s
% kd in molar
%
function [nu, kd_micro] = makeTetherDBs( lclp, kd, kon, da )
if iscolumn( kd ); kd = kd.'; end
if iscolumn( lclp ); lclp = lclp.'; end
kd_micro = kd * 1e6; % in micro molar
koff = kd * kon;
dp = lclp' * koff;
nu = dp ./ (dp + 3*da);
