function Dc = boundTetherDiffCalc( Llp, koff, Da )
% bound tethered calc by L. Maguire
Dc = ( Llp * koff * Da ) ./  ( koff * Llp + 3 * Da );
% if Lp = Inf, Dc = 1
Dc( isnan( Dc ) ) = 1;
end

