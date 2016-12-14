function Dc = boundTetherDiffCalc( Llp, koff, Da )

Dc = ( Llp * koff * Da ) ./  ( koff * Llp + 3 * Da );

end

