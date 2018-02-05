% Current  output flux is j* = d/dx* A(x,t) (units mol)
% Units of A(x,t) = 1 / L^3, x* is unitless, x / L
% where L is length scale = lBox
% Desired flux in 3D j = - Da d/dx A(x,t), units N / (L^2 t )
% Desired flux in 1D j = - Da (pore area) d/dx A(x,t), units N / t
% scaled diffusive flux j^* = dA/dx^*= L d/dx A -> d/dx A = j* / L
% Thus, desired flux in 1D is j = - ( ( Da x pore area ) / L ) x j*
% Molar is in moles/L. Want number/m^3
% Conversion factor is moles/L = 6.022 * 10^(26) (number)/m^3
%
Da = 1e-12; % diffusion coefficient, units: m^2 / s
lBox = 1e-7; % box length, units: m
scaleFac = 6.022e26; % conversion factor: (number * Liter) / (mol*m^3) 
jDiff_output = 1e-6; % scaled diffusive flux, dA/dx^*, units= mol/liter
dPore = [4e-8 6e-8]; % % pore diameter, units: m
% Store the flux for each pore diameter
jF_store = zeros( 1, length(dPore) );
j1D_store = zeros( 1, length(dPore) );
for ii = 1:length(dPore)
  % measure the pore area
  areaPore = pi * ( dPore(ii) / 2 ) .^ 2;
  % calculate jF, the flux scaling factor
  jFtemp = scaleFac * Da * areaPore / lBox;
  j1Dtemp = jDiff_output * jFtemp;
  jF_store(ii) = jFtemp;
  j1D_store(ii) = j1Dtemp;
  fprintf('Pore diameter = %g, jf = %g, j1D = %g\n',...
   dPore(ii), jFtemp, j1Dtemp )
end