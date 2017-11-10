% Id Key
%
% 1: initParamsJvsT
% 2: initParamsSvsKd (course and fine)
% 3: initParamsDenProfile 
% 4: initParamsSvsNu (course and fine)
%

function paperResultsMaker( resultsId )

dataPath = 'paperData';
if ~exist( dataPath,'dir' ) 
  mkdir( dataPath )
end
% figure 1: selectivity vs time
if any( resultsId == 1 )
  fluxSummary = fluxPDE(0,0,0,0,0,0,'blah','initParamsJvsT');
  saveName = 'figJvsT_data';
  saveExt = '.mat';
  savepath = [ dataPath '/' saveName saveExt];
  if exist( savepath, 'file' )
    fprintf('file exists. renaming file\n');
    saveName = [ saveName datestr(now,'yyyymmdd_HH.MM') ];
  end
  fullName = [saveName saveExt];
  save( fullName, 'fluxSummary' )
  movefile( fullName, dataPath );
end
% figure 2: selectivity vs kd
if any( resultsId == 2 )
  fluxSummary = fluxODE(0,0,0,'blah','initParamsSvsKd');
  saveName = 'figSvsKd_data';
  saveExt = '.mat';
  savepath = [ dataPath '/' saveName saveExt];
  if exist( savepath, 'file' )
    fprintf('file exists. renaming file\n');
    saveName = [ saveName datestr(now,'yyyymmdd_HH.MM') ];
  end
  fullName = [saveName saveExt];
  save( fullName, 'fluxSummary' )
  movefile( fullName, dataPath );
end
% figure 3: density profiles
if any( resultsId == 3 )
  fluxSummary = fluxODE(0,0,0,'blah','initParamsDenProfile');
  saveName = 'figDenProfile_data';
  saveExt = '.mat';
  savepath = [ dataPath '/' saveName saveExt];
  if exist( savepath, 'file' )
    fprintf('file exists. renaming file\n');
    saveName = [ saveName datestr(now,'yyyymmdd_HH.MM') ];
  end
  fullName = [saveName saveExt];
  save( fullName, 'fluxSummary' )
  movefile( fullName, dataPath );
end


% figure 4: boundary koff, non-linear
if any( resultsId == 4 )
  fluxSummary = fluxODE(0,0,0,'blah','initParamsSvsNu');
  saveName = 'figSvsNu_data';
  saveExt = '.mat';
  savepath = [ dataPath '/' saveName saveExt];
  if exist( savepath, 'file' )
    fprintf('file exists. renaming file\n');
    saveName = [ saveName datestr(now,'yyyymmdd_HH.MM') ];
  end
  fullName = [saveName saveExt];
  save( fullName, 'fluxSummary' )
  movefile( fullName, dataPath );
end

end

