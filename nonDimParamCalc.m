% nonDimParamCalc( lBox, dA, kD, kon, bt, lplc )
%
% Calculate non-dimensional parameters. physParams are
% the physical parameters, non-dimensional are the scaled 
% parameters that are inputs to the code
%
% All units should be in SI units (seconds, meters, Molar)
%
function [ scaledParams, physParams ] = ...
  nonDimParamCalc( lBox, dA, kD, kon, bt, lplc )
if nargin ~= 6
  error('Incorrect number of inputs')
end
% unscaled
koff = kon * kD;
konBt = kon * bt;
dC = dA * lplc * koff / ( 3  * dA + lplc * koff );
% scaled
tau = lBox ^ 2 ./ dA;
kappaOff = koff * tau;
kappaOnBt = konBt * tau;
kappaOn = kon * tau;
lPlC = lplc ./ (lBox .^ 2);
nu = kappaOff * lPlC ./ ( 3 + kappaOff .* lPlC );
% store it
% phys
physParams.lBox = lBox;
physParams.dA = dA;
physParams.dC = dC;
physParams.kon = kon;
physParams.konBt = konBt;
physParams.koff = koff;
physParams.bt = bt;
physParams.lplc = lplc;
% scaled
scaledParams.Lbox = 1;
scaledParams.Da = 1;
scaledParams.tau = tau;
scaledParams.nu = nu;
scaledParams.Kon = kappaOn;
scaledParams.KonBt = kappaOnBt;
scaledParams.Koff = kappaOff ;
scaledParams.Bt = bt;
scaledParams.Llp = lPlC;
