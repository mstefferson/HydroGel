function [x,dx] = Gridmaker1DPBC(Lbox,N)
% Spatial grid Vn
dx     = Lbox/N;
x      = -Lbox/2:dx:Lbox/2-dx;    % j = 0, 1, 2,...N, N+1
end