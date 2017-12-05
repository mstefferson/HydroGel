% makefigAOutletRes
%
function makefigAOutletRes( fluxSummary )

% Some tunable parameters
xLab = 'Time $$ t \, (ms) $$';
%yLab = 'Selectivity $$ S $$';
yLab = 'Res. Accumulation';
fontSize = 16;
ntMax = 1000;
% scales
tScale = 10; % tau = 0.01, get time in ms 
fidId = randi(1000);
fig = figure(fidId);
clf(fidId);
fig.WindowStyle = 'normal';
fig.Position = [409 218 695 477];
% Plot it
ah1 = gca;
ah1.FontSize = fontSize;
ah1.Box = 'on';
ah1.LineWidth = 1;
axis square
hold all
% set params
kDvec =  1 ./ fluxSummary.paramObj.kA;
% Set up legend
legcell = cell( length(kDvec)+1, 1 );
legcell{1} = 'No binding';
% diffusion
accum2plot = fluxSummary.aOutletVsTDiff;
nt = length( accum2plot );
nt = min( ntMax, nt );
time = tScale * fluxSummary.timeVec(1:nt);
p = plot( ah1, time, accum2plot(1:nt),'k:');
p.LineWidth = 3;
% Loop over plots
for kk = 1:length(kDvec )
  accum2plot = fluxSummary.aOutletVsT{1,1,kk};
  nt = length( accum2plot );
  nt = min( ntMax, nt );
  time = tScale * fluxSummary.timeVec(1:nt);
  p = plot( ah1, time, accum2plot(1:nt) );
  p.LineWidth = 3;
  legcell{kk+1} = num2str( 1e6 * kDvec(kk), '%d' ) ;
end
%fix
xlabel(ah1,xLab);
ylabel(ah1,yLab);
ah1.XLim = [time(1) time(nt)];
% legend
h = legend(ah1,legcell,'location','best');
h.Interpreter = 'latex';
h.Title.String = '$$ K_D \, ( \mathrm{ \mu M } )$$';
h.Position = [0.8288 0.4319 0.1367 0.2342];
end
