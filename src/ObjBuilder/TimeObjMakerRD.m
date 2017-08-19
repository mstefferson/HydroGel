% Builds the time structure
function [timeObj] = TimeObjMakerRD(dt,t_tot,t_rec,ss_epsilon,NumPlots)

% Fix time Recording stuff
[t_tot,N_time,t_rec,N_rec,N_count] = TimeStepRecMaker(dt,t_tot,t_rec);
% Make TIme obj
timeObj.dt = dt; 
timeObj.t_tot = t_tot; 
timeObj.t_rec = t_rec; 
timeObj.N_time = N_time;
timeObj.N_rec =  N_rec;
timeObj.N_count = N_count;
timeObj.ss_epsilon = ss_epsilon;
timeObj.ss_epsilon_dt = ss_epsilon * dt;
timeObj.NumPlots = NumPlots;

end
