% function concSteadPlotMultParams( Amat, Cmat, fluxDiff, accumDiff, x, ...
%  pvec1, pvec2, pvec3, p1name, p2name, p3name, saveMe, saveStr )
%
% Plot steady state concentration for various parameter configurations. 
% It plots everything from p3 on a single plotmakes new plots for each 

function concSteadyPlotMultParams( Amat, Cmat, x, ...
  pvec1, pvec2, pvec3, p1name, p2name, p3name, saveMe, saveStr )

  % Set up legend
  legcell = cell( length(pvec3) , 1 );

  % Find the size of the TimeVec
  [xr, yr] =  size(x);

  % Reused titles
  ax1tit = 'A vs x at steady state: ';
  ax2tit = 'C vs x at steady state: ';
  ax3tit = 'A + C vs x at steady state: ';

  % Loop over plots
  for ii = 1:length(pvec1)
    for jj = 1:length(pvec2)
      % Str to add to titls
      ttlAdd = [ p1name ' = ' num2str( pvec1(ii) ) ';'...
        ' ' p2name ' = ' num2str( pvec2(jj) ) ];

      % Set-up fig
      figure();
      ax1 = subplot(3,1,1);
      hold(ax1,'on');
      ax1.XLabel.String = 'x';
      ax1.YLabel.String = 'A';
      ax1.Title.String = [ ax1tit ttlAdd ];
      ax1.YLim = [ Amat(1,1,1,end) Amat(1,1,1,1)  ];
      ax2 = subplot(3,1,2);
      hold(ax2,'on');
      ax2.XLabel.String = 'x';
      ax2.YLabel.String = 'C';
      ax2.Title.String = [ ax2tit ttlAdd ];
      ax3 = subplot(3,1,3);
      hold(ax3,'on');
      ax3.XLabel.String = 'x';
      ax3.YLabel.String = 'A + C';
      ax3.Title.String = [ ax3tit ttlAdd ];
      
      % Plot it
      for kk = 1:length(pvec3)
        plot( ax1, x, reshape( Amat(ii,jj,kk,:), [xr yr] ) ); 
        plot( ax2, x, reshape( Cmat(ii,jj,kk,:), [xr yr] ) ); 
        plot( ax3, x, reshape( Amat(ii,jj,kk,:) + Cmat(ii,jj,kk,:) , [xr yr] ) ); 
        legcell{kk} = [ p3name ' = ' num2str( pvec3(kk) ) ];
      end
      legend( ax1, legcell ); legend( ax2, legcell ); legend( ax3, legcell );
      
      if saveMe
      % Save stuff
      saveStr = [saveStr '_' num2str(round(pvec2(jj)))...
        '_' num2str(pvec1(ii)) ];
      savefig( gcf, [saveStr '.fig'] );
      saveas( gcf, saveStr, 'jpg' );
      end
    end
  end

