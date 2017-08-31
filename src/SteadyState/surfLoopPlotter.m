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
  n2t = n2;
  n3t = n3 ;
  temp = reshape( dataMat(ii,:,:), [n2 n3] );
  if n2  == 1 || n3 == 1
    imagesc(temp);
  else
    pcolor( 1:n3t, 1:n2t, temp);
    shading('interp')
  end
  % label
  xlabel( xlab ); ylabel( ylab );
  title( [titstr num2str( vec1(ii) ) ] );
  % Fix axis
  Ax = gca;
  Ax.YTick = 1 : tickAmnt : length(vec2);
  Ax.YTickLabel = num2cell(  vec2(1:tickAmnt:end)  );
  Ax.YDir = 'normal';
  Ax.XTick = 1 : tickAmnt : length(vec3) ;
  Ax.XTickLabel = num2cell( vec3 (1:tickAmnt:end) );
  colorbar
  axis square
  % Save stuff
  if saveMe
    savefig( gcf, [savestr  '_' num2str( vec1(ii) ) '.fig'] );
    saveas( gcf, 'temp', 'jpg')
    movefile( 'temp.jpg',  [savestr '_' num2str( vec1(ii) ) '.jpg'] )
  end

end