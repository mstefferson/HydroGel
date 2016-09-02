function [AssNLcmpr,CssNLcmpr,AssLincmpr,CssLincmpr,...
    AlinAnMtrxcmpr,ClinAnMtrxcmpr,...
    dAnlMatnlPde,dCnlMatnlPde,dApCnlMatnlPde,...
    dAnlMatlinMat,dCnlMatlinMat,dApCnlMatlinMat,...
    dAlinMatlinPde,dClinMatlinPde, dApClinMatlinPde,...
    dAlinMatlinMtrx,dClinMatlinMtrx, dApClinMatlinMtrx] =...
        DiffSSsolCmpr(NxODE,NxPDE,AnlOde,CnlOde,AlinOde,ClinOde,...
        AlinAnMtrx,ClinAnMtrx,AnlPde,CnlPde,AlinPde,ClinPde)



CmprDint = (NxODE-1)/(NxPDE-1);
AssNLcmpr = AnlOde(1:CmprDint:NxODE);
CssNLcmpr = CnlOde(1:CmprDint:NxODE);
AssLincmpr = AlinOde(1:CmprDint:NxODE);
CssLincmpr = ClinOde(1:CmprDint:NxODE);
AlinAnMtrxcmpr = AlinAnMtrx(1:CmprDint:NxODE);
ClinAnMtrxcmpr = ClinAnMtrx(1:CmprDint:NxODE);
% keyboard
% MATLAB's nl ode - nl pde
dAnlMatnlPde   = AssNLcmpr-AnlPde;
dCnlMatnlPde   = CssNLcmpr-CnlPde;
dApCnlMatnlPde = (AssNLcmpr + CssNLcmpr) - (AnlPde + CnlPde);
% Normalized
%  dAnlMatnlPdeNorm   = dAnlMatnlPde ./ AssNLcmpr;
%  dCnlMatnlPdeNorm   = dCnlMatnlPde ./ CssNLcmpr;
%  dApCnlMatnlPdeNorm = dApCnlMatnlPde ./ (AssNLcmpr + CssNLcmpr);
%
% MATLAB's nl ode - lin ode
dAnlMatlinMat  = AssNLcmpr-AssLincmpr;
dCnlMatlinMat  = CssNLcmpr-CssLincmpr;
dApCnlMatlinMat  = (AssNLcmpr + CssNLcmpr) - (AssLincmpr + CssLincmpr);
% Normalized
%  dAnlMatlinMatNorm = dAnlMatlinMat./ AssNLcmpr;
%  dCnlMatlinMatNorm = dCnlMatlinMat./ CssNLcmpr;
%  dApCnlMatlinMatNorm = dApCnlMatlinMat./ (AssNLcmpr + CssNLcmpr);

% MATLAB's lin ode - lin pde
dAlinMatlinPde   = AssLincmpr-AlinPde;
dClinMatlinPde   = CssLincmpr-ClinPde;
dApClinMatlinPde = (AssLincmpr+CssLincmpr)-(AlinPde+ClinPde);
% Normalized
%  dAlinMatlinPdeNorm = dAlinMatlinPde ./ AssLincmpr;
%  dClinMatlinPdeNorm = dClinMatlinPde ./ CssLincmpr;
%  dApClinMatlinPdeNorm = dApClinMatlinPde ./ (AssLincmpr+CssLincmpr);

% MATLAB's lin ode - matrix ode
dAlinMatlinMtrx   = AssLincmpr-AlinAnMtrxcmpr;
dClinMatlinMtrx   = CssLincmpr-ClinAnMtrxcmpr;
dApClinMatlinMtrx   = (AssLincmpr + CssLincmpr)-(AlinAnMtrxcmpr+ClinAnMtrxcmpr);

%  dAlinMatlinMtrxNorm = dAlinMatlinMtrx ./ AssLincmpr;
%  dClinMatlinMtrxNorm = dClinMatlinMtrx ./ CssLincmpr;
%  dApClinMatlinMtrxNorm = dApClinMatlinMtrx ./ (AssLincmpr + CssLincmpr);
