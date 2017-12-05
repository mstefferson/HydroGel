function makefigSvsKd( fluxSummary, diffType )
% labels
xLabel = 'Dissociation constant $$ K_D \, ( \mathrm{ \mu M } )$$';
yLabel = 'Selectivity';
% scale factor, limits
maxVal = 40;
kdScale = 1e6;
if strcmp( diffType, 'lplc' )
  lScaleActual = 1e-7;
  lScaleWant = 1e-9;
  lScale = (lScaleActual / lScaleWant)^2;
elseif strcmp( diffType, 'nu' )
  lScale = 1;
else
  error('Wrong nu str')
end
fontSize = 20;
% set-up ticks
xTick = kdScale * [1e-8 1e-7 1e-6 1e-5 1e-4 1e-3];
% set-up figure
fidId = randi(1000);
fig = figure(fidId);
clf(fidId);
fig.WindowStyle = 'normal';
% fig.WindowStyle = 'docked';
fig.Position = [393 229 501 368];
xTick = kdScale * [1e-8 1e-7 1e-6 1e-5 1e-4 1e-3];
% make plot
makeSelectivityPlot( fluxSummary, kdScale, lScale, ...
  xTick, diffType, fontSize, maxVal, xLabel, yLabel );

function makeSelectivityPlot( fluxSummary, kdScale, lScale, ...
  xTick, diffType, fontSize, maxVal, xLabel, yLabel )
% Plot it non-linear
ax = gca;
ax.FontSize = fontSize;
ax.Box = 'on';
axis square
hold all
% get data
[kdVec, nulplcVec, jNorm ] = getDataFluxSummary( fluxSummary, kdScale, lScale );
% build legend
[legcell,legTitle]  = buildDbLegend( nulplcVec, diffType );
% set up colors
if strcmp( diffType, 'lplc' )
  scaleType = 'log';
elseif strcmp( diffType, 'nu' )
  scaleType = 'linear';
end
wantedColors = getPlotLineColors( nulplcVec, scaleType );
% plot it non-linear
plotSelectivityVsKd( ax, kdVec, jNorm, xTick, maxVal, ...
  xLabel, yLabel, wantedColors )
% build legend now so lines are correctly colored
hl = legend( legcell, 'location','best');
hl.Interpreter = 'latex';
hl.Title.String = legTitle;
hl.Position = [0.8121 0.2662 0.1717 0.4995];

function plotSelectivityVsKd( ax, kdVec, ...
  jNorm, xTick, maxVal, xLabel, yLabel, wantedColors)
% set-up title position
% plot it
inds = 1:length(kdVec);
numLpLc = size( jNorm, 1 );
for ii = 1:numLpLc
  p = plot( ax, kdVec(inds), jNorm(ii,inds) );
  p.Color = wantedColors(ii,:);
end
ax = gca;
ax.XScale = 'log';
ax.XLim = [ min(xTick) max(xTick) ];
ax.XTick = xTick;
ax.YLim = [0 maxVal];
axis square
xlabel( ax, xLabel )
ylabel( ax, yLabel )
