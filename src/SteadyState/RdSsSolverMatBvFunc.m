% homodiffsolver. Rescaled by diffusive time
function [Ass,Css,x] = RdSsSolverMatBvFunc(...
  konVal, koffCell, nuCell, ALval,ARval,Btval,Lboxval,BCstrVal,Nx, ...
  nlEqn)
global AL AR CL CR Bt Kon Koff Ka xa xb BCstr nlfac nuStr nuPval

% set BC
BCstr = BCstrVal; % 'Dir','Vn','DirVn'

%Parameter you can edit
debugFlag = 0;
nuStr = nuCell{1};
nuPval = nuCell{2};
Kon = konVal;
Koff  = koffCell{2};
AL  = ALval;
AR  = ARval ;
Bt  = Btval;
Ka  = Kon ./ Koff;

%Spatial endpoints and grid
xa = 0;
xb = Lboxval;
x = linspace(xa,xb,Nx);

% Make factor for linear equation
if nlEqn
  nlfac = 1;
else
  nlfac = 0;
end

if debugFlag
  % print what you are running
  if strcmp( nuStr, 'lplc' ) || strcmp( nuStr, 'nu' )
    fprintf('Running %s with val %g\n', nuStr,nuPval);
  else
    fprintf('Cannot find nu type\n');
    error('Cannot find nu type\n');
  end
end

% Calculated parameters/linear solutions
% CL and CR are the values based on chemical equilibrium
CL  = Ka .* (AL * Bt) ./ (1 + Ka .* AL);
CR  = Ka .* (AR * Bt) ./ (1 + Ka .* AR);

% if nu = 0, A must be linear
if nuPval == 0
  Alin  = (AR - AL) ./ xb .* x + AL;
  Ass = Alin;
  Css = Ka .* (Ass .* Bt) ./ (1 + Ka .* Ass);
else %solve the coupled ODE
  % y = [A C dA/dx dC/dx]
  % Build input for solver
  solinit = bvpinit(x,@intcond);
  
  % Solve it
  options = [];
  if strcmp( koffCell{1}, 'const' )
    sol = bvp4c(@odeCoupledDiffChem,@resbcfunc,solinit,options);
  elseif strcmp( koffCell{1}, 'outletboundary' )
    sol = bvp4c(@odeCoupledDiffChemOutletBoundary,@resbcfunc,solinit,options,...
      koffCell{3} );
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

% Boundary condition subroutine
function res = resbcfunc(ya,yb,~)
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

% ODE subroutine
function dydx = odeCoupledDiffChem(~, y)
global Kon Koff Bt nuStr nuPval nlfac
% get diffusion coeff
if strcmp( nuStr, 'lplc' )
  Dc =  boundTetherDiffCalc( nuPval, Koff, 1);
  nu = Dc;
elseif strcmp( nuStr, 'nu' )
  nu = nuPval;
end
% y = [A C dA/dx dC/dx]
%form y' = f(x,y)
% solve for derivative
dydx = ...
  [ y(3) ; y(4) ;
  Kon .* ( Bt  - nlfac .* y(2) ) .* y(1) - Koff .* y(2);...
  -1./nu .* ( Kon .* ( Bt - nlfac .* y(2) ) .* y(1) - Koff .* y(2) ) ];

function dydx = odeCoupledDiffChemOutletBoundary(x, y, koffMult)
global Kon Koff Bt nuStr nuPval nlfac xb
% y = [A C dA/dx dC/dx]
%form y' = f(x,y)
% get koff value. factor of two since h(0) = 1/2
koffTemp = Koff .* ( 1 + 2  * koffMult * heaviside( x - xb) );
% get diffusion coeff
if strcmp( nuStr, 'lplc' )
  Dc =  boundTetherDiffCalc( nuPval, koffTemp, 1);
  nu = Dc;
elseif strcmp( nuStr, 'nu' )
  nu = nuPval;
end
% solve for derivative
dydx = ...
  [ y(3) ; y(4) ;
  Kon * ( Bt  - nlfac .* y(2) ) * y(1) - koffTemp * y(2);...
  -1./nu * ( Kon * ( Bt - nlfac .* y(2) ) * y(1) - koffTemp * y(2) ) ];
