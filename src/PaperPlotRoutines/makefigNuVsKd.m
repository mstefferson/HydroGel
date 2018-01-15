% kd: molar
% lplc: unscaled
function makefigNuVsKd( kdVec, lplcVec, nu )
%scales
kdScale = 1e6;
lScaleActual = 1e-7;
lScaleWant = 1e-9;
lScale = (lScaleActual / lScaleWant)^2;
% label
xLabel = 'Dissociation constant $$ K_D  \, ( \mathrm{ \mu M } ) $$';
yLabel = 'Bound Diffusion $$ D_B / D_F $$';
fontSize = 20;
% set-up figure
fig = figure();
clf(fig);
fig.WindowStyle = 'normal';
% fig.WindowStyle = 'docked';
fig.Position = [594 148 539 422];
% get data in the correct form, input should be kdMolar, 
lplcVec = lplcVec .* lScale;
kdVec = kdVec .* kdScale;
% make subplot
makeNuVsKdPlot( kdVec, lplcVec, nu,...
  fontSize, xLabel, yLabel );

function [ legcell, legTitle ] = buildLegend( lplcVec )
% get size
[ numLpLc ] = length( lplcVec );
% legend set-up
legcell = cell( 1, numLpLc );
legTitle = ' $$ l_c \, (\mathrm{ nm })$$ ';
% build legend
for ii = 1:numLpLc
  if isinf( lplcVec(ii) )
    legcell{ii} = [ ' $$ \infty $$'  ];
  else
    legcell{ii} = [ num2str( lplcVec(ii) ) ];
  end
end

function makeNuVsKdPlot( kdVec, lplc, nu, ...
  fontSize, xLabel, yLabel )
% Plot non-linear first on subplot 2
ah1 = gca;
ah1.FontSize = fontSize;
ah1.Box = 'on';
ah1.LineWidth = 1;
ah1.YLim = [0 1];
% build tick
kdStart = log10( min( kdVec ) );
kdEnd = log10( max( kdVec ) );
xTick = logspace( kdStart, kdEnd, (kdEnd - kdStart ) + 1 );
ah1.XTick = xTick;
ah1.XScale = 'log';
ah1.XLim = [ min(xTick) max(xTick) ];
xlabel( xLabel );
ylabel( yLabel );
axis square
hold all
% set up colors
scaleType = 'log';
wantedColors = getPlotLineColors( lplc, scaleType, 'pmkmp' );
% Plot linear next on subplot 1
plotNuVsKd( ah1, kdVec, lplc, nu, wantedColors )
% build legend
[legcell,legTitle]  = buildLegend( lplc );
% build legend now so lines are correctly colored
hl = legend( legcell, 'location','best');
hl.Interpreter = 'latex';
hl.Title.String = legTitle;
hl.Position = [0.8323 0.3290 0.1596 0.3832];

function plotNuVsKd( ax, kdVec, lplc, nu, wantedColors)
% set-up title position
% plot it
inds = 1:length(kdVec);
numLpLc = length( lplc );
for ii = 1:numLpLc
  p = plot( ax, kdVec(inds), nu(ii,:) );
  p.Color = wantedColors(ii,:);
end
