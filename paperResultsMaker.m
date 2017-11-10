function paperResultsMaker( resultsId )

dataPath = 'paperData';
if ~exist( dataPath,'dir' ) 
  mkdir( dataPath )
end
% figure 1: selectivity vs time
if any( resultsId == 1 )
  fluxSummary = fluxPDE(0,0,0,0,0,0,'blah','initParamsFig1');
  saveName = 'fig1_data';
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
% figure 11: selectivity vs time, nu = 1
if any( resultsId == 11 )
  fluxSummary = fluxPDE(0,0,0,0,0,0,'blah','initParamsFig1nu1');
  saveName = 'fig1_nu1_data';
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
  fluxSummary = fluxODE(0,0,0,'blah','initParamsFig2');
  saveName = 'fig2_data';
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
  fluxSummary = fluxODE(0,0,0,'blah','initParamsFig3');
  saveName = 'fig3_data';
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
  fluxSummary = fluxPDE(0,0,0,0,0,0,'blah','initParamsFig4');
  saveName = 'fig4_data';
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

% figure 6: boundary koff, non-linear
if any( resultsId == 6 )
  fluxSummary = fluxODE(0,0,0,'blah','initParamsFig6');
  saveName = 'fig6_data';
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

% figure 7: test stability
if any( resultsId == 7 )
  fluxSummary = fluxODE(0,0,0,'blah','initParamsStabilityTest');
  % save with N
  initParamsStabilityTest
  saveName1 = [ 'figStabilityTest_data' ];
  saveName2 = [ 'figStabilityTest_data_N' num2str(Nx,'%d') ];
  saveExt = '.mat';
  savepath1 = [ dataPath '/' saveName1 saveExt];
  if exist( savepath1, 'file' )
    fprintf('file exists. renaming file\n');
    saveName1 = [ saveName1 datestr(now,'yyyymmdd_HH.MM') ];
  end
  savepath2 = [ dataPath '/' saveName2 saveExt];
  if exist( savepath2, 'file' )
    fprintf('file exists. renaming file\n');
    saveName2 = [ saveName2 datestr(now,'yyyymmdd_HH.MM') ];
  end
  fullName1 = [saveName1 saveExt];
  fullName2 = [saveName2 saveExt];
  save( fullName1, 'fluxSummary' )
  save( fullName2, 'fluxSummary' )
  movefile( fullName1, dataPath );
  movefile( fullName2, dataPath );
end

end

