function makefig1( fluxSummary )
% Some tunable parameters
ntMax = 1000;
fontSize = 20;
% set-up figure
fidId = 1;
close(fidId);
figure(fidId);
% Plot it
ah1 = gca;
ah1.FontSize = fontSize;
axis square
hold all
% set params
kDvec =  1 ./ fluxSummary.paramObj.Ka;
% Set up legend
legcell = cell( length(kDvec) + 1, 1 );
legcell{1} = 'No binding';
% diffusion
flux2plot = fluxSummary.jVsTDiff ./ fluxSummary.jDiff;
nt = length( flux2plot );
nt = min( ntMax, nt );
p = plot( ah1, fluxSummary.timeVec(1:nt), flux2plot(1:nt),'k:');
p.LineWidth = 3;
% Loop over plots
for kk = 1:length(kDvec )
  flux2plot = fluxSummary.jVsT{1,1,kk} ./ fluxSummary.jDiff;
  nt = length( flux2plot );
  nt = min( ntMax, nt );
  p = plot( ah1, fluxSummary.timeVec(1:nt), flux2plot(1:nt) );
  p.LineWidth = 3;
  legcell{kk+1} = num2str( 1e6 * kDvec(kk), '%d' ) ;
end
%fix
xlabel(ah1,'time $$ t / \tau $$');
ylabel(ah1,'normalized flux $$ j / j_{Diff} $$');
ah1.XLim = [fluxSummary.timeVec(1) fluxSummary.timeVec(nt)];
% legend
h = legend(ah1,legcell,'location','best');
h.Interpreter = 'latex';
h.Title.String = '$$ K_D (\mu M)$$';
h.Position = [0.7289, 0.3418, 0.2135, 0.4349];
end