function SSplotterCmpr(SSobj,paramObj,xPde,xOde)
% keyboard
NxODE = length(xOde);NxPDE = length(xPde);

Paramstr = sprintf('Kon=%.1e\nKoff=%.1e\nnu=%.2e\n',...
    paramObj.kon,paramObj.koff,paramObj.nu);

figure()
plot(xOde,SSobj.AnlOde,'-r',xOde,SSobj.CnlOde,'-b',xOde,SSobj.AnlOde+SSobj.CnlOde,'-k',...
     xPde,SSobj.AnlPde,'--r',xPde,SSobj.CnlPde,'--b',xPde,SSobj.AnlPde + SSobj.CnlPde,'--k',...    
     xOde,SSobj.AlinOde,':r',xOde,SSobj.ClinOde,':b',xOde,SSobj.AlinOde+SSobj.ClinOde,':k',...
     xOde,SSobj.AlinAnMtrx,'xr',xOde,SSobj.ClinAnMtrx,'xb',xOde,SSobj.AlinAnMtrx+SSobj.ClinAnMtrx,'xk',...
     xPde,SSobj.AlinPde,'or',xPde,SSobj.ClinPde,'ob',xPde,SSobj.AlinPde + SSobj.ClinPde,'xk')
legend('A (ML NL)','C (ML NL)','A+C (ML NL)',...
        'A (pde NL)','C (pde NL)','A+C (pde NL)',...
        'A (ML Lin)','C (ML Lin)','A+C (ML Lin)',...
        'A (ode Lin)','C (ode Lin)','A+C (ode Lin)',...
        'A (pde Lin)','C (pde Lin)','A+C (pde Lin)')  
 textbp(Paramstr)

 % Match up solutions.
 if mod(NxODE-1,NxPDE-1)  == 0 
 [AssNLcmpr,CssNLcmpr,AssLincmpr,CssLincmpr,...
    AlinAnMtrxcmpr,ClinAnMtrxcmpr,...
    dAnlMatnlPde,dCnlMatnlPde,dApCnlMatnlPde,...
    dAnlMatlinMat,dCnlMatlinMat,dApCnlMatlinMat,...
    dAlinMatlinPde,dClinMatlinPde, dApClinMatlinPde,...
    dAlinMatlinMtrx,dClinMatlinMtrx, dApClinMatlinMtrx] =...
        DiffSSsolCmpr(NxODE,NxPDE,SSobj.AnlOde,SSobj.CnlOde,...
        SSobj.AlinOde,SSobj.ClinOde,SSobj.AlinAnMtrx,SSobj.ClinAnMtrx,...
        SSobj.AnlPde,SSobj.CnlPde,SSobj.AlinPde,SSobj.ClinPde);
%  keyboard
 % Non-linear cmpr
 figure
 
 subplot(2,1,1)
 plot(xPde, SSobj.AnlPde,'r',xPde, SSobj.CnlPde,'b',...
     xPde, SSobj.AnlPde + SSobj.CnlPde,'k',...
     xPde, AssNLcmpr,'r--',xPde, CssNLcmpr,'b--',...
     xPde, AssNLcmpr + CssNLcmpr,'k--')
 legend('A nl Pde','C nl Pde','A+C nlPde','A nl ML','C nl ML','A+C ML',...
     'location','best')
 title('Nonlinear cmpr')
 
 subplot(2,1,2)
 plot(xPde, dAnlMatnlPde,'r',xPde, dCnlMatnlPde,'b',xPde,dApCnlMatnlPde,'k')
 legend('A','C','A+C')
 title('Nonlinear (MATLAB - PDE) cmpr')
 textbp(Paramstr)
 
 
 % Cmpr linear to NL
 figure
 
 subplot(2,1,1)
 plot(xPde, AssNLcmpr,'r',xPde, CssNLcmpr,'b',xPde,AssNLcmpr+CssNLcmpr,'k',...
     xPde, AssLincmpr,'r--',xPde, CssLincmpr,'b--',xPde,AssLincmpr+CssLincmpr,'k--')
 legend('A nl','C nl','A+C nl','A lin','C lin','A+C lin',...
     'location','best')
 title('MatLab Nonlinear to linear  cmpr')
 
 subplot(2,1,2)
 plot(xPde, dAnlMatlinMat,'r',xPde, dCnlMatlinMat,'b',xPde,dApCnlMatlinMat,'k')
 legend('A','C','A+C')
 title('Nonlinear to linear (MATLAB NL - MATLAB LIN) cmpr')
 textbp(Paramstr)
 
 % Linear cmprs
 figure
 subplot(2,1,1)
 plot(xPde, AssLincmpr,'r',xPde, CssLincmpr,'b',xPde,AssLincmpr+CssLincmpr,'k',...
     xPde, AlinAnMtrxcmpr, 'r-',xPde, ClinAnMtrxcmpr,'b-',xPde,...
     AlinAnMtrxcmpr + ClinAnMtrxcmpr,'k-',...
     xPde, SSobj.AlinPde,'r:',xPde, SSobj.ClinPde,'b:',...
     xPde,SSobj.AlinPde + SSobj.ClinPde,'k:' )
 legend('A ML','C ML','A + C ML','A pde','Cpde','A+C pde',...
     'A mtrx','C mtrx','A+C mtrx','location','best')
 title('Linear cmpr')
 
 subplot(2,1,2)
 plot(xPde, dAlinMatlinPde, 'r',xPde, dClinMatlinPde,'b',xPde,dApClinMatlinPde,'k',...
     xPde, dAlinMatlinMtrx,'--r',xPde, dClinMatlinMtrx,'--b',xPde,dApClinMatlinMtrx,'--k' )
 legend('A pde','Cpde','A+C pde','A mtrx','C mtrx','A+C mtrx')
 title('Linear cmpr (MATLAB LIN - PDE/ANALYTIC)')
 textbp(Paramstr)

 
%  %%%%%%%%%%%%% Normalizes
%  % Non-linear cmpr
%  figure
%  plot(xPde, dAnlMatnlPdeNorm,'r',xPde, dCnlMatnlPdeNorm,'b',xPde,dApCnlMatnlPdeNorm,'k')
%  legend('A','C','A+C')
%  title('Normalized Nonlinear (MATLAB vs PDE) cmpr')
%  textbp(Paramstr)
%  % Cmpr linear to NL
%  figure
%  plot(xPde, dAnlMatlinMatNorm,'r',xPde, dCnlMatlinMatNorm,'b',xPde,dApCnlMatlinMatNorm,'k')
%  legend('A','C','A+C')
%  title('Normalized Nonlinear to linear (MATLAB ODE) cmpr')
%  textbp(Paramstr)
%  % Linear cmprs
%  figure
%  plot(xPde, dAlinMatlinPdeNorm, 'r',xPde, dClinMatlinPdeNorm,'b',xPde,dApClinMatlinPdeNorm,'k',...
%      xPde, dAlinMatlinMtrxNorm,'--r',xPde, dClinMatlinMtrxNorm,'--b',xPde,dApClinMatlinMtrxNorm,'--k' )
%  legend('A pde','Cpde','A+C pde','A mtrx','C mtrx','A+C mtrx')
%  title('Normalized Linear cmpr')
%  textbp(Paramstr)
 
%  figure
%  plot(...
%      xPde, AssNLcmpr-SSobj.AnlPde,xPde, CssNLcmpr-SSobj.SSobj.CnlPde,...
%      xPde,(AssNLcmpr +CssNLcmpr)-(SSobj.AnlPde+SSobj.SSobj.CnlPde),...
%      xPde, AssNLcmpr-AssLincmpr,xPde, CssNLcmpr-CssLincmpr,...
%      xPde,(AssNLcmpr +CssNLcmpr)-(AssLincmpr+CssLincmpr),...
%      xPde, AssLincmpr-SSobj.AlinPde,xPde, CssLincmpr-SSobj.ClinPde,...
%      xPde,(AssLincmpr +CssLincmpr)-(SSobj.AlinPde+SSobj.ClinPde),...
%      xPde, AssLincmpr-SSobj.AlinAnMtrxcmpr,xPde, CssLincmpr-SSobj.ClinAnMtrxcmpr,...
%      xPde,(AssLincmpr +CssLincmpr)-(SSobj.AlinAnMtrxcmpr+SSobj.ClinAnMtrxcmpr))
%  textbp(Paramstr)
%  
 
 else
     fprintf('I can cannot do it \n')
 end
 
