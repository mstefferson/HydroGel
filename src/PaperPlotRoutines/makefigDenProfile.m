% fatWays = 0, column plot, fatWays = 1, row plot
function makefigDenProfile( fluxSummary )
% turn on flag for T in sma plot of separate
plotSameSpeciesTogether = 1;
% scale and params
xScale = 100;
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
fig.WindowStyle = 'docked';
if plotSameSpeciesTogether == 1
  % set rows/cols
  row = 1;
  col = 3;
  % Some tunable parameters
  fig.Position = [228 323 750 336];
  %axis square
  % plot it
  subplotMeDenProfileSameSpeciesTogether(subplotInds, xScale, ...
    fluxSummary.aConcStdy, fluxSummary.cConcStdy,...
    fluxSummary.paramObj.AL, fluxSummary.paramObj.Btc, fontSize, row, col);
  %figure()
  %subplotMeDenProfileSameSpeciesTogether(subplotInds, xScale, ...
    %fluxSummary.aConcStdy, fluxSummary.cConcStdy,...
    %1, 1, fontSize, row, col);
else
  % set rows/cols
  row = 3;
  col = 1;
  % Some tunable parameters
  fig.Position = [848 171 279 534];
  %axis square
  % plot it
  subplotMeDenProfileSameRunsTogether(subplotInds, xScale, fluxSummary.aConcStdy, ...
    fluxSummary.cConcStdy,...
    fluxSummary.paramObj.AL, fluxSummary.paramObj.Btc, fontSize, row, col);
  % stack it
  pause(1)
  stackPlots( fig, 1 )
  % resquare it
  axis( fig.Children(2), 'square' )
  axis( fig.Children(3), 'square' )
  axis( fig.Children(4), 'square' )
end


% A and C in the same plot using plot
function hl = subplotMeDenProfileSameRunsTogether( ...
  subplotinds, xScale, aStdy, cStdy, aScale, cScale, fontSize, row, col )
numRuns = size(subplotinds,1);
row1data = cStdy;
row2data = aStdy;
for id = 1:numRuns
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

% A and C in the same plot using plot
function hl = subplotMeDenProfileSameSpeciesTogether( ...
  subplotinds, xScale, aStdy, cStdy, aScale, cScale, fontSize, row, col )
numRuns = size(subplotinds,1);
row1data = cStdy;
row2data = aStdy;
ax1 = subplot(row,col, 1);
% ax1.YLim = [0 1];
% ax1.YTick = 0:0.2:1;
ylabel(ax1, 'Density Profile')
xlabel(ax1, 'Position $$x  \, ( \mathrm{ nm } )$$')
ax1.FontSize = fontSize;
axis(ax1, 'square')
hold
ax2 = subplot(row,col, 2);
% breakyaxis( [0.2 0.8] )
% ax2.YLim = [0 1];
% ax2.YTick = 0:0.2:1;
ylabel(ax2, 'Density Profile')
xlabel(ax2, 'Position $$x  \, ( \mathrm{ nm } )$$')
ax2.FontSize = fontSize;
axis(ax2, 'square')
hold
ax3 = subplot(row,col, 3);
% breakyaxis( [0.2 0.8] )
% ax2.YLim = [0 1];
% ax2.YTick = 0:0.2:1;
ylabel(ax3, 'Density Profile')
xlabel(ax3, 'Position $$x  \, ( \mathrm{ nm } )$$')
ax3.FontSize = fontSize;
axis(ax3, 'square')
hold
% figure()
% ax3 = gca;
% hold
% figure()
% ax4 = gca;
% hold
for id = 1:numRuns
  % top row complex
  dataC = row1data{ ...
    subplotinds(id,1), subplotinds(id,2), subplotinds(id,3) };
%   dataC = dataC ./ cScale;
  dataA = row2data{ ...
    subplotinds(id,1), subplotinds(id,2), subplotinds(id,3) };
%   dataA = dataA ./ aScale;
  x = linspace(0, xScale, length(dataA) );
  plot( ax1, x, dataA ./ aScale )
  plot(ax2, x, dataC ./ cScale );
  plot(ax3, x, dataC + dataA );
%   plot(ax3, x, dataC );
%   if id ~= 3
%     plot(ax4, x, dataA + dataC );
%   end
end
% legend
legcell = {'Unsaturated, $$ \nu = 0 $$', 'Unsaturated, $$ \nu = 1 $$', ...
  'Saturated, $$ \nu = 1 $$'};
hl = legend( ax3, legcell );
hl.Interpreter = 'latex';
hl.Position = [0.2634 0.6935 0.1962 0.1849];
%%
% ax3.YLim = [0 1];
% ax3.YTick = 0:0.2:1;
% ylabel(ax3, 'Density Profile')
% xlabel(ax3, 'Position $$x  \, ( \mathrm{ nm } )$$')
% ax3.FontSize = fontSize;
% axis(ax3, 'square')
% deltaBreak = 0.05;
% axis(ax3, 'square')
% breakyaxis( [deltaBreak  1-deltaBreak] )
% axis(ax3, 'square')
% figure()
% plot( x, dataA + dataC )
% keyboard
%

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
