% function concSteadPlotMultParams( Amat, Cmat, fluxDiff, accumDiff, x, ...
%  pvec1, pvec2, pvec3, p1name, p2name, p3name, saveMe, saveStr )
%
% Plot steady state concentration for various parameter configurations.
% It plots everything from p3 on a single plotmakes new plots for each

function concSteadyPlotMultParams( Amat, Cmat, x, ...
  pvec1, pvec2, pvec3, p1name, p2name, p3name, pfixed,...
  pfixedstr, saveMe, saveStr )
% Set up legend
legcell = cell( length(pvec3) , 1 );
% Find the size of the TimeVec
[xr, yr] =  size(x);
pFixedStrFull = [ pfixedstr ' = ' num2str(pfixed) ];
% set up subplot
numRows = 1;
numCols = 3;
% Loop over plots
for ii = 1:length(pvec1)
  for jj = 1:length(pvec2)
    % Strs
    pStrTemp = [  p1name ' = ' num2str( pvec1(ii) ) ' '...
      p2name ' = ' num2str( pvec2(jj) ) ];
    pAllStr = [ pFixedStrFull ' ' pStrTemp];
    % Set-up fig
    fig = figure();
    ax1 = subplot(numRows,numCols,1);
    hold(ax1,'on');
    ax1.XLabel.String = '$$ x $$';
    ax1.YLabel.String = '$$ A $$';
    ax1.YLim = [ Amat(1,1,1,end) Amat(1,1,1,1)  ];
    ax2 = subplot(numRows,numCols,2);
    hold(ax2,'on');
    ax2.XLabel.String = '$$ x $$';
    ax2.YLabel.String = '$$ C $$';
    ax3 = subplot(numRows,numCols,3);
    hold(ax3,'on');
    ax3.XLabel.String = '$$ x $$';
    ax3.YLabel.String = '$$ A + C $$';
    % Plot it
    for kk = 1:length(pvec3)
      plot( ax1, x, reshape( Amat(ii,jj,kk,:), [xr yr] ) );
      plot( ax2, x, reshape( Cmat(ii,jj,kk,:), [xr yr] ) );
      plot( ax3, x, reshape( Amat(ii,jj,kk,:) + Cmat(ii,jj,kk,:) , [xr yr] ) );
      legcell{kk} = [ p3name ' = ' num2str( pvec3(kk), '%.0e' ) ];
    end
    axV = [ax1 ax2 ax3];
    for ll = 3
      legH = legend(axV(ll), legcell, 'location', 'best');
      legH.Interpreter = 'latex';
    end
    % print parameters 
    fprintf('Fig %d: %s\n\n', fig.Number, pAllStr );
    % Save stuff
    if saveMe
      saveStr = [saveStr '_' num2str(round(pvec2(jj)))...
        '_' num2str(pvec1(ii)) ];
      savefig( gcf, [saveStr '.fig'] );
      saveas( gcf, [saveStr '.jpg'], 'jpg' );
    end
  end
end

