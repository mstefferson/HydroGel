%function quickPlotFig2()
paramObj = jOut.paramObj;
jMax = jOut.jNorm;
nuVec = paramObj.nu;
kDVec = 1 ./ paramObj.kinVar2;

[ numNu, numKoff, numKa ] = size( jMax );

jSelect = zeros( numNu, numKa );
legcell = cell( 1, numKa );

for ii = 1:numNu
  for jj = 1:numKa
    legcell{jj} = [  ' $$ K_D \, (M) = $$' num2str( kDVec(jj) ) ];
    jSelect(ii,jj) = jMax(ii, 1, jj );
  end
end

figure()
hold
for ii = 1:numKa
  plot( nuVec, jSelect(:,ii) )
end
ax = gca;
ax.YLim = [0 50];
xlabel('$$ \nu $$')
ylabel('Selectivity ($$ j / j_{Diff} $$)')
h = legend( legcell, 'location','best');
h.Interpreter = 'latex';