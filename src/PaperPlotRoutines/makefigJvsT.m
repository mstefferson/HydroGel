function makefigJvsT( fluxSummary )
% Some tunable parameters
xLab = 'Time $$ t \, (ms) $$';
yLab = 'Normalized outlet flux $$ J^* $$';
ntMax = 1000;
fontSize = 20;
% scales
tScale = 1e3; % time in seconds, convert to ms
kScale = 1e6;
% set-up figure
fig = figure();
clf();
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
paramTemp = fluxSummary.paramObj;
if isfield(paramTemp,'Ka')
  fluxSummary.paramObj.kA = fluxSummary.paramObj.Ka;
end
%kdVec =  round( kScale * 1 ./ fluxSummary.paramObj.kA );
kdVec =  kScale * 1 ./ fluxSummary.paramObj.kA;
% Set up legend
legcell = cell( length(kdVec)+1, 1 );
% if kD in micro Molar is greater than 1, round to integers
if min( kdVec ) < 1
  legStrFlag = '%.1f';
else
  legStrFlag = '%d';
  kdVec = round( kdVec );
end
legcell{1} = 'No binding';
% diffusion
flux2plot = fluxSummary.jVsTDiff ./ fluxSummary.jDiff;
nt = length( flux2plot );
nt = min( ntMax, nt );
time = tScale * fluxSummary.timeVec(1:nt);
p = plot( ah1, time, flux2plot(1:nt),'k:');
p.LineWidth = 3;
% set up colors
wantedColors = getPlotLineColors( kdVec, 'log', 'pmkmp');
% Loop over plots
for kk = 1:length(kdVec )
  flux2plot = fluxSummary.jVsT{1,1,kk} ./ fluxSummary.jDiff;
  nt = length( flux2plot );
  nt = min( ntMax, nt );
  time = tScale * fluxSummary.timeVec(1:nt);
  p = plot( ah1, time, flux2plot(1:nt) );
  p.LineWidth = 3;
  p.Color = wantedColors(kk,:);
  legcell{kk+1} = num2str( kdVec(kk), legStrFlag ) ;
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
