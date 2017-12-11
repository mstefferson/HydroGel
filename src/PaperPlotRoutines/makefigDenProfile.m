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
fig.WindowStyle = 'normal';
if plotSameSpeciesTogether == 1
  % set rows/cols
  row = 1;
  col = 2;
  % Some tunable parameters
  fig.Position = [228 323 750 336];
  % plot it
  subplotMeDenProfileSameSpeciesTogether(subplotInds, xScale, ...
    fluxSummary.aConcStdy, fluxSummary.cConcStdy,...
    fluxSummary.paramObj.AL, fluxSummary.paramObj.Btc, fontSize, row, col);
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
% set colors, line styles, width
skinnyWidth = 5;
fatWidth = 5;
lineType1 = '-';
markerType1 = 'none';
lineType2 = 'none';
markerType2 = '.';
markerSize = 16;
numberMarker = 20;
lengthData = length( cStdy{ ...
    subplotinds(1,1), subplotinds(1,2), subplotinds(1,3) } );
markerIndices = 1:round(lengthData/numberMarker ):lengthData;
% viridis 100
color1 = [0.1934 0.7098 0.4810]; % 66
color2 = [0.2670 0.0049 0.3294]; % 1
% labels
xLabel = 'Position $$x  \, ( \mathrm{ nm } )$$';
yLabel1 = 'Density Profile $$ T(x) / T_L $$';
yLabel2 = 'Density Profile $$ C(x) / N_T $$';
% set up plot
numRuns = size(subplotinds,1);
row1data = cStdy;
row2data = aStdy;
ax1 = subplot(row,col, 1);
ax1.YLim = [0 1];
ax1.YTick = 0:0.2:1;
ylabel(ax1, yLabel1)
xlabel(ax1, xLabel)
ax1.FontSize = fontSize;
axis(ax1, 'square')
hold
ax2 = subplot(row,col, 2);
ax2.YLim = [0 1];
ax2.YTick = 0:0.2:1;
ylabel(ax2, yLabel2)
xlabel(ax2, xLabel)
ax2.FontSize = fontSize;
axis(ax2, 'square')
hold
for id = 1:numRuns
  % top row complex
  dataC = row1data{ ...
    subplotinds(id,1), subplotinds(id,2), subplotinds(id,3) };
  dataA = row2data{ ...
    subplotinds(id,1), subplotinds(id,2), subplotinds(id,3) };
  x = linspace(0, xScale, length(dataA) );
  p1 = plot( ax1, x, dataA ./ aScale );
  p2 = plot( ax2, x, dataC ./ cScale );
  if id == 1 %unsaturdated nu = 0
    dashStyle = lineType1;
    colorTemp = color1;
    linewidth = fatWidth;
    markerType =  markerType1;
  elseif id == 2 %unsaturdated nu = 1
    dashStyle = lineType2;
    colorTemp = color1;
    linewidth = skinnyWidth;
    markerType =  markerType2;
  elseif id == 3 % saturdated nu = 1
    dashStyle = lineType2;
    colorTemp = color2;
    linewidth = skinnyWidth;
    markerType =  markerType2;
  end
  p1.LineStyle = dashStyle;
  p1.LineWidth = linewidth;
  p1.Color = colorTemp;
  p1.Marker = markerType;
  p1.MarkerSize = markerSize;
  p1.MarkerIndices = markerIndices;
  p1.Marker = markerType;
  p2.LineStyle = dashStyle;
  p2.LineWidth = linewidth;
  p2.Color = colorTemp;
  p2.Marker = markerType;
  p2.MarkerSize = markerSize;
  p2.MarkerIndices = markerIndices;
end
% legend
legcell = {'Unsaturated, $$ \nu = 0 $$', 'Unsaturated, $$ \nu = 1 $$', ...
  'Saturated, $$ \nu = 1 $$'};
hl = legend( ax2, legcell );
hl.Interpreter = 'latex';
hl.Position = [0.2634 0.6965 0.1962 0.1849];