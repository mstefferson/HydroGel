function makefigSvsKd( fluxSummary, diffType, yLimMax, wantedColorsOverride )
if nargin < 3
  yLimMax = [];
  wantedColorsOverride = [];
elseif nargin < 4
  wantedColorsOverride = [];
end
% labels
xLabel = 'Dissociation constant $$ K_D \, ( \mathrm{ \mu M } )$$';
yLabel = 'Selectivity $$ S $$';
% scale factor, limits
kdScale = 1e6;
if strcmp( diffType, 'lplc' )
  lScaleActual = 1e-6;
  lScaleWant = 1e-9;
  lScale = (lScaleActual / lScaleWant)^2;
elseif strcmp( diffType, 'nu' )
  lScale = 1;
else
  error('Wrong nu str')
end
fontSize = 20;
% set-up figure
fig = figure();
clf(fig);
fig.WindowStyle = 'normal';
% fig.WindowStyle = 'docked';
fig.Position = [393 229 501 368];
% make plot
makeSelectivityPlot( fluxSummary, kdScale, lScale, ...
  diffType, fontSize, yLimMax, xLabel, yLabel, wantedColorsOverride );

function makeSelectivityPlot( fluxSummary, kdScale, lScale, ...
  diffType, fontSize, yLimMax, xLabel, yLabel, wantedColorsOverride )
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
if isempty( wantedColorsOverride )
  wantedColors = getPlotLineColors( nulplcVec, scaleType, 'pmkmp' );
else
  wantedColors = wantedColorsOverride;
end
% plot it non-linear
plotSelectivityVsKd( ax, kdVec, jNorm, yLimMax, ...
  xLabel, yLabel, wantedColors )
% build legend now so lines are correctly colored
hl = legend( legcell, 'location','best');
hl.Interpreter = 'latex';
hl.Title.String = legTitle;
if length( nulplcVec ) > 4
  hl.Position = [0.8121 0.2662 0.1717 0.4995];
else
  hl.Position = [0.8301 0.4043 0.1357 0.3193];
end

function plotSelectivityVsKd( ax, kdVec, ...
  jNorm, yLimMax, xLabel, yLabel, wantedColors)
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
% build tick
kdStart = log10( min( kdVec ) );
kdEnd = log10( max( kdVec ) );
xTick = logspace( kdStart, kdEnd, (kdEnd - kdStart ) + 1 );
ax.XLim = [ min(xTick) max(xTick) ];
ax.XTick = xTick;
if ~isempty( yLimMax )
  ax.YLim = [0 yLimMax];
end
axis square
xlabel( ax, xLabel )
ylabel( ax, yLabel )
