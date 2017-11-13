% Id Key
%
% 1: initParamsJvsT
% 2: initParamsSvsKd (course and fine)
% 3: initParamsDenProfile 
% 4: initParamsSvsNu (course and fine)
%

function paperPlotMaker( plotId, saveFlag, saveTag )
if nargin == 1
  saveFlag = 0;
elseif nargin == 2
  saveTag = '';
end
% paper data path
paperDataPath = 'paperData/';
if saveFlag == 1
  paperSavePath = 'paperFigs/';
  saveID = 'png';
  if ~exist( paperSavePath, 'dir'  )
    mkdir( paperSavePath )
  end
end

% figure 1: selectivity vs time nu = 0
if any( plotId == 1 )
  currId = 1;
  data2load = [paperDataPath 'figJvsT_data.mat'];
  if exist( data2load, 'file'  )
    load( data2load ) 
    makefigJvsT(fluxSummary ); 
  else
    fprintf('No data to run for fig 1. Run paperResultsMaker\n');
  end
  % save it
  if saveFlag
    saveName = ['paperfig' num2str(currId ) '_' saveTag];
    savefig( gcf, saveName )
    saveas( gcf, saveName, saveID )
    movefile( [saveName '*'], paperSavePath )
  end
end

% figure 2: selectivity vs kd
if any( plotId == 2 )
  currId = 2;
  data2load = [paperDataPath 'figSvsKd_data.mat'];
  if exist( data2load, 'file'  )
    load( data2load ) 
    load( [paperDataPath 'figSvsKd_data_linear.mat']) 
    makefigSvsKd( fluxSummary, fluxLin ); 
  else
    fprintf('No data to run for fig 2. Run paperResultsMaker\n');
  end
  % save it
  if saveFlag
    saveName = ['paperfig' num2str(currId ) '_' saveTag];
    savefig( gcf, saveName )
    saveas( gcf, saveName, saveID )
    movefile( [saveName '*'], paperSavePath )
  end
end

% figure 4: combine figure 3 and 6
if any( plotId == 4 )
  currId = 4;
  data2load3 = [paperDataPath 'figDenProfile_data.mat'];
  data2load6 = [paperDataPath 'figSvsNu_data.mat'];
  if exist( data2load3, 'file'  ) && exist( data2load6, 'file' )
    load( data2load3 )
    fluxSummary3 = fluxSummary;
    load( data2load6 )
    fluxSummary6 = fluxSummary;
    makefigDenProfileSvsNu( fluxSummary3, fluxSummary6 ); 
  else
    fprintf('No data to run for fig 6. Run paperResultsMaker\n');
  end
  % save it
  if saveFlag
    saveName = ['paperfig' num2str(currId ) '_' saveTag];
    savefig( gcf, saveName )
    saveas( gcf, saveName, saveID )
    movefile( [saveName '*'], paperSavePath )
  end
end

% temp figure 6:
if any( plotId == 6 )
  currId = 4;
  data2load6 = [paperDataPath 'figSvsNu_data.mat'];
  if exist( data2load6, 'file' )
    load( data2load6 )
    makefigSvsNu( fluxSummary ); 
  else
    fprintf('No data to run for fig 6. Run paperResultsMaker\n');
  end
  % save it
  if saveFlag
    saveName = ['paperfig' num2str(currId ) '_' saveTag];
    savefig( gcf, saveName )
    saveas( gcf, saveName, saveID )
    movefile( [saveName '*'], paperSavePath )
  end
end

