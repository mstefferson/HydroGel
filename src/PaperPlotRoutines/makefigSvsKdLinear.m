%
% linSummary.kd (micro molar)
% linSummary.nulc nu or lc (nm)
% linSummary.jNorm ( lc by kd )
%

function makefigSvsKdLinear( linSummary, diffType )
% labels
xLabel = 'Dissociation constant $$ K_D \, ( \mathrm{ \mu M } )$$';
yLabel = 'Selectivity';
% scale factor, limits
maxVal = 50;
% Some tunable parameters
fontSize = 20;
% set-up figure
fidId = randi(1000);
fig = figure(fidId);
clf(fidId);
fig.WindowStyle = 'normal';
% fig.WindowStyle = 'docked';
fig.Position = [393 229 501 368];
% make subplot
makeLinPlot( linSummary,  xLabel, yLabel,...
  fontSize, maxVal, diffType );

function [kdVec, nulplcVec, jNorm, kdVecLin, jNormLin ] = ...
  getDataFluxLin( linSummary )
% set params
kdVec =  linSummary.kdVec; % already scaled
jNorm = linSummary.jNorm;
nulplcVec = linSummary.nulc;
% make sure data is direction of increasing kd
[kdVec, kdInds] = sort( kdVec );
jNorm = jNorm( :, kdInds );
% plot just linear part
[~,linInd] = min( abs( kdVec - 1 ) );
kdVecLin = kdVec(linInd:end);
jNormLin = jNorm(:,linInd:end);

function makeLinPlot( linSummary, xLabel, yLabel,...
  fontSize, maxVal, diffType )
% Plot it non-linear
ax = gca;
ax.FontSize = fontSize;
ax.Box = 'on';
ax.LineWidth = 1;
axis square
hold all
% get linear data
[kdVec, nulplcVec, jNorm, kdVecLin, jNormLin ] = getDataFluxLin( linSummary );
% set up colors
if strcmp( diffType, 'lplc' )
  scaleType = 'log';
elseif strcmp( diffType, 'nu' )
  scaleType = 'linear';
end
wantedColors = getPlotLineColors( nulplcVec, scaleType );
% plot all it linear in linear regime
plotSelectivityVsKd( ax, kdVecLin, jNormLin, maxVal, ...
  1, '-', wantedColors, xLabel, yLabel )
% plot all it linear but faded
plotSelectivityVsKd( ax, kdVec, jNorm, maxVal, ...
  0.2, '-', wantedColors, xLabel, yLabel )
% plot div
plotLinDiv( ax, kdVec )
% build legend and clear
[legcell,legTitle]  = buildDbLegend( nulplcVec, diffType );
hl = legend( legcell );
hl.Interpreter = 'latex';
hl.Title.String = legTitle;
hl.Position = [0.8121 0.2662 0.1717 0.4995];

function plotLinDiv( ax, kdVec )
slopeBig = 1000;
linDiv = slopeBig * ( kdVec - 1 );
plot( ax, kdVec, linDiv, 'k:' );

function plotSelectivityVsKd( ax, kdVec, jNorm, maxVal,...
  transparFac, lineStyle, wantedColors, xLabel, yLabel )
% set-up title position
% plot it
inds = 1:length(kdVec);
numLpLc = size( jNorm, 1 );
for ii = 1:numLpLc
  p = plot( ax, kdVec(inds), jNorm(ii,inds), lineStyle );
  p.Color = [wantedColors(ii,:) transparFac];
end
ax = gca;
% build tick
kdStart = log10( min( kdVec ) );
kdEnd = log10( max( kdVec ) );
xTick = logspace( kdStart, kdEnd, (kdEnd - kdStart ) + 1 );
ax.XLim = [ min(xTick) max(xTick) ];
ax.XTick = xTick;
ax.XScale = 'log';
ax.YLim = [0 maxVal];
axis square
xlabel(ax,xLabel)
ylabel(ax,yLabel)
