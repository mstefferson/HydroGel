function makefigSvsKd( fluxSummary, diffType )
% scale factor
maxVal = 40;
kdScale = 1e6;
xLabel = 'Dissociation constant $$ K_D \, ( \mathrm{ \mu M } )$$';
yLabel = 'Selecitivity';
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

function [kdVec, lplcVec, jNorm ] = getDataFluxSummary( ...
  fluxSummary, kdScale, lScale )
% set params
kinParams = fluxSummary.kinParams;
kdVec =  1 ./ kinParams.kinVarInput2;
kdVec = kdScale .* kdVec;
jMax = fluxSummary.jNorm;
lplcVec = kinParams.p1Vec;
lplcVec = lScale * lplcVec;
% get size
[ numLpLc, ~, numKa ] = size( jMax );
jNorm = zeros( numLpLc, numKa );
% build data matrix
for ii = 1:numLpLc
  for jj = 1:numKa
    jNorm(ii,jj) = jMax(ii, 1, jj );
  end
end

function [ legcell, legTitle ] = buildLegend( lplcVec, diffType )
% get size
[ numLpLc ] = length( lplcVec );
% legend set-up
legcell = cell( 1, numLpLc );
if strcmp( diffType, 'lplc' )
  legTitle = ' $$ l_c \, (\mathrm{ nm })$$ ';
else
  legTitle = ' $$ D_B / D_F $$ ';
end
% build legend
for ii = 1:numLpLc
  if isinf( lplcVec(ii) )
    legcell{ii} = [ ' $$ \infty $$'  ];
  else
    legcell{ii} = [ num2str( lplcVec(ii) ) ];
  end
end
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
[legcell,legTitle]  = buildLegend( nulplcVec, diffType );
% set up colors
fac = 1000;
colorArray = viridis( fac+1 );
if strcmp( diffType, 'lplc' )
  getInds = round( fac / log10( max(nulplcVec) ) * log10( nulplcVec ) )+1;
  getInds( isinf(getInds) ) = fac+1;
else
  getInds = round( fac / max( nulplcVec ) .* nulplcVec )+1;
end
wantedColors = colorArray( getInds, :);
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
% colorArray = colormap(['lines(' num2str(numLpLc) ')']);
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
