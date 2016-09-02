%%
% cd(OutputDir)
close all
SavePlot = 0;
Nfiles = 6;
t_start =61;
ExamplePlot = 0;

FileName = sprintf('ConsNLNdFDres_t%d.mat',t_start);
load(FileName)
FitIndStrt = 1;
FitIndEnd = floor(N_rec/2);


AccumFitMat = zeros(Nfiles,3);
SlopeMat    = zeros(Nfiles,2);
AllParamMat = zeros(Nfiles,6);
LboxLoop    = zeros(Nfiles,1);
NxVec       = zeros(Nfiles,1);
dxVec       = zeros(Nfiles,1);
dtVec       = zeros(Nfiles,1);
trialVec    = zeros(Nfiles,1);
AccumVsTime = zeros(Nfiles,3);
AvsTMat    = zeros(Nfiles, length(FitIndStrt:FitIndEnd) );
AvsTfitMat = zeros(Nfiles, length(FitIndStrt:FitIndEnd) );
TimeRecMat    = zeros(Nfiles, length(FitIndStrt:FitIndEnd) );


% FitIndStrt = floor( N_rec *0.2);
% FitIndEnd = floor( end);


trial   = t_start;
for i = 1:Nfiles;
        disp(trial)
% load
    FileName = sprintf('ConsNLNdFDres_t%d.mat',trial);
    load(FileName)
    % Store everything
    NxVec(i)       = Nx;
    dxVec(i)       = x(2)-x(1);
    trialVec(i)    = trial;
    AllParamMat(i,:) = AllParamVec;
    LboxLoop(i)      = Lbox;
    TimeRecFit       = TimeRec(FitIndStrt:FitIndEnd);
    TimeRecMat(i,:)  = TimeRecFit;
%Fitting stuff
    y = A_rec(end,:) / A(1,1);
    
    [dy,xtrim] = d1dxCalcBtwnPnts(x,y);
    [d2y,xtrim2] = d2dxCalcOnPnts(x,y);
    
    p = polyfit( TimeRec(FitIndStrt:FitIndEnd),y(FitIndStrt:FitIndEnd),1 );
    
    AccumOn    = -p(2) / p(1);
    AccumRate = p(1);
    AccumMax  = y(FitIndEnd);
    
    % Store these bad boys
    AccumFitMat(i,1) = AccumOn;
    AccumFitMat(i,2) = AccumRate;
    AccumFitMat(i,3) = AccumMax;
    
    SlopeMat(i,1)    = max(dy);
    SlopeMat(i,2)    = max(d2y);
    
    AvsTMat(i,:)    = y(FitIndStrt:FitIndEnd);
    AvsTfitMat(i,:) = p(1) .* TimeRec(FitIndStrt:FitIndEnd) + p(2);
    if 0
    figure()
    
    subplot(3,1,1)
    plot(TimeRecFit,y(FitIndStrt:FitIndEnd),...
        TimeRecFit,p(1) .* TimeRec(FitIndStrt:FitIndEnd) + p(2));
    subplot(3,1,2)
    plot(TimeRecFit,y(FitIndStrt:FitIndEnd)  - (p(1) .* TimeRec(FitIndStrt:FitIndEnd) + p(2)) );
    subplot(3,1,3)
    plot(TimeRec,y,TimeRec,p(1) .* TimeRec + p(2));
    TextStr = sprintf(' Accum On = %.2e\n AccumRate = %.2e\n AccumMax = %.e',...
        AccumOn, AccumRate,AccumMax);
    textbp(TextStr)
    titstr = sprintf('trial = %d Lbox =%.0f', trial, Lbox); 
    title(titstr)
%     keyboard
    end
    trial =  trial + 1;

end

%Parameter strings
ParamStr1 = sprintf(...
    ' Kon = %.1e \n Koff = %.1e \n nu = %.1e \n beta = %.1e ',...
         AllParamVec(1:4));
ParamStr2 = sprintf(' AL = %.1e \n Bt = %.1e ',AllParamVec(5:6) );

% Check parameters
if repmat( AllParamVec,[Nfiles,1] ) == AllParamMat
    fprintf('All good!\n')
else
    fprintf('Caution! Parameters are not the same!\n')
end

if AllParamVec(1) == 0 % Diffusion
    AccumFitMatDiff    = AccumFitMat;
    SlopeMatDiff    = SlopeMat;
    AllParamMatDiff = AllParamMat;
    AvsTMatDiff         = AvsTMat;
    AvsTfitMatDiff     = AvsTfitMat;
    ParamStrDiff = sprintf(' Diff\n Kon = %.1e\n Koff = %.1e', ...
        AllParamVec(1:2));
    trialVecDiff = trialVec;
    fprintf('Saved Diffusion\n')
elseif AllParamVec(4) == 0 % nu = 0
    AccumFitMatnu0 = AccumFitMat;
    SlopeMatnu0 = SlopeMat;
    AllParamMatnu0 = AllParamMat;
    AvsTMatnu0         = AvsTMat;
    AvsTfitMatnu0     = AvsTfitMat;
    ParamStrnu0 = sprintf(' nu0\n Kon = %.1e\n Koff = %.1e ',...
        AllParamVec(1:2));
     trialVecnu0 = trialVec;
     fprintf('Saved nu0\n')
elseif AllParamVec(4) == 1 % nu = 1
    AccumFitMatnu1 = AccumFitMat;
    SlopeMatnu1 = SlopeMat;
    AllParamnu1 = AllParamMat;
    AvsTMatnu1 = AvsTMat;
    AvsTfitMatnu1     = AvsTfitMat;
    ParamStrnu1 = sprintf(' nu1\n Kon = %.1e\n Koff = %.1e ',...
        AllParamVec(1:2));
     trialVecnu1 = trialVec;
     fprintf('Saved nu1\n')
else
    fprintf('No match?\n')
end


