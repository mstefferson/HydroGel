function makefig2( fluxSummary )
% scale factor
kdScale = 1e6;
lScaleActual = 1e-7;
lScaleWant = 1e-9;
lScaleData = (1e-7 / 1e-9)^2;
% Some tunable parameters
fontSize = 20;
% set-up figure
fidId = 2;
figure(fidId);
clf(fidId);
% Plot it
ah1 = gca;
ah1.FontSize = fontSize;
axis square
hold all
% set params
kDvec =  1 ./ fluxSummary.paramObj.Ka;
kDvec = kdScale .* kDvec;
paramObj = fluxSummary.paramObj;
jMax = fluxSummary.jNorm;
lplcVec = paramObj.nu;
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
ax.YLim = [0 40];
xlabel('$$ K_D  \, ( \mathrm{ \mu M } ) $$')
ylabel('Selectivity ($$ j / j_{Diff} $$)')
h = legend( legcell, 'location','best');
h.Interpreter = 'latex';
h.Title.String = legTitle;
end

