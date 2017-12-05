%% Plot DB as a function of KD for analytic model, several tether lengths
function [db, kd, lc] = makeTetherDBs()
lp =1;
df =1;
lc = [10, 30, 100, 300, 1000, 1e4];
kd = logspace( -2, 3 ); % in micro molar
kd_molar = kd * 1e-6;
kon = 1e9; % (per Molar sec)
konScaled = kon * 0.01; % scaled by tau
koffScaled = konScaled * kd_molar; % scaled by tau
lscale = 1e-7;
lpScaled = lp * 1e-9 ./ lscale;
lcScaled = lc * 1e-9 ./ lscale;
db = zeros(length(koffScaled),length(lc));
for lcIndex=1:length(lc)
  for koffIndex = 1:length(koffScaled)
    db(koffIndex,lcIndex) = (koffScaled(koffIndex)*lcScaled(lcIndex)*lpScaled * df)/...
      (3*df+koffScaled(koffIndex)*lcScaled(lcIndex)*lpScaled);
  end
end
end
