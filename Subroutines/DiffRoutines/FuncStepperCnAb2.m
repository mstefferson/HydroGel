% Function: FuncStepperCnAb2.m
% Description: Crank-Nicolson for the diffusion, AB stepping for the NL

% ODE: 
% dv/dt = Lop v + NL
% v_{n+1} = v_{n} + ...
%     (1 - dt / 2* Lop) ^(-1) * ( (1 - dt / 2* Lop) * v_{n} + ...
%                                  dt/2 * ( 3 * NL_{n} - NL_{n-1} ) )
% or
% v_{n+1} = v_{n} + ...
%     ML^(-1) * ( MR * v_{n} + dt/2 * ( 3 * NL_{n} - NL_{n-1} ) )
%
% Outputs: 
% vNext: the function at the next time step
% Inputs: 
% v: current function
% Mr: Matrix Mr = (1 + dt/2 * Lop)
% Mlinv: Matrix Mlinv = (1 - dt/2 * Lop)^(-1)
% NL: Nonlinear contribution at the current step
% NLprev: Nonlinear contribution at the previous step
% dt: timestep


function [vNext] = FuncStepperCnAb2(v,Mr,Ml,NL,NLprev,dt)

vNext = Ml \ ( Mr * v + dt / 2 .* ( 3 * NL - NLprev ) );

end
