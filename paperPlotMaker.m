function paperPlotMaker( plotId )
% paper data path
paperDataPath = 'paperData/';
% figure 1: selectivity vs time
if any( plotId == 1 )
  data2load = [paperDataPath 'fig1_data.mat'];
  if exist( data2load, 'file'  )
    load( data2load ) 
    makefig1( fluxSummary ); 
  else
    fprintf('No data to run for fig 1. Run paperResultsMaker\n');
  end
end
% figure 2: selectivity vs kd
if any( plotId == 2 )
  data2load = [paperDataPath 'fig2_data.mat'];
  if exist( data2load, 'file'  )
    load( data2load ) 
    makefig2( fluxSummary ); 
  else
    fprintf('No data to run for fig 2. Run paperResultsMaker\n');
  end
end
% figure 3: density profiles
if any( plotId == 3 )
  data2load = [paperDataPath 'fig3_data.mat'];
  if exist( data2load, 'file'  )
    load( data2load ) 
    makefig3( fluxSummary ); 
  else
    fprintf('No data to run for fig 3. Run paperResultsMaker\n');
  end
end
% figure 4: koff mult
if any( plotId == 4 )
  data2load = [paperDataPath 'fig4_data.mat'];
  if exist( data2load, 'file'  )
    load( data2load ) 
    makefig4( fluxSummary ); 
  else
    fprintf('No data to run for fig 4. Run paperResultsMaker\n');
  end
end
% figure 6: selectivity vs nu
if any( plotId == 6 )
  data2load = [paperDataPath 'fig6_data.mat'];
  if exist( data2load, 'file'  )
    load( data2load ) 
    makefig6( fluxSummary ); 
  else
    fprintf('No data to run for fig 6. Run paperResultsMaker\n');
  end
end
