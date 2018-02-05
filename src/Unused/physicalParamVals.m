Bt = 1e-3; % M = Moles L ^ (-1) = m^(-3)
Al = 1e-6; % M = m^(-3)
Da = 1e-12; % L^2 s^(-1)
kon = 1e9; % s^(-1) M^(-1) = m^3 s^(-1)
kD = [ 1e-6 1e-3 ] % M = m^(-3)
lBox = 1e-7 % m
lp = 1e-9 % m
lc = [1e-8 1e-3] % m
lplc = lp .* lc;

[ scaledDiff, scaledKon, scaledKoff, physParams ] = ...
  nonDimParamCalc( lBox, Da, kD(1), kon, Bt, lplc(1) )
