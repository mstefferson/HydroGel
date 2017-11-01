% paper data path
paperDataPath = 'paperData/';
% figure 1
data2load = [paperDataPath 'fig1_data.mat'];
if exist( data2load, 'file'  )
  load( data2load ) 
  makefig1( fluxSummary ); 
else
  fprintf('No data to run for fig 1. Run paperResultsMaker\n');
end
% figure 2
data2load = [paperDataPath 'fig2_data.mat'];
if exist( data2load, 'file'  )
  load( data2load ) 
  makefig2( fluxSummary ); 
else
  fprintf('No data to run for fig 2. Run paperResultsMaker\n');
end
