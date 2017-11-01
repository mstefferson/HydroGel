function paperResultsMaker( resultsId )

dataPath = 'paperData';
if ~exist( dataPath,'dir' ) 
  mkdir( dataPath )
end

% figure 1
if any( resultsId == 1 )
  fluxSummary = fluxPDE(0,0,0,0,0,0,'blah','initParamsFig1');
  saveName = 'fig1_data';
  saveExt = '.mat';
  savepath = [ dataPath '/' saveName saveExt];
  if exist( savepath, 'file' )
    saveName = [ saveName datestr(now,'yyyymmdd_HH.MM') ];
  end
  save( [saveName], 'fluxSummary' )
  movefile( [saveName saveExt], dataPath );
end
% figure 2
if any( resultsId == 2 )
  fluxSummary = fluxODE(0,0,0,'blah','initParamsFig2');
  saveName = 'fig2_data';
  saveExt = '.mat';
  savepath = [ dataPath '/' saveName saveExt];
  if exist( savepath, 'file' )
    saveName = [ saveName datestr(now,'yyyymmdd_HH.MM') ];
  end
  save( [saveName], 'fluxSummary' )
  movefile( [saveName saveExt], dataPath );
end

end

