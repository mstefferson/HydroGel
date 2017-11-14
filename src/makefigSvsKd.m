function makefig2( fluxSummary, linSummary )
% scale factor
kdScale = 1e6;
lScaleActual = 1e-7;
lScaleWant = 1e-9;
lScale = (lScaleActual / lScaleWant)^2;
% Some tunable parameters
fontSize = 20;
% set-up figure
fidId = 2;
fig = figure(fidId);
clf(fidId);
fig.WindowStyle = 'normal';
% fig.WindowStyle = 'docked';
fig.Position = [25 171 1133 377];
xTick = kdScale * [1e-8 1e-7 1e-6 1e-5 1e-4 1e-3];
%titleCell = {'A','B'};
titleCell = {'',''};
% make subplot
makeSubPlot( fluxSummary, linSummary, kdScale, lScale, ...
  xTick, titleCell, fontSize );
if 0
  fidId = 20;
  fig = figure(fidId);
  clf(fidId);
  fig.WindowStyle = 'normal';
  makeSamePlot( fluxSummary, linSummary, kdScale, lScale, ...
    xTick, titleCell, fontSize );
end

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
  if isinf( lplcVec(ii) )
    legcell{ii} = [ ' $$ \infty $$'  ];
  else
    legcell{ii} = [ num2str( lplcVec(ii) ) ];
  end
end

function makeSamePlot( fluxSummary, linSummary, kdScale, lScale, ...
  xTick, titleCell, fontSize )

% Plot it non-linear
ax = gca;
ax.FontSize = fontSize;
axis square
hold all
% get data
[kdVec, lplcVec, jNorm ] = getDataFluxSummary( fluxSummary, kdScale, lScale );
% build legend
[legcell,legTitle]  = buildLegend( lplcVec );
% plot it non-linear
plotSelectivityVsKd( ax, kdVec, jNorm, xTick, titleCell{1}, 1, '-' )
% build legend now so lines are correctly colored
h = legend( legcell, 'location','best');
h.Interpreter = 'latex';
h.Title.String = legTitle;
h.Position = [0.8861 0.3210 0.0911 0.3899];
% get linear data
[kdVec, ~, jNorm, kdVecLin, jNormLin ] = getDataFluxLin( linSummary );
% plot all it linear but faded
plotSelectivityVsKd( ax, kdVec, jNorm, xTick, titleCell{2}, 0.1, '-' )
% plot all it linear in linear regime
plotSelectivityVsKd( ax, kdVecLin, jNormLin, xTick, titleCell{2}, 1, '--' )
% plot div
plotLinDiv( ax, kdVec )

function makeSubPlot( fluxSummary, linSummary, kdScale, lScale, ...
  xTick, titleCell, fontSize )
% Plot non-linear first on subplot 2
ah1 = subplot(1,2,2);
ah1.FontSize = fontSize;
axis square
hold all
% get data
[kdVec, lplcVec, jNorm ] = getDataFluxSummary( fluxSummary,kdScale, lScale );
% build legend
[legcell,legTitle]  = buildLegend( lplcVec );
% plot it non-linear
plotSelectivityVsKd( ah1, kdVec, jNorm, xTick, titleCell{1}, 1, '-' )
% build legend now so lines are correctly colored
h = legend( legcell, 'location','best');
h.Interpreter = 'latex';
h.Title.String = legTitle;
h.Position = [0.8861 0.3210 0.0911 0.3899];
% Plot linear next on subplot 1
ah2 = subplot(1,2,1);
ah2.FontSize = fontSize;
axis square
hold all
% get linear data
[kdVec, ~, jNorm, kdVecLin, jNormLin ] = getDataFluxLin( linSummary );
% plot all it linear but faded
plotSelectivityVsKd( ah2, kdVec, jNorm, xTick, titleCell{2}, 0.1, '-' )
% plot just linear part
plotSelectivityVsKd( ah2, kdVecLin, jNormLin, xTick, titleCell{2}, 1, '-' )
% plot div
plotLinDiv( ah2, kdVec )

function plotLinDiv( ax, kdVec )
slopeBig = 1000;
linDiv = slopeBig * ( kdVec - 1 );
plot( ax, kdVec, linDiv, 'k:' );

function plotSelectivityVsKd( ax, kdVec, jNorm, xTick, titleStr, transparFac, lineStyle )
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
titlePos = [0.05 1]; % outside
% titlePos = [0.05 0.90]; % inside
th = title(ax, titleStr);
th.Units = 'normalized';
th.Position = titlePos;
