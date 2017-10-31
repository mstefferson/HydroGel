%%
function lorenTalkFig
out = fluxODE(1,1,0,'20171031_LorenTalk','initParamsLorensTalk20171031');
x = linspace(0,1,out.paramObj.Nx );
[ind1max, ind2max, ind3max] = size( out.AconcStdy );
subplotInds = zeros( 3, 3);
%% axis properties
sameAxis = 0;
if sameAxis 
  maxYLimVal = 6e-6;
else
  maxYLimVal = 0;
end
%% nu = 0 unsaturated
figure()
ax = gca;
ind1 = 1;
ind2 = 1;
ind3 = 1;
ind1 = min(ind1,ind1max); ind2 = min(ind2,ind2max); ind3 = min(ind3,ind3max);
subplotInds(1,:) = [ind1, ind2, ind3];
plotMe( ax, ind1, ind2, ind3, x, out.AconcStdy, out.CconcStdy, 1, maxYLimVal )
%% nu = 1 unsaturated
figure()
ax = gca;
ind1 = 2;
ind2 = 1;
ind3 = 1;
ind1 = min(ind1,ind1max); ind2 = min(ind2,ind2max); ind3 = min(ind3,ind3max);
subplotInds(2,:) = [ind1, ind2, ind3];
plotMe( ax, ind1, ind2, ind3, x, out.AconcStdy, out.CconcStdy, 1, maxYLimVal )
%% nu = 1 saturated
figure()
ax = gca;
ind1 = 2;
ind2 = 1;
ind3 = 2;
ind1 = min(ind1,ind1max); ind2 = min(ind2,ind2max); ind3 = min(ind3,ind3max);
subplotInds(3,:) = [ind1, ind2, ind3];
plotMe( ax, ind1, ind2, ind3, x, out.AconcStdy, out.CconcStdy, 1, maxYLimVal )
%% subplot them all
subplotMe(subplotInds, x, out.AconcStdy, out.CconcStdy, maxYLimVal )

function plotMe( ax, ind1, ind2, ind3, x, aStdy, cStdy, legendF, maxYLimVal )
ax.NextPlot = 'add';
ylabel('Concentration')
xlabel('$$x$$')
vec1 = aStdy{ind1,ind2,ind3};
vec2 = cStdy{ind1,ind2,ind3};
maxVal = max( [max( vec1(:) + vec2(:) ) maxYLimVal ] );
plot( ax, x, vec1 );
plot( ax, x, vec2 );
plot( ax, x, vec1 + vec2 );
ax.YLim = [0 maxVal];
if legendF
  legcell = {'$$ T $$','$$ C $$','$$ T+C $$'};
  hl = legend(legcell,'location','best');
  hl.Interpreter = 'latex';
end
ax.NextPlot = 'replace';

function subplotMe( subplotinds, x, aStdy, cStdy, maxYVal )
figure()
ax1 = subplot(1,3,1);
plotMe( ax1, subplotinds(1,1), subplotinds(1,2), subplotinds(1,3),...
   x, aStdy, cStdy, 0, maxYVal )
ax2 = subplot(1,3,2);
plotMe( ax2, subplotinds(2,1), subplotinds(2,2), subplotinds(2,3),...
   x, aStdy, cStdy, 0, maxYVal )
ax3 = subplot(1,3,3);
plotMe( ax3,subplotinds(3,1), subplotinds(3,2), subplotinds(3,3),...
   x, aStdy, cStdy, 1, maxYVal )
