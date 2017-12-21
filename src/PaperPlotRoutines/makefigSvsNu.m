function makefigSvsNu( fluxSummary )
% scale factor
kdScale = 1e6;
% Some tunable parameters
fontSize = 20;
% set-up figure
fig = figure();
clf(fig);
fig.WindowStyle = 'normal';
fig.Position = [64 209 560 420];
% Plot it
ah1 = gca;
ah1.FontSize = fontSize;
axis square
hold all
% set params
kDvec =  1 ./ fluxSummary.kinParams.kinVarInput2;
kDvec = kdScale .* kDvec;
paramObj = fluxSummary.paramObj;
jMax = fluxSummary.jNorm;
nuVec = paramObj.DbParam{2};
% get size
numNu = length(nuVec);
numKa = length(kDvec);
jSelect = zeros( numNu, numKa );
% legend set-up
legcell = cell( length(kDvec) , 1 );
legTitle = '$$ K_D \, ( \mathrm{ \mu M } )$$';
% set-up colors
wantedColors = getPlotLineColors( kDvec, 'log' );
% build data matrix
for ii = 1:numKa
  legcell{ii} = num2str( kDvec(ii), '%g' ) ;
  for jj = 1:numNu
    jSelect(jj,ii) = jMax(jj, 1, ii );
  end
end
% plot it
for ii = 1:numKa
  p = plot( nuVec, jSelect(:,ii) );
  p.Color = wantedColors(ii,:);
end
ax = gca;
ax.XLim = [ min(nuVec) max(nuVec) ];
axis square
ax.YLim = [0 50];
xlabel('Bound Diffusion $$ D_B/D_F $$')
ylabel('Selectivity $$ S $$')
hl = legend( legcell, 'location','best');
hl.Interpreter = 'latex';
hl.Title.String = legTitle;
hl.Position = [0.8346 0.3953 0.1416 0.2798];
end

