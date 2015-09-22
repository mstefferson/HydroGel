clear
% clc

CurrentDir = pwd;
addpath( genpath( CurrentDir) );

SaveMe = 0;
PlotMe = 1;
BCstr = 'DirVn'; % 'Dir','Vn','DirVn'

trial  = 1;
%Parameter you can edit

% KDinv = 1e4 ;
Koff  = 1e2;
Kon  = 1e8;
nu  = 10;
AL  = 2e-4;
AR  = 0;
Bt  = 2e-1;
NxPDE  = 128;
NxODE  = (NxPDE-1) .* 10 + 1;
Lbox = 1;
Paramstr = sprintf('Kon=%.1e\nKoff=%.1e\nnu=%.2e\n',...
    Kon,Koff,nu);
Concstr = sprintf('Bt=%.1e\nAL=%.1e\nAR=%.2e',...
    Bt,AL,AR);
Gridstr = sprintf('NxODE = %d\nNxPDE = %d',...
    NxODE,NxPDE);
%% Objects
% Put Parameters in a structure
ParamObj   = struct('trial',trial,'SaveMe',SaveMe,...
    'NxODE',NxODE,'NxPDE',NxPDE,'Lbox',Lbox,...
    'BCstr',BCstr,...
    'Kon', Kon, 'Koff', Koff,'KDinv',Kon/Koff,...
    'nu',nu,'Bt',Bt,'AL',AL,'AR',AR);
if SaveMe
    diary('RunDiary.txt')
    disp(ParamObj)
end

%%%%%%%% MATLAB'S ODE SOLVER%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
linear
% non-linear
linearEqn = 0;
[AnlOde,CnlOde,xOde] = RdSsSolverMatBvFunc(...
    Kon,Koff,nu,AL,AR,Bt,Lbox,BCstr,NxODE,linearEqn);
fprintf('MATLAB method done\n');

Alin = (AR - AL) ./ Lbox .* xOde + AL;

plot(xOde,AnlOde,xOde,Alin)

legend('A nl','A diff','Location','best')

disp('Diff flux')
(Alin(end-1) - Alin(end) ) ./ ( xOde(end) - xOde(end-1) )
disp('NL')
(AnlOde(end-1) - AnlOde(end) )./ ( xOde(end) - xOde(end-1) )