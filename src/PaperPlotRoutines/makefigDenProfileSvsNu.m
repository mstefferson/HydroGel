function makefigDenProfileSvsNu( fluxSummaryDenProfile, fluxSummarySvsNu )
% scale and params
selectivityLims = [0 40];
xScale = 100;
% Some tunable parameters
fontSize = 20;
row = 3;
col = 3;
% set params
% row1: nu = 0 unsaturated
% row2: nu = 1 unsaturated
% row3: nu = 1 saturated
subplotInds = [1 1 1; 2 1 1; 2 1 2];
% % set-up figure
% figId = 3;
figId = randi(1000);
fig = figure(figId);
clf(figId);
fig.WindowStyle = 'normal';
fig.Position = [108 60 1032 638];
axis square
% fake plots
for ii = 1:row*col
  ax = subplot(row,col,ii); plot(1:10);
  ax.FontSize = fontSize;
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
% plot it fig 3
fluxSummary = fluxSummaryDenProfile;
subplotMeDenProfile(subplotInds, xScale, fluxSummary.aConcStdy, fluxSummary.cConcStdy,...
  fluxSummary.paramObj.AL, fluxSummary.paramObj.Btc, fontSize, row, col);
% stack it
pause(1)
stackPlots( fig, col )
% build correct position
cornerStart = axCorner.Position(1:2);
topVal = sum( axTop.Position( [2 4] ) );
rightVal = sum( axRight.Position( [1 3] ) );
width = rightVal - cornerStart(1);
height = topVal - cornerStart(2);
fixedPos = [ cornerStart width height];
% plot it S vs nu
subplotMeFigSvsNu(fluxSummarySvsNu, fontSize, selectivityLims,row, col,...
  fixedPos);

% A and C in the same plot using plot
function hl = subplotMeDenProfile( ...
  subplotinds, xScale, aStdy, cStdy, aScale, cScale, fontSize, row, col )
row1data = cStdy;
row2data = aStdy;
for id = 1:row
  % top row complex
  axTemp = subplot(row,col, 1+(id-1)*col);
  dataC = row1data{ ...
    subplotinds(id,1), subplotinds(id,2), subplotinds(id,3) };
  dataC = dataC ./ cScale;
  dataA = row2data{ ...
    subplotinds(id,1), subplotinds(id,2), subplotinds(id,3) };
  dataA = dataA ./ aScale;
  x = linspace(0, xScale, length(dataA) );
  plot( axTemp, x, dataA, x, dataC );
  axTemp.YLim = [0 1];
  axTemp.YTick = 0:0.2:1;
  ylabel(axTemp, 'Density Profile')
  xlabel(axTemp, 'Position $$x  \, ( \mathrm{ nm } )$$')
  axTemp.FontSize = fontSize;
  axis(axTemp,'square');
end

legcell = {'$$ T(x) / T_L $$', '$$ C(x) / N_t $$'};
hl = legend( axTemp, legcell );
hl.Interpreter = 'latex';
hl.Position = [0.2330 0.8407 0.1040 0.0748];


function subplotMeFigSvsNu( fluxSummary, fontSize, selectivityLims,...
  row, col, fixedPos )

kdScale = 1e6;
% Plot it
filledInds = ( 0:(row-1) ) * col + 1;
subInds = setdiff( 1:row*col, filledInds );
ah1 = subplot( row, col, subInds );
ah1.FontSize = fontSize;
hold all
% set params
kDvec =  1 ./ fluxSummary.kinParams.kinVarInput2;
kDvec = kdScale .* kDvec;
paramObj = fluxSummary.paramObj;
jMax = fluxSummary.jNorm;
nuVec = paramObj.nu;
% get size
numNu = length(nuVec);
numKa = length(kDvec);
jSelect = zeros( numNu, numKa );
% legend set-up
legcell = cell( length(kDvec) , 1 );
legTitle = '$$ K_D \, ( \mathrm{ \mu M } )$$';
% build data matrix
for ii = 1:numKa
  legcell{ii} = num2str( kDvec(ii), '%g' ) ;
  for jj = 1:numNu
    jSelect(jj,ii) = jMax(jj, 1, ii );
  end
end
% plot it
for ii = 1:numKa
  plot( nuVec, jSelect(:,ii) )
end
ah1.XLim = [ min(nuVec) max(nuVec) ];
% axis square
ah1.YLim = selectivityLims;
ah1.Position = fixedPos;
ah1.FontSize = fontSize;
ah1.Box = 'on';
ah1.LineWidth = 1;
xlabel('Bound Diffusion $$ D_B/D_F $$')
ylabel('Selectivity $$ S $$')
hl = legend( legcell, 'location','best');
hl.Interpreter = 'latex';
hl.Title.String = legTitle;
hl.Position = [0.9126 0.4434 0.0802 0.1842];

