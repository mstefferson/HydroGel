%% Plot DB as a function of KD for analytic model, several tether lengths
% lc in nm
% kd in molar
function [db, kd_micro, lplc] = makeTetherDBs(lc, kd)
lp =1; % in nm
df =1; % scaled out
kd_micro = kd * 1e6; % kd in micro molar
kon = 1e9; % (per Molar sec)
tau = 0.01; % time scale based on lscale= 1e-7, df = 1e-12
konScaled = kon * 0.01; % scaled by tau
koffScaled = konScaled * kd; % scaled by tau
lscale = 1e-7; % length scale
lpScaled = lp * 1e-9 ./ lscale;
lcScaled = lc * 1e-9 ./ lscale;
lplc = lpScaled * lcScaled;
db = zeros(length(koffScaled),length(lc));
for lcIndex=1:length(lc)
  for koffIndex = 1:length(koffScaled)
    db(koffIndex,lcIndex) = (koffScaled(koffIndex)*lcScaled(lcIndex)*lpScaled * df)/...
      (3*df+koffScaled(koffIndex)*lcScaled(lcIndex)*lpScaled);
  end
end
end
