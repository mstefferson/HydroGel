% Current flux is measure as j* = d/dx* A(x,t)
% Units of A(x,t) = 1 / L^3, x* is unitless, x / L
% where L is length scale = lBox
% Desired flux in 3D j = - Da d/dx A(x,t), units N / (L^2 t )
% Desired flux in 1D j = - Da (pore area) d/dx A(x,t), units N / t
% write j* = L d/dx A -> d/dx A = j* / L
% Thus, j = - ( ( Da x pore area ) / L ) x j*
% Molar is in moles/L. Want number/m^3
% moles/L = 6.022 * 10^(26) (number)/m^3
Da = 1e-12;
lBox = 1e-7;
scaleFac = 6.022e26;
jDiff = 1e-6;
% pore diameter = 60 nm
dPore = [4e-8 6e-8];
% store for both
jFacStore = zeros( 1, length(dPore) );
jOutStore = zeros( 1, length(dPore) );
for ii = 1:length(dPore)
  areaPore = pi * ( dPore(ii) / 2 ) .^ 2;
  jFac = scaleFac * Da * areaPore / lBox;
  jOut = jDiff * jFac;
  jFacStore(ii) = jFac;
  jOutStore(ii) = jOut;
  fprintf('Pore diameter = %g, jf = %g, jOut = %g\n',...
   dPore(ii), jFac, jOut )
end

