% paper data path
paperDataPath = 'paperData/';
% figure 1: selectivity vs time
data2load = [paperDataPath 'fig1_data.mat'];
if exist( data2load, 'file'  )
  load( data2load ) 
  makefig1( fluxSummary ); 
else
  fprintf('No data to run for fig 1. Run paperResultsMaker\n');
end
% figure 2: selectivity vs kd
data2load = [paperDataPath 'fig2_data.mat'];
if exist( data2load, 'file'  )
  load( data2load ) 
  makefig2( fluxSummary ); 
else
  fprintf('No data to run for fig 2. Run paperResultsMaker\n');
end
% figure 3: density profiles
data2load = [paperDataPath 'fig3_data.mat'];
if exist( data2load, 'file'  )
  load( data2load ) 
  makefig3( fluxSummary ); 
else
  fprintf('No data to run for fig 3. Run paperResultsMaker\n');
end
% figure 3: density profiles
data2load = [paperDataPath 'fig4_data.mat'];
if exist( data2load, 'file'  )
  load( data2load ) 
  makefig4( fluxSummary ); 
else
  fprintf('No data to run for fig 4. Run paperResultsMaker\n');
end
