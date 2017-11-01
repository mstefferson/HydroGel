function makefig3( fluxSummary )
% scale and params
x = linspace(0,1,fluxSummary.paramObj.Nx );
% Some tunable parameters
fontSize = 6;
% set params
% row1: nu = 0 unsaturated
% row2: nu = 1 unsaturated
% row3: nu = 1 saturated
subplotInds = [1 1 1; 2 1 1; 2 1 2];
% set-up figure
fidId = 30;
figure(fidId);
clf(fidId);
% Plot it
ah1 = gca;
ah1.FontSize = fontSize;
axis square
% subplot them all
subplotMe2(subplotInds, x, fluxSummary.aConcStdy, fluxSummary.cConcStdy,...
  fluxSummary.paramObj.AL, fluxSummary.paramObj.Btc)
% stack
ax = gca;
fig = ax.Parent;
pause(3);
stackPlots( fig, 3 )
% include derivative
% set-up figure
fidId = 31;
figure(fidId);
clf(fidId);
ah1 = gca;
ah1.FontSize = fontSize;
axis square
subplotMe3(subplotInds, x, fluxSummary.aConcStdy, fluxSummary.cConcStdy,...
  fluxSummary.paramObj.AL, fluxSummary.paramObj.Btc);
% stack
ax = gca;
fig = ax.Parent;
pause(3);
stackPlots( fig, 3 )

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

