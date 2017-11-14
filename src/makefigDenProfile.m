function makefig3( fluxSummary, fatWays )
% scale and params
xScale = 100;
x = linspace(0,1,fluxSummary.paramObj.Nx );
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
if fatWays
  fig.Position = [251 637 876 221];
else
  fig.Position = [638 265 489 440];
end
axis square
% plot it
subplotMeShare(subplotInds, x, fluxSummary.aConcStdy, fluxSummary.cConcStdy,...
  fluxSummary.paramObj.AL, fluxSummary.paramObj.Btc, fontSize, fatWays);
% stack ti
if ~fatWays
  pause(1)
  stackPlots( fig, 1 )
end


function subplotMe2( subplotinds, x, aStdy, cStdy, aScale, cScale )
row = 2;
col = 3;
row1data = cStdy;
row2data = aStdy;
titCell= {'A','B','C', 'D', 'E', 'F'};
for id = 1:3
  % top row complex
  axTemp = subplot(row,col,id);
  data = row1data{ ...
    subplotinds(id,1), subplotinds(id,2), subplotinds(id,3) };
  data = data ./ cScale;
  plotMeComplex( axTemp, x, data, titCell{row*id-row+1})
  % bottom row Tf
  axTemp = subplot(row,col,col+id);
  data = row2data{ ...
    subplotinds(id,1), subplotinds(id,2), subplotinds(id,3) };
  data = data ./ aScale;
  plotMeTf( axTemp, x, data, titCell{row*id-row+2} )
end

function subplotMe3( subplotinds, x, aStdy, cStdy, aScale, cScale )
row = 3;
col = 3;
dx = x(2) - x(1);
xSlope = x(1:end-1) + dx/2;
row1data = cStdy;
row2data = aStdy;
titCell= {'A','B','C', 'D', 'E', 'F', 'G', 'H', 'I'};
for id = 1:3
  % top row complex
  axTemp = subplot(row,col,id);
  data = row1data{ ...
    subplotinds(id,1), subplotinds(id,2), subplotinds(id,3) };
  data = data ./ cScale;
  plotMeComplex( axTemp, x, data, titCell{row*id-row+1})
  % mid row row Tf
  axTemp = subplot(row,col,col+id);
  data = row2data{ ...
    subplotinds(id,1), subplotinds(id,2), subplotinds(id,3) };
  data = data ./ aScale;
  plotMeTf( axTemp, x, data, titCell{row*id-row+2} )
  % bottom row Tf derivative
  axTemp = subplot(row,col,2*col+id);
  data = row2data{ ...
    subplotinds(id,1), subplotinds(id,2), subplotinds(id,3) };
  data = data ./ aScale;
  % take derivative
  data = abs( ( data(2:end) - data(1:end-1) ) ./ dx );
  plotMeTfDeriv( axTemp, xSlope, data, titCell{row*id-row+3} )
end

% A and C in the same plot using plotyy
function [ayy] = subplotMeShareYy( ...
  subplotinds, x, aStdy, cStdy, aScale, cScale, fontSize )
row = 1;
col = 3;
row1data = cStdy;
row2data = aStdy;
titCell= {'A','B','C'};
for id = 1:3
  % top row complex
  axTemp = subplot(row,col,id);
  dataC = row1data{ ...
    subplotinds(id,1), subplotinds(id,2), subplotinds(id,3) };
  dataC = dataC ./ cScale;
  dataA = row2data{ ...
    subplotinds(id,1), subplotinds(id,2), subplotinds(id,3) };
  dataA = dataA ./ aScale;
  [ayy] = plotyy( axTemp, x, dataA, x, dataC );
  ayy(1).YLim = [0 1];
  ayy(2).YLim = [0 1];
  ayy(1).YTick = 0:0.2:1;
  ayy(2).YTick = 0:0.2:1;
  ylabel(ayy(1),'$$ A(x) / A_L $$')
  ylabel(ayy(2),'$$ C(x) / B_t $$')
  xlabel(ayy(1), '$$x$$')
  ayy(1).FontSize = fontSize;
  ayy(2).FontSize = fontSize;
  title( ayy(1), titCell{id} )
  axis(ayy(1),'square'); axis(ayy(2),'square');
end

% A and C in the same plot using plot
function subplotMeShare( ...
  subplotinds, x, aStdy, cStdy, aScale, cScale, fontSize, fatWays )
titlePos = [0.05 1];
if fatWays
  row = 1;
  col = 3;
else
  row = 3;
  col = 1;
end
row1data = cStdy;
row2data = aStdy;
titCell= {'','',''};
%titCell= {'A','B','C'};
for id = 1:3
  % top row complex
  axTemp = subplot(row,col,id);
  dataC = row1data{ ...
    subplotinds(id,1), subplotinds(id,2), subplotinds(id,3) };
  dataC = dataC ./ cScale;
  dataA = row2data{ ...
    subplotinds(id,1), subplotinds(id,2), subplotinds(id,3) };
  dataA = dataA ./ aScale;
  plot( axTemp, x, dataA, x, dataC );
  axTemp.YLim = [0 1];
  axTemp.YTick = 0:0.2:1;
  if fatWays
    ylabel(axTemp, 'Scaled Density Profile')
  else
    ylabel(axTemp, 'Density Profile')
  end
  xlabel(axTemp, 'Position $$x  \, ( \mathrm{ nm } )$$')
  axTemp.FontSize = fontSize;
  title( axTemp, titCell{id},'position', titlePos )
  axis(axTemp,'square');
end

if fatWays
  legcell = {'$$ T(x) / T_L $$', '$$ C(x) / N_t $$'};
  hl = legend( axTemp, legcell );
  hl.Interpreter = 'latex';
  hl.Position = [0.8946 0.4797 0.1018 0.1572];
else
  legcell = {'$$ T(x) / T_L $$', '$$ C(x) / N_t $$'};
  hl = legend( axTemp, legcell );
  hl.Interpreter = 'latex';
  hl.Position = [0.732 0.746 0.108 0.157];
end


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

