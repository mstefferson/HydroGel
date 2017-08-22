% nonDimParamCalc( lBox, dA, kD, kon, bt, lplc )
%
% Calculate non-dimensional parameters. physParams are
% the physical parameters, non-dimensional are the scaled 
% parameters that are inputs to the code
%
% All units should be in SI units (seconds, meters, Molar)
%
function [ scaledDiff, scaledKon, scaledKoff, physParams ] = ...
  nonDimParamCalc( lBox, dA, kD, kon, bt, lplc )
if nargin ~= 6
  error('Incorrect number of inputs')
end
% unscaled
koff = kon * kD;
konBt = kon * bt;
dC = dA * lplc * koff / ( 3  * dA + lplc * koff );
% phys
physParams.lBox = lBox;
physParams.dA = dA;
physParams.dC = dC;
physParams.kon = kon;
physParams.konBt = konBt;
physParams.koff = koff;
physParams.bt = bt;
physParams.lplc = lplc;
% scaled diffusion
tau = lBox ^ 2 ./ dA;
L = lBox;
kappaOff = koff * tau;
kappaOnBt = konBt * tau;
kappaOn = kappaOnBt / bt;
lPlC = lplc ./ (L .^ 2);
nu =  lPlC ./ ( 3 * dA / (L^2 * koff) + lPlC );
% store it
scaledDiff.tau = tau;
scaledDiff.L = lBox;
scaledDiff.Lbox = 1;
scaledDiff.Da = 1;
scaledDiff.nu = nu;
scaledDiff.Kon = kappaOn;
scaledDiff.KonBt = kappaOnBt;
scaledDiff.Koff = kappaOff ;
scaledDiff.Bt = bt;
scaledDiff.Llp = lPlC;
% scaled kon
tau = 1 / (kon * bt) ;
L = sqrt( dA ./ (konBt) );
kappaOff = kD / bt;
kappaOnBt = 1;
kappaOn = kappaOnBt / bt;
lPlC = lplc ./ (L .^ 2);
nu =  lPlC ./ ( 3 * dA / (L^2 * koff) + lPlC );
% store it
scaledKon.Lbox = lBox / L;
scaledKon.Da = 1;
scaledKon.tau = tau;
scaledKon.nu = nu;
scaledKon.Kon = kappaOn;
scaledKon.KonBt = kappaOnBt;
scaledKon.Koff = kappaOff ;
scaledKon.Bt = bt;
scaledKon.Llp = lPlC;
% scale koff
tau = 1 / (koff) ;
L = sqrt( dA ./ (koff) );
kappaOff = 1;
kappaOnBt = bt / kD ;
kappaOn =  kappaOnBt / bt;
lPlC = lplc ./ (L .^ 2);
nu =  lPlC ./ ( 3 * dA / (L^2 * koff) + lPlC );
% store it
scaledKoff.Lbox = lBox / L;
scaledKoff.Da = 1;
scaledKoff.tau = tau;
scaledKoff.nu = nu;
scaledKoff.Kon = kappaOn;
scaledKoff.KonBt = kappaOnBt;
scaledKoff.Koff = kappaOff ;
scaledKoff.Bt = bt;
scaledKoff.Llp = lPlC;
