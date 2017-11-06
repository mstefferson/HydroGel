function makefig4( fluxSummary )
% scale factor
kdScale = 1e6;
% Some tunable parameters
fontSize = 20;
% set-up figure
fidId = 4;
figure(fidId);
clf(fidId);
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
kOffMultVec = paramObj.KoffObj.Inputs{2};
% get size
numKoffMult = paramObj.KoffObj.NumMult;
numKa = length(kDvec);
jSelect = zeros( numKoffMult, numKa );
% legend set-up
legcell = cell( 1, numKoffMult );
legTitle = ' $$ k_{off} $$ mult. ';
% build data matrix
for ii = 1:numKoffMult
  legcell{ii} = [ num2str( kOffMultVec(ii) ) ];
  for jj = 1:numKa
    jSelect(ii,jj) = jMax(1, 1, ii + (jj-1) * numKoffMult );
  end
end
% plot it
for ii = 1:numKoffMult
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

