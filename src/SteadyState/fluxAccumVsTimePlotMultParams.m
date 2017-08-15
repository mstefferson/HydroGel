% fluxAccumVsTimePlotMultParams( ...
%  fluxMat, accumMat, fluxDiff, accumDiff, timeVec, ...
%  pvec1, pvec2, pvec3, p3name, ah1titl, ah2titl, saveMe, saveStr )
%
% Plot flux and accumulation vs time for various parameter configurations. 
% It plots everything from p3 on a single plotmakes new plots for each 
% combination of elements in p1 and p2 

function fluxAccumVsTimePlotMultParams( ...
  fluxMat, accumMat, fluxDiff, accumDiff, jDiff, timeVec, ...
  pvec1, pvec2, pvec3, p3name, pfixed, pfixedStr, ...
  ah1titl, ah2titl, saveMe, saveStr )
  % Set up legend
  legcell2 = cell( length(pvec3) + 1, 1 );
  legcell2{end} = 'No binding';
  % fixed legend
  legcell1 = [ pfixedStr ' = '  num2str(pfixed) ];
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
        flux2plot = fluxMat{ii,jj,kk} ./ jDiff;
        accum2plot = accumMat{ii,jj,kk};
        nt = length( flux2plot );
        plot( AH1, timeVec(1:nt), flux2plot );
        plot( AH2, timeVec(1:nt), accum2plot );
        legcell2{kk} = [ p3name ' = ' num2str( pvec3(kk) ) ];
      end
      flux2plot = fluxDiff ./ jDiff;
      accum2plot = accumDiff;
      nt = length( flux2plot );
      plot( AH1, timeVec(1:nt), flux2plot );
      plot( AH2, timeVec(1:nt), accum2plot);
      %Axis
      xlabel(AH1,'time'); xlabel(AH2,'time');
      ylabel(AH1,'flux'); ylabel(AH2,'accumultation');
      % Titles
      titstr = [ah1titl num2str( pvec2(jj) )];
      title(AH1,titstr);
      h = legend(AH1,legcell1,'location','best');
      h.Interpreter = 'latex';
      titstr = [ah2titl num2str( pvec1(ii) )];
      title(AH2,titstr);
      h = legend(AH2,legcell2,'location','best');
      h.Interpreter = 'latex';
      % Save stuff
      if saveMe
      saveStr = [saveStr '_' num2str(round(pvec2(jj)))...
        '_' num2str(pvec1(ii)) ];
      savefig( gcf, [saveStr '.fig'] );
      saveas( gcf, [saveStr '.jpg'], 'jpg' );
      end
    end
  end

