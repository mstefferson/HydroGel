% homodiffsolver
function SSsolverDiffChemCoup
clear
close all
global nu AL AR CL CR Bt KDinv linear xa xb

linear = 0;  %If 1, solve the linear case. keep 0
%Parameter you can edit
trial  = 10;
KDinv  = 1e6;
nu  = 1;
AL  = 2e-4;
AR  = 0;
Bt  = 2e-4;

%Spatial endpoints
xa = 0;
xb = 1;
Nx = 1000;
x = linspace(xa,xb,Nx);

%Calculated parameters/linear solutions
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
    solinit = bvpinit(linspace(xa,xb,Nx),@intcond);
    % Solve it
    sol     = bvp4c(@odeCoupledDiffChem,@doubconcbc,solinit);
    
    % Now  get numerical value
    y = deval(sol,x);
    
    Ass = y(1,:);
    Css = y(3,:);
    
end

h = PlotSteadyStates(x,Ass,Alin,Css,Clin);
savestr = sprintf('SteadyState_t%d.jpg',trial);
saveas(h,savestr)

%%%%%%%%%%%%%%%Include functions%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%...............
% ODE subroutine
function dydx = odeCoupledDiffChem(x,y)
%Parameters you can edit
global nu Bt KDinv linear

%form y' = f(x,y)
if linear
    dydx = [ y(2);           KDinv .*( Bt ) .* y(1) - y(3);
        y(4); -1/nu .* ( KDinv .*( Bt ) .* y(1) - y(3) ) ];
    
else
    dydx = [ y(2);             KDinv .*( Bt - y(3) ) .* y(1) - y(3);
        y(4);  -1/nu .* ( KDinv .*( Bt - y(3) ) .* y(1) - y(3) ) ];
end
%..

% Boundary condition subroutine
function res = doubconcbc(ya,yb)
global AL AR CL CR
res = [ ya(1) - AL; ya(3)-CL; yb(1)-AR;yb(3)-CR];


% Guess solution subroutine
function yinit = intcond(x)
global AL AR CL CR xa xb

yinit = [(AR - AL) ./ (xb - xa) .* (x-xa) + AL,...
    (AR - AL) ./ (xb - xa),...
    (CR - CL) ./ (xb - xa) .* (x-xa) + CL,...
    (CR - CL) ./ (xb - xa)];

function [h] = PlotSteadyStates(x,Ass,Alin,Css,Clin)
global nu KDinv Bt

x_trim = x(2:end-1);
dx     = x(2)-x(1);
%Calculate diffusion and chemical terms
Adiff =      ( Ass(1:end-2)  - 2 * Ass(2:end-1) + Ass(3:end) ) ./ dx^2 ;
Cdiff = nu * ( Css(1:end-2)  - 2 * Css(2:end-1) + Css(3:end) ) ./ dx^2  ;

Achem = -KDinv .* ( Ass(2:end-1) .* (Bt - Css(2:end-1)) ) + Css(2:end-1);
Cchem =  KDinv .* ( Ass(2:end-1) .* (Bt - Css(2:end-1)) ) - Css(2:end-1) ;

% keyboard
h = figure(1);
% Plot solutions
subplot( 2, 2, 1 )
plot( x, Ass,x,Alin )
legend('Steady State','Linear','Location','best')
title('A')

subplot( 2, 2, 3 )
plot( x, Css,x, Clin )
legend('Steady State','Linear','Location','best')
title('C')


subplot( 2, 2, 2 )
plot( x, Ass+Css,x, Alin+Clin )
legend('Steady State','Linear','Location','best')
title('A+C')

subplot( 2, 2, 4 )
    ParamStr = sprintf('KDinv = %.1e \n nu = %.1e \n Bt = %.1e \n', ...
        KDinv, nu,Bt );
    text(0.4,0.4,0.4,ParamStr)

% Plot difference in linear and steady state solutions
if 0
figure(2)

subplot( 2, 1, 1 )
plot( x, Ass-Alin )
title('Asteady - Alin')

subplot( 2, 1, 2 )
plot( x, Css-Clin )
title('Csteady - Clin')

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
end