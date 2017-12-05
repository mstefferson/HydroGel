function makefigScatterSelectivity( selectivity )
% scale factor
kdScale = 1e6;
% Some tunable parameters
fontSize = 20;
% set-up figure
fidId = 4;
figure(fidId);
clf(fidId);
% Plot it
ah1 = gca;
ah1.FontSize = fontSize;
axis square
hold all
% set params
paramInput = selectivity.paramInpt;
kdVec =  ( paramInput(:,4) .* paramInput(:,3) ) ./ paramInput(:,2);
kdVec = kdScale * kdVec;
nuVec = paramInput(:,1);
s = selectivity.val;
inds = 1:length(s);
%
row = 1;
col = 3;
%
str = 'nu';
subplot(row,col,1)
scatter( inds, nuVec )
title(str)
ylabel(str)
xlabel('runInd')
%
str = 'kD';
subplot(row,col,2)
scatter( inds, kdVec )
title('kD (mu M)')
ylabel(str)
xlabel('runInd')
ax = gca;
ax.YScale = 'log';
ax.YLim = [min(kdVec) max(kdVec)];
%
str = 'S';
subplot(row,col,3)
scatter( inds, s )
title('Selectivity')
ylabel(str)
xlabel('runInd')

