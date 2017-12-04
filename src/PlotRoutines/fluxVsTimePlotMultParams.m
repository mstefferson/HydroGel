% fluxAccumVsTimePlotMultParams( ...
%  fluxMat, accumMat, fluxDiff, accumDiff, timeVec, ...
%  pvec1, pvec2, pvec3, p3name, ah1titl, ah2titl, saveMe, saveStr )
%
% Plot flux and accumulation vs time for various parameter configurations. 
% It plots everything from p3 on a single plotmakes new plots for each 
% combination of elements in p1 and p2 

function fluxVsTimePlotMultParams( ...
  fluxMat, fluxDiff, jDiff, timeVec, ...
  pvec1, pvec2, pvec3, p3name, pfixed, pfixedStr, ...
  ah1titl1, ah1titl2, saveMe, saveStr )
  % Set up legend
  legcell = cell( length(pvec3) + 1, 1 );
  legcell{end} = 'No binding';
  % Loop over plots
  for ii = 1:length(pvec1)
    for jj = 1:length(pvec2)
      figure();
      % Plot it
      AH1 = gca;
      axis square
      hold all
      for kk = 1:length(pvec3)
        flux2plot = fluxMat{ii,jj,kk} ./ jDiff;
        nt = length( flux2plot ); 
        p = plot( AH1, timeVec(1:nt), flux2plot );
        p.LineWidth = 3;
        legcell{kk} = [ p3name ' = ' num2str( pvec3(kk) ) ];
      end
      % diffusion
      flux2plot = fluxDiff ./ jDiff;
      nt = length( flux2plot ); 
      p = plot( AH1, timeVec(1:nt), flux2plot);
      p.LineWidth =3;
      %Axis
      xlabel(AH1,'time'); 
      ylabel(AH1,'flux'); 
      % Titles
      titstr = [ah1titl1 num2str( pvec2(jj) ) ' '...
        ah1titl2 num2str( pvec1(ii) ) ' '...
        pfixedStr ' = '  num2str(pfixed) ];
      title(AH1,titstr);
      h = legend(AH1,legcell,'location','best');
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

