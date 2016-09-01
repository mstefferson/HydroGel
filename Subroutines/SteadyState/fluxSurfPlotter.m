% fluxSurfPlotter( dataMat, vec1, vec2, vec3, titstr, saveMe, savestr)
%   Makes a surface plot of dataMat as a function of vec2 and vec 3 for every
%   element in vec 1
%
%
function fluxSurfPlotter( dataMat, vec1, vec2, vec3, xlab, ylab, titstr, saveMe, savestr)

  for i = 1:length(vec1)
    figure()
    % Make the plot
    imagesc( 1:length(vec2), 1:length(vec3), ...
      reshape( dataMat(i,:,:), [length(vec3) length(vec2) ] ) );
    % label
    xlabel( xlab ); ylabel( ylab ); 
    title( [titstr num2str( vec1(i) ) ] );
    % Fix axis
    Ax = gca;
    Ax.YTick = 1:4:length(vec3);
    Ax.YTickLabel = num2cell( round( vec3(1:4:end) ) );
    Ax.YDir = 'normal';
    Ax.XTick = 1: 4: length(vec2) ;
    Ax.XTickLabel = num2cell( round (vec2 (1:4:end) ) );
    colorbar
    axis square
    
    % Save stuff
    if saveMe
      savefig( gcf, [savestr  '_'...
        num2str( vec1(i) ) '.fig'] );
      saveas( gcf, [ savestr '_'...
        num2str( vec1(i) ) ], 'jpg' );
    end
  end




