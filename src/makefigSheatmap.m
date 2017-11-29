function makefigSheatmap( fluxSummary, diffType )
% scale factor
kdScale = 1e6;
xLabel = 'Dissociation constant $$ K_D \, ( \mathrm{ \mu M } )$$';
if strcmp( diffType, 'lplc' )
  yLabel = ' Contour length $$ l_c \, (\mathrm{ nm })$$ ';
  lScaleActual = 1e-7;
  lScaleWant = 1e-9;
  lScale = (lScaleActual / lScaleWant)^2;
elseif strcmp( diffType, 'nu' )
  yLabel = ' Bound Diffusion $$ D_B/D_F $$ ';
  lScale = 1;
else
  error('Wrong nu str')
end
fontSize = 20;
% set-up figure
fidId = 2;
fig = figure(fidId);
clf(fidId);
% fig.WindowStyle = 'normal';
fig.WindowStyle = 'docked';
fig.Position = [25 171 1133 377];
xTick = kdScale * [1e-8 1e-7 1e-6 1e-5 1e-4 1e-3];
ax = gca;
ax.FontSize = fontSize;
% make subplot
[kdVec, nuVec, jNorm ] = getDataFluxSummary( ...
  fluxSummary, kdScale, lScale );
% make heat map
pcolor( kdVec, nuVec, jNorm )
ch = colorbar;
shading interp
xlabel(xLabel); ylabel(yLabel);
axis('square')
ax.XScale = 'log';
ax.XTick = xTick;
ax.XLim = [ min(xTick) max(xTick) ];
if strcmp( diffType, 'lplc' )
  ax.YScale = 'log';
  logMax = log10( nuVec(end) );
  logMin = log10( nuVec(1) );
  logNum = logMax - logMin + 1;
  ax.YTick = logspace(logMin, logMax,  logNum );
end
ax.CLim = [0 50];
% fix up colorbar
ch.Ticks = 0:10:50;
ch.Label.String = 'Selectivity';

function [kdVec, nuVec, jNorm ] = getDataFluxSummary( ...
  fluxSummary, kdScale, lScale )
% set params
kinParams = fluxSummary.kinParams;
kdVec =  1 ./ kinParams.kinVarInput2;
kdVec = kdScale .* kdVec;
jMax = fluxSummary.jNorm;
nuVec = kinParams.p1Vec;
nuVec = lScale * nuVec;
% get size
[ numNu, ~, numKa ] = size( jMax );
jNorm = zeros( numNu, numKa );

% build data matrix
for ii = 1:numNu
  for jj = 1:numKa
    jNorm(ii,jj) = jMax(ii, 1, jj );
  end
end
