%% test stack
row = 3;
col = 3;

fig = figure();
for ii = 1:row*col
  subplot(row,col,ii)
  plot(1:10)
  xlabel('blah');ylabel('blah');
  % corner
  if ii == row*col - 1
    axCorner = gca;
  end
  % right
  if ii == row*col
    axRight = gca;
  end
  % top
  if ii == 2
    axTop  = gca;
  end
end
pause(1)
stackPlots( fig, col )
cornerStart = axCorner.Position(1:2);
topVal = sum( axTop.Position( [2 4] ) );
rightVal = sum( axRight.Position( [1 3] ) );

width = rightVal - cornerStart(1);
height = topVal - cornerStart(2);
fixedPos = [ cornerStart width height];
filledInds = ( 0:(row-1) ) * col + 1;
subInds = setdiff( 1:row*col, filledInds );
axFill = subplot( row, col, subInds );
plot(1:10)
axFill.Position = fixedPos;
xlabel( 'blah' )
ylabel( 'blah' )
