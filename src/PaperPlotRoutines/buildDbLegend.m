function [ legcell, legTitle ] = buildDbLegend( lplcVec, diffType )
% get size
[ numLpLc ] = length( lplcVec );
% legend set-up
legcell = cell( 1, numLpLc );
if strcmp( diffType, 'lplc' )
  legTitle = ' $$ l_c \, (\mathrm{ nm })$$ ';
else
  legTitle = ' $$ D_B / D_F $$ ';
end
% build legend
for ii = 1:numLpLc
  if isinf( lplcVec(ii) )
    legcell{ii} = [ ' $$ \infty $$'  ];
  else
    legcell{ii} = [ num2str( lplcVec(ii) ) ];
  end
end

