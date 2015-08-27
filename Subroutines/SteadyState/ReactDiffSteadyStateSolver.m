% homodiffsolver. Rescaled by diffusive time
function ReactDiffSteadyStateSolver
clear
close all
global nu AL AR CL CR Bt Kon Koff KDinv linear xa xb BCstr

BCstr = 'DirVn'; % 'Dir','Vn','DirVn'

linear = 0;  %If 1, solve the linear case. keep 0
%Parameter you can edit

KDinv = 1e4;
Koff  = 1e1;
nu  = 1;
AL  = 2e-4;
AR  = 0;
Bt  = 2e-3;

%Spatial endpoints
xa = 0;
xb = 1;
Nx = 1000;

% Calculate other stuff
Kon  = KDinv*Koff;
x = linspace(xa,xb,Nx);

% Calculated parameters/linear solutions
% CL and CR are the values based on chemical equilibrium
CL  = KDinv .* (AL * Bt) ./ (1 + KDinv .* AL);
CR  = KDinv .* (AR * Bt) ./ (1 + KDinv .* AR);

Alin  = (AR - AL) ./ xb .* x + AL;
Clin  = (CR - CL) ./ xb .* x + CL;

% keyboard
if nu == 0
    Ass = Alin;
    Css = KDinv .* (Ass .* Bt) ./ (1 + KDinv .* Ass);
else %solve the coupled ODE
    
    % y = [A dA/dx C dC/dx]
    % Build input for solver
    solinit = bvpinit(x,@intcond);
    % Solve it
    sol     = bvp4c(@odeCoupledDiffChem,@resbcfunc,solinit);
    
    % Now  get numerical value
    y = deval(sol,x);
    
    Ass = y(1,:);
    Css = y(3,:);
%     
%     Ass(1)
%     Css(1)
%     Ass(1) - 2 * Ass(2) + Ass(3)
%     Css(1) - Css(end)
%     Kon * Bt * Ass(1) ./ (Koff + Kon * Ass(1)) - Css(1)
%     keyboard
    
end

PlotSteadyStates(x,Ass,Alin,Css,Clin)

%%%%%%%%%%%%%%%Include functions%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%...............

% Guess solution subroutine. x is a single value, not a point
function yinit = intcond(x)
global AL AR CL CR xa xb BCstr

if strcmp(BCstr,'Dir')
yinit = [(AR - AL) ./ (xb - xa) .* (x-xa) + AL,...
    (AR - AL) ./ (xb - xa),...
    (CR - CL) ./ (xb - xa) .* (x-xa) + CL,...
    (CR - CL) ./ (xb - xa)];
elseif strcmp(BCstr,'Vn')
yinit = [AL, 0,0, 0];
elseif strcmp(BCstr,'DirVn')
yinit = [(AR - AL) ./ (xb - xa) .* (x-xa) + AL, ...
    (AR - AL) ./ (xb - xa),...
    0, 0];
else
    fprintf('No Boundary Value selected\n')
end
    
% ODE subroutine
function dydx = odeCoupledDiffChem(x,y)
%Parameters you can edit
global nu Bt Kon Koff linear

%form y' = f(x,y)
if linear
    dydx = ...
        [ y(2); Kon .*( Bt ) .* y(1) - Koff* y(3);...
        y(4); -1/nu .* ( Kon .*( Bt ) .* y(1) - Koff*y(3) ) ];
    
else
    dydx = ...
        [ y(2); Kon .*( Bt - y(3) ) .* y(1) - Koff * y(3);...
        y(4);  -1/nu .* ( Kon .*( Bt - y(3) ) .* y(1) - Koff*y(3) ) ];
end
%..

% Boundary condition subroutine
function res = resbcfunc(ya,yb)

global AL AR CL CR BCstr

if strcmp(BCstr,'Dir') % Both Dirichlet
    res = [ ya(1) - AL; ya(3)-CL; yb(1)-AR;yb(3)-CR];
elseif strcmp(BCstr,'Vn') %Both Von Neumann
    res = [ ya(2); ya(4); yb(2); yb(4)];
elseif strcmp(BCstr,'DirVn')% A Dirichlet C Vn
    res = [ ya(1) - AL; ya(4); yb(1)-AR;yb(4)];
else
    fprintf('No Boundary Value selected\n')
end


function PlotSteadyStates(x,Ass,Alin,Css,Clin)
global nu Bt Kon Koff AL 

x_trim = x(2:end-1);
dx     = x(2)-x(1);
%Calculate diffusion and chemical terms
Adiff =      ( Ass(1:end-2)  - 2 * Ass(2:end-1) + Ass(3:end) ) ./ dx^2 ;
Cdiff = nu * ( Css(1:end-2)  - 2 * Css(2:end-1) + Css(3:end) ) ./ dx^2  ;

Achem = -Kon .* ( Ass(2:end-1) .* (Bt - Css(2:end-1)) ) + Koff * Css(2:end-1);
Cchem = -Koff .* ( Ass(2:end-1) .* (Bt - Css(2:end-1)) ) - Koff * Css(2:end-1);

% keyboard
figure(1)
plot(x,Ass,x,Css,x,Ass + Css)
legend('A','C','A+C')
Paramstr = sprintf('Kon = %.1e \n Koff = %.1e \n nu = %.1e',Kon,Koff,nu);
Concstr  = sprintf('AL = %.1e \n Bt = %.1e',AL,Bt);
textbp(Paramstr)
textbp(Concstr)

% % Plot solutions
% subplot( 3, 1, 1 )
% plot( x, Ass,x,Alin )
% legend('Steady State','Linear')
% Ax = gca;
% Ax.YLim = [0 max(Ass + Css)];
% title('A')
% 
% subplot( 3, 1, 2 )
% plot( x, Css,x, Clin )
% legend('Steady State','Linear')
% Ax = gca;
% Ax.YLim = [0 max(Ass + Css)];
% title('C')
% 
% if strcmp(BCstr,'Dir')
% subplot( 3, 1, 3 )
% plot( x, Ass + Css, x, Alin + Clin )
% legend('Steady State','Linear')
% Ax = gca;
% Ax.YLim = [0 max(Ass + Css)];
% title('A + C')
% elseif strcmp(BCstr,'DirVn')
% subplot( 3, 1, 3 )
% plot( x, Ass + Css, ...
%     x, ...
%     ( Ass(end) + Css(end) - ( Ass(1) + Css(1) ) ./ x(1) .* x...
%     + Ass(1) + Css(1)) )
% legend('Steady State','Linear')
% Ax = gca;
% Ax.YLim = [0 max(Ass + Css)];
% title('A + C')
% end
% Plot difference in linear and steady state solutions
figure(2)

subplot( 3, 1, 1 )
plot( x, Ass-Alin )
title('Asteady - Alin')

subplot( 3, 1, 2 )
plot( x, Css-Clin )
title('Csteady - Clin')

subplot( 3, 1, 3 )
plot( x, Ass + Css - (Alin + Clin) )
title('A+C steady - A+C lin')


% Plot the diffusive and chemical terms
figure(3)
subplot( 4, 1, 1 )
plot( x_trim, Adiff,x_trim,Achem )
legend('diff','chem')
title('[A] terms in the PDE')

subplot( 4, 1, 2 )
plot( x_trim, Adiff+Achem )
title('Adiff+Achem')

subplot( 4, 1, 3 )
plot( x_trim, Cdiff,x_trim,Cchem )
legend('diff','chem')
title('[C] terms in the PDE')

subplot( 4, 1, 4 )
plot( x_trim, Cdiff+Cchem )
title('Cdiff+Cchem')
