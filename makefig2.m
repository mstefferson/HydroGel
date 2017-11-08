function makefig2( fluxSummary )
% scale factor
kdScale = 1e6;
lScaleActual = 1e-7;
lScaleWant = 1e-9;
lScaleData = (lScaleActual / lScaleWant)^2;
% Some tunable parameters
fontSize = 20;
% set-up figure
fidId = 2;
fig = figure(fidId);
clf(fidId);
fig.WindowStyle = 'normal';
fig.Position = [644 492 620 486];
% Plot it
ah1 = gca;
ah1.FontSize = fontSize;
axis square
hold all
% set params
kinParams = fluxSummary.kinParams;
kDvec =  1 ./ kinParams.kinVarInput2;
kDvec = kdScale .* kDvec;
jMax = fluxSummary.jNorm;
lplcVec = kinParams.p1Vec;
lplcVec = lScaleData * lplcVec;
% get size
[ numLpLc, ~, numKa ] = size( jMax );
jSelect = zeros( numLpLc, numKa );
% legend set-up
legcell = cell( 1, numLpLc );
legTitle = ' $$ l_c l_p \, (\mathrm{ nm^2 })$$ ';
% build data matrix
for ii = 1:numLpLc
  if isinf( lplcVec(ii) )
    legcell{ii} = [ ' $$ \infty $$'  ];
  else
    legcell{ii} = [ num2str( lplcVec(ii) ) ];
  end
  for jj = 1:numKa
    jSelect(ii,jj) = jMax(ii, 1, jj );
  end
end
% plot it
for ii = 1:numLpLc
  plot( kDvec, jSelect(ii,:) )
end
ax = gca;
ax.XScale = 'log';
ax.XLim = [ min(kDvec) max(kDvec) ];
ax.XTick = kdScale * [ 1e-9 1e-8 1e-7 1e-6 1e-5 1e-4 1e-3];
ax.YLim = [0 50];
axis square
xlabel('Dissociation constant $$ K_D  \, ( \mathrm{ \mu M } ) $$')
ylabel('Selectivity $$ S $$')
h = legend( legcell, 'location','best');
h.Interpreter = 'latex';
h.Title.String = legTitle;
h.Position = [0.8422 0.3879 0.1456 0.3334];
keyboard
end

