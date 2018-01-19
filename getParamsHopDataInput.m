% Input parameters for poreExperiment, use physical lengths here 
function [lbox, bt] = getParamsHopDataInput()
lbox = 1e-7;
nBinding = 800; % number of binding sites
conversionFactor = (6.022e8); % [ (Liter * #) / (mol * mum^3)
dPore = 0.06; % pore area in um
% calc bt in Molar
bt = nBinding / (pi()*(dPore/2)^2 * lbox) / conversionFactor;
