% Description: Makes the L.H.S. and R.H.S. matrix for CN time stepping
%
% LMcn * v_{n+1} = RMcn * v_{n}
% LMcn = (1-dt/2 *Lop); % RMcn = (1+dt/2 *Lop)

function [LMcn,RMcn] = MatMakerCN(Lop,dt,N)

LMcn = speye(N) - dt / 2 .* Lop;
RMcn = speye(N) + dt / 2 .* Lop;

end