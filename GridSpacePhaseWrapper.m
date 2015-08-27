%% GridSpacePhaseWrapper

% Steady State or time
SteadyStateODE     = 1;
Lbox  = 1;             % Gel length
Nx    = floor(256*Lbox); %Internal gridpoints. Does not include endpoints
t_tot       = 1 * Lbox^2;      % total time
BCstr = 'DirVn';
Nx = 2500;

for ii = 6:11
Nx    = 2^ii
IntParamPhaseLoop
end