% check selectivity plots
function numCheckS( plotTogether, saveMe )
fileId =  { ...
  [1, 2, 3], ...
  [1, 2, 3],...
  [1, 2, 3],...
  [1, 2, 3],...
  [1, 2, 3] };
plotId = [3 5 9 10 11];
plotTitle = {'$$2^{16}$$', '$$2^{17}$$', ...
  '$$2^{18}$$'};
nId = [16,17,18];
masterfile = {'figSvsKdVaryNu_data','figSvsKdVaryLplc_data',...
  'figSvsKdVaryNuLinearNumeric_data', 'figSvsNu_data', ...
  'figSvsNuLinearNumeric_data'};
dirpath = {'draft12_nBind800_n16/', 'draft11_nBind800_n17/', ...
  'draft13_nBind800_n18/'};
mypath = 'paperData/';
% store it
dataStore = cell(  length( nId ), numfigsTemp );

for ii = 1:length( masterfile )
  myfile = masterfile{ii};
  disp( myfile )
  numfigsTemp = length( fileId{ii} );
  % set up a figure
  if plotTogether
    fignumber = randi(1000);
    figure( fignumber )
    axStore = zeros( 1 , numfigsTemp );
  end
  % build subplot first
  for jj = 1:numfigsTemp
    % get the axes from current fig
    axStore(jj) = subplot( 1, numfigsTemp, jj);
  end
  for jj = 1:numfigsTemp
    fprintf('Looking for file  %s in path %s\n',...
      myfile, dirpath{jj})
    fullpathSource = [mypath dirpath{jj} myfile];
    fullpathDest = [mypath myfile];
    copyfile( [fullpathSource '.mat'], [fullpathDest '.mat'] )
    paperPlotMaker( plotId(ii) )
    % load to make sure
    load( fullpathDest )
    % store it
    dataStore{ii,jj} = squeeze( fluxSummary.jNorm );
    log2str = num2str(log2(fluxSummary.paramObj.Nx),'%d');
    fprintf('File %s .....log2(N) = %s\n', fullpathDest, log2str )
    title( [ plotTitle{ fileId{ii}(jj) } ' '  ...
      '; log2(n) = ' log2str] );
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
      fig.WindowStyle = 'docked';
      if saveMe
        savename = [ myfile '_' num2str( nId( fileId{ii}(jj) ), '%d') ];
        savefig( gcf, savename )
      end
    end
  end %% loop jj
  if saveMe && plotTogether
    savename = [ myfile '_together' ];
    savefig( gcf, savename )
  end
end % loop ii
% get residuals for each curve and dataset
numRes = length( masterfile );
numDelta = length( nId ) - 1;
resid = cell( numRes, numDelta );
residNorm = cell( numRes, numDelta );
for ii = 1:numRes
  dataLargeN = dataStore{ii,end};
  for jj = 1:numDelta
    [~, dim2sum] = max( size( dataStore{ii,jj} ) );
    resid{ii,jj} = sum( (dataLargeN - dataStore{ii,jj}) .^ 2, dim2sum );
    residNorm{ii,jj} = sum( ( (dataLargeN - dataStore{ii,jj}) .^ 2 ) ./ ...
    dataLargeN, dim2sum );
  fprintf('%s N=%d: res = %f\n', masterfile{ii}, ...
    nId(jj), max( residNorm{ii,jj} )  )
  end
end
