function makefig3( fluxSummary3, fluxSummary6 )
% scale and params
xScale = 100;
x = linspace(0,1,fluxSummary3.paramObj.Nx );
x = xScale * x;
% Some tunable parameters
fontSize = 14;
% set params
% row1: nu = 0 unsaturated
% row2: nu = 1 unsaturated
% row3: nu = 1 saturated
subplotInds = [1 1 1; 2 1 1; 2 1 2];
% % set-up figure
% figId = 3;
figId = randi(1000);
fig = figure(figId);
clf(figId);
fig.WindowStyle = 'normal';
axis square
% plot it fig 3
fluxSummary = fluxSummary3;
subplotMeFig3(subplotInds, x, fluxSummary.aConcStdy, fluxSummary.cConcStdy,...
  fluxSummary.paramObj.AL, fluxSummary.paramObj.Btc, fontSize);
% fake plots
subplot(3,2,2); plot(1:10);
subplot(3,2,4); plot(1:10);
subplot(3,2,6); plot(1:10);
% stack it
pause(1)
stackPlots( fig, 2 )
% plot it fig 6
subplotMeFig6(fluxSummary6, fontSize);
% stack it
% pause(1)
% stackPlots( fig, 2 )


% A and C in the same plot using plot
function subplotMeFig3( ...
  subplotinds, x, aStdy, cStdy, aScale, cScale, fontSize )
row = 3;
col = 2;
row1data = cStdy;
row2data = aStdy;
for id = 1:3
  % top row complex
  axTemp = subplot(row,col, 1+(id-1)*col);
  dataC = row1data{ ...
    subplotinds(id,1), subplotinds(id,2), subplotinds(id,3) };
  dataC = dataC ./ cScale;
  dataA = row2data{ ...
    subplotinds(id,1), subplotinds(id,2), subplotinds(id,3) };
  dataA = dataA ./ aScale;
  plot( axTemp, x, dataA, x, dataC );
  axTemp.YLim = [0 1];
  axTemp.YTick = 0:0.2:1;
  ylabel(axTemp, 'Density Profile')
  xlabel(axTemp, 'Position $$x  \, ( \mathrm{ nm } )$$')
  axTemp.FontSize = fontSize;
  axis(axTemp,'square');
end

legcell = {'$$ T(x) / T_L $$', '$$ C(x) / N_t $$'};
hl = legend( axTemp, legcell );
hl.Interpreter = 'latex';
hl.Position = [0.732 0.746 0.108 0.157];

function subplotMeFig6( fluxSummary, fontSize )

row = 3;
col = 2;
kdScale = 1e6;
% Plot it
ah1 = subplot( row, col, (1:3)*col);
ah1.FontSize = fontSize;
hold all
% set params
kDvec =  1 ./ fluxSummary.kinParams.kinVarInput2;
kDvec = kdScale .* kDvec;
paramObj = fluxSummary.paramObj;
jMax = fluxSummary.jNorm;
nuVec = paramObj.nu;
% get size
numNu = length(nuVec);
numKa = length(kDvec);
jSelect = zeros( numNu, numKa );
% legend set-up
legcell = cell( length(kDvec) , 1 );
legTitle = '$$ K_D \, ( \mathrm{ \mu M } )$$';
% build data matrix
for ii = 1:numKa
  legcell{ii} = num2str( kDvec(ii), '%g' ) ;
  for jj = 1:numNu
    jSelect(jj,ii) = jMax(jj, 1, ii );
  end
end
% plot it
for ii = 1:numKa
  plot( nuVec, jSelect(:,ii) )
end
ax = gca;
ax.XLim = [ min(nuVec) max(nuVec) ];
axis square
ax.YLim = [0 50];
xlabel('Bound Diffusion $$ D_B/D_F $$')
ylabel('Selectivity $$ S $$')
hl = legend( legcell, 'location','best');
hl.Interpreter = 'latex';
hl.Title.String = legTitle;

