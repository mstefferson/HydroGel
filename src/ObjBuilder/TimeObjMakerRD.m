% Builds the time structure
function [TimeObj] = TimeObjMakerRD(dt,t_tot,t_rec,ss_epsilon,NumPlots)

% Fix time Recording stuff
[t_tot,N_time,t_rec,N_rec,N_count] = TimeStepRecMaker(dt,t_tot,t_rec);
% Make TIme obj
TimeObj = struct('dt',dt,'t_tot',t_tot,'t_rec',t_rec,...
    'N_time',N_time,'N_rec',N_rec,'N_count',N_count,...
    'ss_epsilon',ss_epsilon,'NumPlots',NumPlots);

end
