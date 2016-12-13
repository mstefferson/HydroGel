
function slicePlotter( data, p1, p2, p1str, p2str, ...
  ttlstr, ylab, saveMe, saveStr )

if nargin < 8
  saveMe = 0;
  saveStr = '';
end

% Set up figure
figure()

ax1 = subplot(2,2,1);
ax1.XLabel.String = p1str;
ax1.YLabel.String = ylab;
ax1.XLim = [ p1(1) p1(end) ];
hold(ax1,'on');
title(ttlstr);

ax2 = subplot(2,2,2);
ax2.XLabel.String = p2str;
ax2.YLabel.String = ylab;
ax2.XLim = [ p2(1) p2(end) ];
hold(ax2,'on');

ax3 = subplot(2,2,3);
ax3.XLabel.String = p1str;
ax3.YLabel.String = ylab;
ax3.XScale = 'log';
hold(ax3,'on');

ax4 = subplot(2,2,4);
ax4.XLabel.String = p2str;
ax4.YLabel.String = ylab;
ax4.XScale = 'log';
hold(ax4,'on');

% legend
legcellp2 = cell( length(p2) , 1 );
legcellp1 = cell( length(p1) , 1 );

% vs p1
for ii=1:length(p2)
  plottemp = reshape( data(1,:,ii) , [ 1 length(p1) ] );
  % Plot
  plot( ax1, p1,  plottemp)
  % Log
  loglog( ax3, p1, plottemp )
  % Legend
  legcellp2{ii} = [ p2str ' = ' num2str( p2(ii) ) ];
end

% vs p2
for ii=1:length(p1)
  plottemp = reshape( data(1,ii,:) , [ 1 length(p2) ] );
  % Plot
  plot( ax2, p2,  plottemp)
  % Log
  loglog( ax4, p2, plottemp )
  % Legend
  legcellp1{ii} = [ p1str ' = ' num2str( p1(ii) ) ];
end

legend( ax1, legcellp2, 'location', 'best' )
legend( ax2, legcellp1, 'location', 'best' )
legend( ax3, legcellp2, 'location', 'best' )
legend( ax4, legcellp1, 'location', 'best' )

% Save stuff
if saveMe
  savefig( gcf, [saveStr  '.fig'] );
  saveas( gcf, 'temp', 'jpg')
  movefile( 'temp.jpg',  [saveStr '.jpg'] )
end
