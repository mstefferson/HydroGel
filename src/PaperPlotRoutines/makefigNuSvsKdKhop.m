function makefigNuSvsKdKhop( hoppingData )
% turne on error bars or not based on data
if isfield( hoppingData, 'nuErrLower' )
  errorbarFlag = 1;
else
  errorbarFlag = 0;
end
% labels
xLabel = 'Dissociation constant $$ K_D \, ( \mathrm{ \mu M } )$$';
yLabel1 = 'Bound Diffusion $$ D_B / D_F $$';
yLabel2 = 'Selectivity';
% scale factor, limits
maxVal = 40;
fontSize = 20;
% set-up figure
fidId = randi(1000);
fig = figure(fidId);
clf(fidId);
fig.WindowStyle = 'normal';
fig.Position = [250 244 834 353];
% make plot
makePlotsKHop( hoppingData,...
  fontSize, maxVal, xLabel, yLabel1, yLabel2, errorbarFlag );

function makePlotsKHop( hoppingData, ...
  fontSize, maxVal, xLabel, yLabel1, yLabel2, errorbarFlag )
% set-up ticks
kdStart = log10( min( hoppingData.kdVecScaled ) );
kdEnd = log10( max( hoppingData.kdVecScaled ) );
xTick = round( ...
  logspace( kdStart, kdEnd, (kdEnd - kdStart ) + 1 ) );
% set up colors
colorVec = 1:length(hoppingData.kHopVec);
scaleType = 'linear';
wantedColors = getPlotLineColors( colorVec, scaleType );
% set up nu plot
ax1 = subplot(1,2,1);
ax1.Position = [0.0787 0.2 0.3347 0.7335];
ax1.FontSize = fontSize;
ax1.Box = 'on';
axis square
ax1.XScale = 'log';
ax1.XLim = [ min(xTick) max(xTick) ];
ax1.XTick = xTick;
ax1.YLim = [0 1];
xlabel( ax1, xLabel )
ylabel( ax1, yLabel1 )
hold all
if errorbarFlag
  plotDataVsKdErrorBar( ax1, hoppingData.nuData, hoppingData.nuErrLower, ...
    hoppingData.nuErrUpper, hoppingData.nuTether, hoppingData.kdVecScaled, ...
    hoppingData.kHopVec, wantedColors)
else
  plotDataVsKd( ax1, hoppingData.nuData, hoppingData.nuTether, ...
    hoppingData.kdVecScaled, hoppingData.kHopVec, wantedColors)
end
% set up selectivity plot
ax2 = subplot(1,2,2);
ax2.Position = [0.4912 0.2 0.3347 0.7335];
ax2.FontSize = fontSize;
ax2.Box = 'on';
axis square
ax2.XScale = 'log';
ax2.XLim = [ min(xTick) max(xTick) ];
ax2.XTick = xTick;
ax2.YLim = [0 maxVal];
xlabel( ax2, xLabel )
ylabel( ax2, yLabel2 )
hold all
% build legend
makeFakePlot4Legend( ax2, hoppingData.selData,... 
  hoppingData.selTether, hoppingData.kdVecScaled, ... 
  hoppingData.kHopVec, wantedColors)
[ legcell, legTitle ] = buildkHopLegend( hoppingData.kHopVec );
hl = legend( ax2, legcell );
hl.Interpreter = 'latex';
hl.Title.String = legTitle;

% plot all the nu
if errorbarFlag
  plotDataVsKdErrorBar( ax2, hoppingData.selData, hoppingData.selErrLower, ...
    hoppingData.selErrUpper, hoppingData.selTether, hoppingData.kdVecScaled, ...
    hoppingData.kHopVec, wantedColors)
else
  plotDataVsKd( ax2, hoppingData.selData, hoppingData.selTether, ...
  hoppingData.kdVecScaled, hoppingData.kHopVec, wantedColors)
end
% get rid of extra data
hl.String = legcell;
hl.Position = [0.8195 0.2733 0.1751 0.5740];

function makeFakePlot4Legend( ax, dataKhop, ...
  dataTether, kdVec, kHopVec, wantedColors)
% plot it
numkHop = length( kHopVec );
lineWidth = 2;
lineWidthDash = 3;
% plot tether first
p = plot( ax, kdVec, dataTether );
p.Color = wantedColors(1,:);
p.LineStyle = ':';
p.LineWidth = lineWidthDash;
for ii = 1:numkHop
  l = plot( ax, kdVec, dataKhop(:,ii) );
  l.Color = wantedColors(ii,:);
  l.LineWidth = lineWidth;
end

function plotDataVsKdErrorBar( ax, dataKhop, dataKhopErrLower, ...
  dataKhopErrUpper, dataTether, kdVec, kHopVec, wantedColors)
% plot it
numkHop = length( kHopVec );
lineWidth = 2;
lineWidthDash = 3;
transparentFac = 0.1;
% plot tether first
p = plot( ax, kdVec, dataTether );
p.Color = wantedColors(1,:);
p.LineStyle = ':';
p.LineWidth = lineWidthDash;
for ii = 1:numkHop
  errY = [ dataKhopErrLower(:,ii) dataKhopErrUpper(:,ii) ];
  [l,p] = boundedline(ax, kdVec, dataKhop(:,ii), errY );
  l.Color = wantedColors(ii,:);
  l.LineWidth = lineWidth;
  % update shaded value. make transparent with alpha
  p.FaceColor = wantedColors(ii,:);
  alpha( p, transparentFac)
end

function plotDataVsKd( ax, dataKhop, ...
  dataTether, kdVec, kHopVec, wantedColors)
% plot it
numkHop = length( kHopVec );
lineWidth = 2;
lineWidthDash = 3;
transparentFac = 0.1;
% plot tether first
p = plot( ax, kdVec, dataTether );
p.Color = wantedColors(1,:);
p.LineStyle = ':';
p.LineWidth = lineWidthDash;
for ii = 1:numkHop
  [p] = plot(ax, kdVec, dataKhop(:,ii) );
  p.Color = wantedColors(ii,:);
  p.LineWidth = lineWidth;
end

function [ legcell, legTitle ] = buildkHopLegend( kHop )
% get size
[ numKHop ] = length( kHop );
% legend set-up
legcell = cell( 1, numKHop + 1 );
legTitle = ' $$ k_{ \mathrm{ hop } } \, (\mathrm{ \mu s^{-1} })$$ ';
% build legend
legcell{1} = 'Tether model';
for ii = 1:numKHop
  legcell{ii+1} = [ num2str( kHop(ii) ) ];
end
