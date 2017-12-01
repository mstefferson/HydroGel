function makefigNuVsKd( tetherCalc )
%scales
kdScale = 1e6;
% label
xLabel = 'Dissociation constant $$ K_D  \, ( \mathrm{ \mu M } ) $$';
yLabel = 'Bound Diffusion $$ D_B / D_F $$';
fontSize = 20;
% set-up figure
fidId = randi(1000);
fig = figure(fidId);
clf(fidId);
fig.WindowStyle = 'normal';
% fig.WindowStyle = 'docked';
fig.Position = [594 148 539 422];
xTick = kdScale * [1e-8 1e-7 1e-6 1e-5 1e-4 1e-3];
% make subplot
makeNuVsKdPlot( tetherCalc,...
  xTick, fontSize, xLabel, yLabel );

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

function makeNuVsKdPlot( tetherCalc, ...
  xTick, fontSize, xLabel, yLabel )
% Plot non-linear first on subplot 2
ah1 = gca;
ah1.FontSize = fontSize;
ah1.Box = 'on';
ah1.LineWidth = 1;
ah1.YLim = [0 1];
ah1.XTick = xTick;
ah1.XScale = 'log';
ah1.XLim = [ min(xTick) max(xTick) ];
xlabel( xLabel );
ylabel( yLabel );
axis square
hold all
% set up colors
scaleType = 'log';
wantedColors = getPlotLineColors( tetherCalc.lplc, scaleType );
% Plot linear next on subplot 1
plotNuVsKd( ah1, tetherCalc.kd, ...
  tetherCalc.lplc, tetherCalc.nu, wantedColors )
% build legend
[legcell,legTitle]  = buildLegend( tetherCalc.lplc );
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
