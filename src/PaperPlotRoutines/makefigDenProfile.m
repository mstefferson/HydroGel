% fatWays = 0, column plot, fatWays = 1, row plot
function makefigDenProfile( fluxSummary )
% scale and params
xScale = 100;
row = 3;
col = 1;
% Some tunable parameters
fontSize = 14;
% set params
% row1: nu = 0 unsaturated
% row2: nu = 1 unsaturated
% row3: nu = 1 saturated
subplotInds = [1 1 1; 2 1 1; 2 1 2];
% % set-up figure
figId = randi(1000);
fig = figure(figId);
clf(figId);
fig.WindowStyle = 'normal';
fig.Position = [848 171 279 534];

axis square
% plot it
subplotMeDenProfile(subplotInds, xScale, fluxSummary.aConcStdy, ...
  fluxSummary.cConcStdy,...
  fluxSummary.paramObj.AL, fluxSummary.paramObj.Btc, fontSize, row, col);
% stack it
pause(1)
stackPlots( fig, 1 )

% resquare it
axis( fig.Children(2), 'square' )
axis( fig.Children(3), 'square' )
axis( fig.Children(4), 'square' )

% A and C in the same plot using plot
function hl = subplotMeDenProfile( ...
  subplotinds, xScale, aStdy, cStdy, aScale, cScale, fontSize, row, col )
row1data = cStdy;
row2data = aStdy;
for id = 1:row
  % top row complex
  axTemp = subplot(row,col, 1+(id-1)*col);
  dataC = row1data{ ...
    subplotinds(id,1), subplotinds(id,2), subplotinds(id,3) };
  dataC = dataC ./ cScale;
  dataA = row2data{ ...
    subplotinds(id,1), subplotinds(id,2), subplotinds(id,3) };
  dataA = dataA ./ aScale;
  x = linspace(0, xScale, length(dataA) );
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
hl.Position = [0.3929 0.8392 0.3491 0.0772];


function plotMeComplex( ax, x, data, titleStr)
plot( ax, x, data );
ax.YLim = [0 1];
ylabel(ax,'$$ C(x) / B_t $$')
xlabel(ax, '$$x$$')
title( ax, titleStr )

function plotMeTf( ax, x, data, titleStr)
plot( ax, x, data );
ax.YLim = [0 1];
ylabel(ax,'$$ A(x) / A_L $$')
xlabel(ax,'$$x$$')
title( ax, titleStr )

function plotMeTfDeriv( ax, x, data, titleStr)
plot( ax, x, data );
ax.YLim = [0 5];
ylabel(ax,'$$ \left| \frac{ A(x) } {dx} \right|$$')
xlabel(ax,'$$x$$')
title( ax, titleStr )

