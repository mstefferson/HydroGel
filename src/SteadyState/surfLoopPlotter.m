% surfLoopPlotter( dataMat, vec1, vec2, vec3, titstr, saveMe, savestr)
%   Makes a surface plot of dataMat as a function of vec2 and vec 3 for every
%   element in vec 1


function surfLoopPlotter( dataMat, vec1, vec2, vec3, xlab, ylab, ...
  titstr, saveMe, savestr)

if nargin < 8
  saveMe = 0;
end

tickAmnt = 2;
for ii = 1:length(vec1)
  figure()
  % Make the plot
  n2 = length(vec2);
  n3 = length(vec3);
  n2t = n2  ;
  n3t = n3 ;
  temp = zeros( n2t, n3t );
  temp( 1:n2, 1:n3 ) = reshape( dataMat(ii,:,:), [n2 n3] );
  temp( n2t, 1:n3 ) = temp(n2,1:n3);
  temp( 1:n2, n3t ) = temp(1:n2,n3);
  temp( n2t, n3t ) = temp(n2,n3);
  pcolor( 1:n3t, 1:n2t, temp);
  shading('interp')
  xlab2 = ylab;
  ylab2 = xlab;
  xlab = xlab2 ;
  ylab = ylab2;
  % label
  xlabel( xlab ); ylabel( ylab );
  title( [titstr num2str( vec1(ii) ) ] );
  % Fix axis
  Ax = gca;
  Ax.YTick = 1 : tickAmnt : length(vec3);
%   Ax.YTickLabel = num2cell( round( vec3(1:tickAmnt:end) ) );
  Ax.YTickLabel = num2cell(  vec3(1:tickAmnt:end)  );
  Ax.YDir = 'normal';
  Ax.XTick = 1 : tickAmnt : length(vec2) ;
%   Ax.XTickLabel = num2cell( round (vec2 (1:tickAmnt:end) ) );
  Ax.XTickLabel = num2cell( vec2 (1:tickAmnt:end) );
  colorbar
  axis square

  % Save stuff
  if saveMe
    savefig( gcf, [savestr  '_' num2str( vec1(ii) ) '.fig'] );
    saveas( gcf, 'temp', 'jpg')
    movefile( 'temp.jpg',  [savestr '_' num2str( vec1(ii) ) '.jpg'] )
  end
end




