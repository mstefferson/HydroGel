%% 

clear
linear = 0;
PlotMe = 0;
trial_start = 130;
N_trial     = 5;

% Enter Stuff here
LoopVarStr = sprintf('Nall');
ParamLoop = [16 32 64 128 256];
FileStrRoot = sprintf('ConsNLNdFDext_t');

% Initialize
ParNumMat = zeros( N_trial,4);
trial = trial_start;

broken = 0;
for i = 1:N_trial
    FileStr = sprintf('%s%d.mat',FileStrRoot,trial);
        load(FileStr)
[IntPartTemp,FinPartTemp,MinPartTemp,MaxPartTemp] =  ...
    ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,PlotMe);


    ParNumMat(i,1) = IntPartTemp;
    ParNumMat(i,2) = FinPartTemp;
    ParNumMat(i,3) = MinPartTemp;
    ParNumMat(i,4) = MaxPartTemp;

    trial = trial + 1;
end

plot(ParamLoop,ParNumMat)
legend('Int','Fin','Min','Max')
xlabel(LoopVarStr); ylabel('Particle Number')