% Input parameters for poreExperiment, use physical lengths here 
function [lbox, bt, lScale] = getParamsInput()
lbox = 1e-1; % mum
nBinding = 800; % number of binding sites
conversionFactor = (6.022e8); % [ (Liter * #) / (mol * mum^3)
dPore = 0.06; % pore area in um
% calc bt in Molar
bt = nBinding / (pi()*(dPore/2)^2 * lbox) / conversionFactor;
% length scale to change m to mu
lScale = 1e6; % micron in meter
