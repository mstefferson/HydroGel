% Function returns parameters used for recording something a distinct time
% intervals and aligns a final run time and recording time
% to fit with a given time step

% Inputs:
% dt: time step size
% t_tot: total run time
% t_rec: record after this much time

% Outputs:
% Nt: Number of time points. Includes zero
% N_rec: Number of recorded time points, including zero
% N_count: Number of time steps to count before recording. 

% Guide: t == timestep
% time    = t*dt
% t_tot   = Nt * dt
% t_rec   = N_count * dt  

function [t_tot,Nt,t_rec,N_rec,N_count] = TimeStepRecMaker(dt,t_tot,t_rec)

% Fix the recording time to be divisible by the time step
  t_rec = round(t_rec/dt)*dt;
  
  if t_rec < dt
      t_rec = dt;
  end


% Fix the total run time to be divisible by time step 
  t_tot = round(t_tot/t_rec)*t_rec;

  if t_tot < t_rec
      t_tot = t_rec;
  end

% Calculate the outputs
Nt = round(t_tot/dt);           % Number of time steps
N_rec = round(t_tot/t_rec) + 1; % Number of recorded points. +1 includes 0
N_count = t_rec/dt;      % Number of time steps before recording

end
