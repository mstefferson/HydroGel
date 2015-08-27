function [x,x_trim,dx] = Gridmaker1DDir(Lbox,N)
% Spatial grid Dir
dx     = Lbox/(N+1);
x      = 0:dx:Lbox;    % j = 0, 1, 2,...N, N+1
% You don't include end points (they are zero).
x_trim = x(2:end-1); % j = 1,2,N  N gridpoints for sinFT;

end