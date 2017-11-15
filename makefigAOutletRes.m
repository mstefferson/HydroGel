function plotAOutletRes( fluxSummary )
subplotInds = [1 1 1; 2 1 1; 2 1 2];
% Some tunable parameters
xLab = 'Time $$ t \, (ms) $$';
%yLab = 'Selectivity $$ S $$';
yLab = 'Accumulation';
fidId = randi(1000);
fig = figure(fidId);
clf(fidId);
fig.WindowStyle = 'normal';
fig.Position = [409 218 695 477];
% Plot it
ah1 = gca;
ah1.FontSize = fontSize;
ah1.Box = 'on';
ah1.LineWidth = 1;
axis square
hold all
% set params
kDvec =  1 ./ fluxSummary.paramObj.Ka;
% Set up legend
legcell = cell( length(kDvec)+1, 1 );
legcell{1} = 'No binding';
% diffusion
accum2plot = fluxSummary.

