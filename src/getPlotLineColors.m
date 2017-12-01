% get colors based on nu/lplc values to indicate value
function wantedColors = getPlotLineColors( plotVec, scaleType )
% set up colors
fac = 1000;
colorArray = viridis( fac+1 );
if strcmp( scaleType, 'log' )
  getInds = round( fac / log10( max(plotVec) ) * log10( plotVec ) )+1;
  getInds( isinf(getInds) ) = fac+1;
elseif strcmp( scaleType, 'linear' )
  getInds = round( fac / max( plotVec ) .* plotVec )+1;
else 
  error('Do not recognize the scale')
end
wantedColors = colorArray( getInds, :);

