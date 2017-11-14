function makefigSvsKdLinear( linSummary )
% scale factor
kdScale = 1e6;
% Some tunable parameters
fontSize = 20;
% set-up figure
fidId = 2;
fig = figure(fidId);
clf(fidId);
fig.WindowStyle = 'normal';
% fig.WindowStyle = 'docked';
fig.Position = [591 134 567 414];
xTick = kdScale * [1e-8 1e-7 1e-6 1e-5 1e-4 1e-3];

% make subplot
makeLinPlot( linSummary, ...
  xTick, fontSize );
if 0
  fidId = 20;
  fig = figure(fidId);
  clf(fidId);
  fig.WindowStyle = 'normal';
  makeLinPlot( fluxSummary, linSummary, kdScale, lScale, ...
    xTick, fontSize );
end

function [kdVec, lplcVec, jNorm, kdVecLin, jNormLin ] = ...
  getDataFluxLin( linSummary )
% set params
kdVec =  linSummary.kdVec; % already scaled
jNorm = linSummary.jNorm;
lplcVec = linSummary.lc;
% plot just linear part
[~,linInd] = min( abs( kdVec - 1 ) );
kdVecLin = kdVec(linInd:end);
jNormLin = jNorm(:,linInd:end);

function [ legcell, legTitle ] = buildLegend( lplcVec )
% get size
[ numLpLc ] = length( lplcVec );
% legend set-up
legcell = cell( 1, numLpLc );
legTitle = ' $$ l_c l_p \, (\mathrm{ nm^2 })$$ ';
% build legend
for ii = 1:numLpLc
  if  lplcVec(ii) > 5e3 
    legcell{ii} = [ ' $$ \infty $$'  ];
  else
    legcell{ii} = [ num2str( lplcVec(ii) ) ];
  end
end

function makeLinPlot( linSummary, ...
  xTick, fontSize )
% Plot it non-linear
ax = gca;
ax.FontSize = fontSize;
axis square
hold all
% get linear data
[kdVec, lplcVec, jNorm, kdVecLin, jNormLin ] = getDataFluxLin( linSummary );
% plot all it linear in linear regime
plotSelectivityVsKd( ax, kdVecLin, jNormLin, xTick, 1, '-' )
% plot all it linear but faded
plotSelectivityVsKd( ax, kdVec, jNorm, xTick, 0.1, '-' )
% build legend
% [legcell,legTitle]  = buildLegend( lplcVec );
% plot div
plotLinDiv( ax, kdVec )
% build legend and clear
[legcell,legTitle]  = buildLegend( lplcVec );
hl = legend( legcell );
hl.Interpreter = 'latex';
hl.Title.String = legTitle;

function plotLinDiv( ax, kdVec )
slopeBig = 1000;
linDiv = slopeBig * ( kdVec - 1 );
plot( ax, kdVec, linDiv, 'k:' );

function plotSelectivityVsKd( ax, kdVec, jNorm, xTick, transparFac, lineStyle )
% set-up title position
% plot it
inds = 1:length(kdVec);
numLpLc = size( jNorm, 1 );
% set up colors
colorArray = colormap(['lines(' num2str(numLpLc) ')']);
for ii = 1:numLpLc
  p = plot( ax, kdVec(inds), jNorm(ii,inds) );
  p.Color = [colorArray(ii,:) transparFac];
  p.LineStyle = lineStyle;
end
ax = gca;
ax.XScale = 'log';
ax.XLim = [ min(xTick) max(xTick) ];
ax.XTick = xTick;
ax.YLim = [0 50];
axis square
xlabel(ax,'Dissociation constant $$ K_D  \, ( \mathrm{ \mu M } ) $$')
ylabel(ax,'Selectivity $$ S $$')
