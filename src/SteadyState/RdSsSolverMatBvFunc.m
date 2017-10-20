% homodiffsolver. Rescaled by diffusive time
function [Ass,Css,x] = RdSsSolverMatBvFunc(...
  KonVal,KoffVal,nuVal,ALval,ARval,Btval,Lboxval,BCstrVal,Nx,linearEqn)

global nu AL AR CL CR Bt Kon Koff Ka xa xb BCstr X counter

% Make sure linear eqn is zero or one
if linearEqn ~= 0 && linearEqn ~= 1
  error('Need to set linear eqn parameter to 0 or 1')
end
BCstr = BCstrVal; % 'Dir','Vn','DirVn'

%Parameter you can edit
Kon = KonVal;
Koff  = KoffVal;
nu  = nuVal;
AL  = ALval;
AR  = ARval ;
Bt  = Btval;

% turn everything to a row vector
if length(Kon) == 1
  Kon = Kon .* ones( 1, Nx );
end
if length(Koff) == 1
  Koff = Koff .* ones( 1, Nx );
end
if length(Bt) == 1
  Bt = Bt .* ones( 1, Nx );
end
if length(nu) == 1
  nu = nu .* ones( 1, Nx );
end

%Spatial endpoints and grid
xa = 0;
xb = Lboxval;
x = linspace(xa,xb,Nx);
X = x;

% Calculate other stuff
Ka  = Kon ./ Koff;

% Calculated parameters/linear solutions
% CL and CR are the values based on chemical equilibrium
CL  = Ka .* (AL * Bt) ./ (1 + Ka .* AL);
CR  = Ka .* (AR * Bt) ./ (1 + Ka .* AR);

% if nu = 0, A must be linear
if nu == 0
  Alin  = (AR - AL) ./ xb .* x + AL;
  Ass = Alin;
  Css = Ka .* (Ass .* Bt) ./ (1 + Ka .* Ass);
else %solve the coupled ODE
  % y = [A C dA/dx dC/dx]
  % Build input for solver
  solinit = bvpinit(x,@intcond);
  
  % Solve it
  counter = 0;
  if linearEqn == 1
    sol = bvp4c(@odeCoupledDiffChemLin,@resbcfunc,solinit);
  else
    options = [];
    debug = 0;
    %       sol = bvp4c(@odeCoupledDiffChemNL,@resbcfunc,solinit, options, debug);
    sol = bvp4c(@odeCoupledDiffChemNL,@resbcfunc,solinit);
  end
  
  % Now  get numerical value
  y = deval(sol,x);
  Ass = y(1,:);
  Css = y(2,:);
end


%%%%%%%%%%%%%%%Include functions%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
% Grab indice
ind = find( X == x);
% solve for derivative
dydx = ...
  [ y(3) ; y(4) ;
  Kon(ind) .*  Bt(ind)  .* y(1) - Koff(ind) .* y(2);...
  -1./nu(ind) .* ( Kon(ind) .*  Bt(ind) .* y(1) - Koff(ind) .* y(2) ) ];

% ODE subroutine
function dydx = odeCoupledDiffChemNL(x,y)
global X Kon Koff Bt nu counter
debug = 1;

% y = [A C dA/dx dC/dx]
%form y' = f(x,y)
% Grab indice
ind = find( X == x);

if isempty(ind)
  keyboard
end
% solve for derivative
dydx = ...
  [ y(3) ; y(4) ;
  Kon(ind) .* ( Bt(ind)  - y(2) ) .* y(1) - Koff(ind) .* y(2);...
  -1./nu(ind) .* ( Kon(ind) .* ( Bt(ind) - y(2) ) .* y(1) - Koff(ind) .* y(2) ) ];
counter = counter + 1;
if debug
  ind
  dydx
%   keyboard;
end

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
