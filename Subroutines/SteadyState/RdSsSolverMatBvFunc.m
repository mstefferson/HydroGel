% homodiffsolver. Rescaled by diffusive time
function [Ass,Css,x] = RdSsSolverMatBvFunc(...
    KonVal,KoffVal,nuVal,ALval,ARval,Btval,Lboxval,BCstrVal,Nx,linearEqn)

global nu AL AR CL CR Bt Kon Koff KDinv xa xb BCstr

% keyboard
% Make sure linear eqn is zero or one
if linearEqn ~= 0 && linearEqn ~= 1 
  error('Need to set linear eqn parameter to 0 or 1')  
end
BCstr = BCstrVal; % 'Dir','Vn','DirVn'
% keyboard
%Parameter you can edit
Kon = KonVal;
Koff  = KoffVal;
nu  = nuVal;
AL  = ALval;
AR  = ARval ;
Bt  = Btval;

%Spatial endpoints
xa = 0;
xb = Lboxval;

% Calculate other stuff
KDinv  = Kon/Koff;
x = linspace(xa,xb,Nx);


% keyboard
% Calculated parameters/linear solutions
% CL and CR are the values based on chemical equilibrium
CL  = KDinv .* (AL * Bt) ./ (1 + KDinv .* AL);
CR  = KDinv .* (AR * Bt) ./ (1 + KDinv .* AR);
% keyboard

% keyboard
if nu == 0
    Alin  = (AR - AL) ./ xb .* x + AL;
    Ass = Alin;   
    Css = KDinv .* (Ass .* Bt) ./ (1 + KDinv .* Ass);
  
else %solve the coupled ODE
    
    % y = [A C dA/dx dC/dx]
    % Build input for solver
    solinit = bvpinit(x,@intcond);
    % Solve it
    if linearEqn == 1
        sol    = bvp4c(@odeCoupledDiffChemLin,@resbcfunc,solinit);
    else
        sol     = bvp4c(@odeCoupledDiffChemNL,@resbcfunc,solinit);
    end 

    % Now  get numerical value
    y = deval(sol,x);
   
    
%     keyboard
    Ass = y(1,:);
    Css = y(2,:);
   
%     keyboard
end


%%%%%%%%%%%%%%%Include functions%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%...............

% Guess solution subroutine. x is a single value, not a point
function yinit = intcond(x)

global AL AR CL CR xa xb BCstr
 % y = [A C dA/dx dC/dx]
if strcmp(BCstr,'Dir')
    yinit = [(AR - AL) ./ (xb - xa) .* (x-xa) + AL,...
        (CR - CL) ./ (xb - xa) .* (x-xa) + CL,...
        (AR - AL) ./ (xb - xa),...
        (CR - CL) ./ (xb - xa)];
elseif strcmp(BCstr,'Vn')
    yinit = [AL, 0, 0, 0];
elseif strcmp(BCstr,'DirVn')
    yinit = [(AR - AL) ./ (xb - xa) .* (x-xa) + AL, ...
        0, ...
        (AR - AL) ./ (xb - xa),...
         0];
else
    fprintf('No Boundary Value selected\n')
end

% ODE subroutine
function dydx = odeCoupledDiffChemLin(x,y)
%Parameters you can edit
global nu Bt Kon Koff
% y = [A C dA/dx dC/dx]
%form y' = f(x,y)
dydx = ...
    [ y(3); y(4);
    Kon .*( Bt ) .* y(1) - Koff* y(2);...
    -1/nu .* ( Kon .*( Bt ) .* y(1) - Koff * y(2) ) ];

% ODE subroutine
function dydx = odeCoupledDiffChemNL(x,y)
%Parameters you can edit
global nu Bt Kon Koff
% y = [A C dA/dx dC/dx]
%form y' = f(x,y)
dydx = ...
    [ y(3); y(4);
    Kon .*( Bt  - y(2) ) .* y(1) - Koff* y(2);...
    -1/nu .* ( Kon .*( Bt - y(2) ) .* y(1) - Koff * y(2) ) ];

%..

% Boundary condition subroutine
function res = resbcfunc(ya,yb)
global AL AR CL CR BCstr
% y = [A C dA/dx dC/dx]
if strcmp(BCstr,'Dir') % Both Dirichlet
    res = [ ya(1) - AL; ya(2)-CL; yb(1)-AR;yb(2)-CR];
elseif strcmp(BCstr,'Vn') %Both Von Neumann
    res = [ ya(3); ya(4); yb(3); yb(4)];
elseif strcmp(BCstr,'DirVn')% A Dirichlet C Vn
    res = [ ya(1) - AL; ya(4); yb(1)-AR; yb(4)];
else
    fprintf('No Boundary Value selected\n')
end
