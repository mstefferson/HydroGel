% fluxAccumVsTimePlotMultParams( ...
%  fluxMat, accumMat, fluxDiff, accumDiff, timeVec, ...
%  pvec1, pvec2, pvec3, p3name, ah1titl, ah2titl, saveMe, saveStr )
%
% Plot flux and accumulation vs time for various parameter configurations. 
% It plots everything from p3 on a single plotmakes new plots for each 
% combination of elements in p1 and p2 

function fluxAccumVsTimePlotMultParams( ...
  fluxMat, accumMat, fluxDiff, accumDiff, timeVec, ...
  pvec1, pvec2, pvec3, p3name, ah1titl, ah2titl, saveMe, saveStr )

  % Set up legend
  legcell = cell( length(pvec3) + 1, 1 );
  legcell{end} = 'No binding';

  % Find the size of the TimeVec
  [Tr, Tc] =  size(timeVec);

  % Loop over plots
  for ii = 1:length(pvec1)
    for jj = 1:length(pvec2)
      figure();
      % Plot it
      AH1 = subplot(1,2,1);
      axis square
      hold all
      AH2 = subplot(1,2,2);
      axis square
      hold all
      for kk = 1:length(pvec3)
        plot( AH1, timeVec, reshape( fluxMat(ii,jj,kk,:), [Tr Tc] ) );
        plot( AH2, timeVec, reshape( accumMat(ii,jj,kk,:), [Tr Tc] ) );
        legcell{kk} = [ p3name ' = ' num2str( pvec3(kk) ) ];
      end
      plot( AH1, timeVec, fluxDiff);
      plot( AH2, timeVec, accumDiff);
      %Axis
      xlabel(AH1,'time'); xlabel(AH2,'time');
      ylabel(AH1,'flux'); ylabel(AH2,'accumultation');
      %   AH1.YLim = [ 0 1e-3 ]; AH2.YLim = [ 0 5e-4 ];
      % Titles
      titstr = [ah1titl num2str( pvec2(jj) )];
      title(AH1,titstr);
      titstr = [ah2titl num2str( pvec1(ii) )];
      title(AH2,titstr);
      h = legend(AH2,legcell,'location','best');
      h.Position(1:2) = [0.525 0.35];
      
      if saveMe
      % Save stuff
      saveStr = [saveStr '_' num2str(round(pvec2(jj)))...
        '_' num2str(pvec1(ii)) ];
      savefig( gcf, [saveStr '.fig'] );
      saveas( gcf, saveStr, 'jpg' );
      end
    end
  end

