function [x,dx] = Gridmaker1DVn(Lbox,N)
% Spatial grid Vn
dx     = Lbox/(N-1);
x      = 0:dx:Lbox;    % j = 0, 1, 2,...N, N+1
end