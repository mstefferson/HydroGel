% check nu = 0
function numCheckJvsT( plotTogether, saveMe )
nu1Max = 150;
plotId = [1, 2];
fileId =  { ...
  [1, 2], ...
  [1, 2, 3, 4 ] };
plotTitle = {'nu = 0', 'nu = 1'};
nId = [128, 256, 512, 1024; 256, 512, 1024, 2048];
masterfile = {'figJvsTnu0_data','figJvsTnu1_data'};
mypath = 'paperData/';
% store the data
dataStore = cell(1,2);
for ii = 1:length(masterfile)
  masterfileTemp = masterfile{ plotId(ii) };
  numfigsTemp = length( fileId{ii} );
  if plotTogether
    % set up a figure
    fignumber = randi(1000);
    figure( fignumber )
    axStore = zeros( numfigsTemp, 1);
    % build subplot first
    for jj = 1:numfigsTemp
      % get the axes from current fig
      axStore(jj) = subplot( 1, numfigsTemp, jj);
    end
  end
  dataStore{ii} = cell( numfigsTemp, 1 );
  for jj = 1:numfigsTemp
    myfile = [ masterfileTemp num2str(nId(ii,jj),'%d')];
    copyfile( [mypath myfile '.mat'], [mypath masterfileTemp '.mat'] )
    paperPlotMaker( plotId(ii) )
    fig = gcf;
    fig.WindowStyle = 'docked';
    % load to make sure
    load( [mypath myfile] )
    dataStore{ii}{jj} = cell2mat( squeeze(fluxSummary.jVsT )  ) ./...
      (fluxSummary.jDiff);
    nstr = num2str(fluxSummary.paramObj.Nx,'%d');
    title( [ plotTitle{ ii } ' '  ...
      '; n = ' nstr] );
    if plotId(ii) == 2
      ax = gca;
      ax.YLim = [0 nu1Max];
    end
    % put the axes in subplot
    fig = gcf;
    if plotTogether
      h = fig.Children;
      % if first, get legend and axes from children. else, only get axs
      if jj == 1
        hWant = h;
      else
        if strcmp( h(1).Type, 'axes' )
          axId = 1;
        else
          axId = 2;
        end
        hWant = h(axId);
      end
      % Copy it
      hnew = copyobj( hWant, fignumber );
      % find axis again to fix position (put it in subplot)
      if strcmp( hnew(1).Type, 'axes' )
        axId = 1;
      else
        axId = 2;
      end
      hnew(axId).Position = get(axStore(jj),'Position');
      % delete old axes and close unneeded fig
      delete(axStore(jj));
      close(fig)
    else
      if saveMe
        savefig( gcf, myfile );
      end
    end % plot together
  end % jj loop
  if saveMe && plotTogether
    savefig( gcf, [masterfileTemp '_together'] );
  end
end % ii loop
% get residuals
resid = cell( 1, 2);
residNorm = cell( 1, 2);
for ii = 1:length( resid )
  numDelta = length( dataStore{ii} )-1;
  resid{ii} = cell( numDelta, 1 );
  residNorm{ii} = cell( numDelta, 1 );
  dataLargeN = dataStore{ii}{end};
  for jj = 1:numDelta
    resid{ii}{jj} = sum( (dataLargeN - dataStore{ii}{jj}) .^ 2, 2 );
    residNorm{ii}{jj} = sum( ( (dataLargeN - dataStore{ii}{jj}) .^ 2 ) ./ ...
    dataLargeN, 2 );
   fprintf('%s N=%d: res = %f\n', masterfile{ii}, ...
    nId(ii,jj), max( resid{ii}{jj} )  )
  end
end
