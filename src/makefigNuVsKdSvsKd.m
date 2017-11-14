function makefigNuVsKdSvsKd( fluxSummary, tetherCalc )
% scale factor
kdScale = 1e6;
lScaleActual = 1e-7;
lScaleWant = 1e-9;
lScale = (lScaleActual / lScaleWant)^2;
% Some tunable parameters
fontSize = 20;
selectivityLims = [0 40];
% set-up figure
fidId = 2;
fig = figure(fidId);
clf(fidId);
fig.WindowStyle = 'normal';
% fig.WindowStyle = 'docked';
fig.Position = [158 104 975 466];
xTick = kdScale * [1e-8 1e-7 1e-6 1e-5 1e-4 1e-3];
% make subplot
makeSubPlot( fluxSummary, tetherCalc, kdScale, lScale, ...
  xTick, fontSize, selectivityLims );


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

function makeSubPlot( fluxSummary, tetherCalc, kdScale, lScale, ...
  xTick, fontSize, selectivityLims )
% Plot non-linear first on subplot 2
ah1 = subplot(1,2,2);
ah1.FontSize = fontSize;
ah1.Box = 'on';
ah1.LineWidth = 1;
ah1.YLim = selectivityLims;
ah1.XTick = xTick;
ah1.XScale = 'log';
ah1.XLim = [ min(xTick) max(xTick) ];
axis square
hold all
% get data
[kdVec, lplcVec, jNorm ] = getDataFluxSummary( fluxSummary, ...
  kdScale, lScale );
% build legend
[legcell,legTitle]  = buildLegend( lplcVec );
% plot it non-linear
plotSelectivityVsKd( ah1, kdVec, jNorm, xTick, selectivityLims, '-' )
% build legend now so lines are correctly colored
h = legend( legcell, 'location','best');
h.Interpreter = 'latex';
h.Title.String = legTitle;
h.Position = [0.9115 0.3538 0.0836 0.3005];
% Plot linear next on subplot 1
ah2 = subplot(1,2,1);
ah2.FontSize = fontSize;
ah2.Box = 'on';
ah2.LineWidth = 1;
axis square
hold all
plotNuVsKd( ah2,tetherCalc.kd, ...
  tetherCalc.lplc, tetherCalc.nu, xTick, '-' )

function plotSelectivityVsKd( ax, kdVec, jNorm, xTick, selectivityLims,...
  lineStyle )
% set-up title position
% plot it
inds = 1:length(kdVec);
numLpLc = size( jNorm, 1 );
% set up colors
colorArray = colormap(['lines(' num2str(numLpLc) ')']);
for ii = 1:numLpLc
  p = plot( ax, kdVec(inds), jNorm(ii,inds) );
  p.Color = [colorArray(ii,:)];
  p.LineStyle = lineStyle;
end
% ax = gca;
% ax.XScale = 'log';
% ax.XLim = [ min(xTick) max(xTick) ];
% ax.XTick = xTick;
% ax.YLim = selectivityLims;
axis square
xlabel(ax,'Dissociation constant $$ K_D  \, ( \mathrm{ \mu M } ) $$')
ylabel(ax,'Selectivity $$ S $$')

function plotNuVsKd( ax, kdVec, lplc, nu, xTick, lineStyle)
% set-up title position
% plot it
inds = 1:length(kdVec);
numLpLc = length( lplc );
% set up colors
colorArray = colormap(['lines(' num2str(numLpLc) ')']);
for ii = 1:numLpLc
  p = plot( ax, kdVec(inds), nu(ii,:) );
  p.Color = colorArray(ii,:);
  p.LineStyle = lineStyle;
end
ax.XScale = 'log';
ax.XLim = [ min(xTick) max(xTick) ];
ax.XTick = xTick;
ax.YLim = [0 1];
axis square
xlabel(ax,'Dissociation constant $$ K_D  \, ( \mathrm{ \mu M } ) $$')
ylabel(ax,'Bound Diffusion $$ D_B / D_F $$')
