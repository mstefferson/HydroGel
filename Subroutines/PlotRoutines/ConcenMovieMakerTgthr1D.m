function [M_All] = ...
    ConcenMovieMakerTgthr1D(A_rec, C_rec,...
    x,TimeRec,nFrames,N,Kon,Koff,Dnl,nu,Bt,KDinv)


%Initialize the movie structure array
M_All(nFrames)  = struct('cdata',zeros(N,N,3,'int8'), 'colormap',[]);

% Set up figure
% h = figure('Position', [100 100 840 630]);
% keyboard

if length(Bt) == 1
    Bt = Bt * ones(1, length(x) );
end

% Set up figure
Fig = figure();
ax1 = subplot(1,2,1);
set(ax1, 'nextplot','replacechildren')
ax2 = subplot(1,2,2);
set(ax2, 'nextplot','replacechildren')
MinT = min( min( A_rec + C_rec ) );
MaxT = max( max( A_rec + C_rec ) );

set(gcf,'renderer','zbuffer')
% keyboard
%     keyboard
%Titles
TitlStr1 = sprintf('[A]+[C]');
TitlStr2 = sprintf('Bt');

for ii = 1:nFrames
    subplot(ax1)
    LinObj = plot(x, [A_rec(:,ii)'; C_rec(:,ii)'; A_rec(:,ii)' + C_rec(:,ii)']  );
    LinObj(1).LineWidth = 2; LinObj(2).LineWidth = 2; LinObj(3).LineWidth = 2;
    title(TitlStr1)
    xlabel('x');ylabel('Concentration');

    set(gca,'YLim', [MinT MaxT] )
    legend('A','C','A+C')
        keyboard

    subplot(ax2)
%     cla
    LinObj = plot(x,Bt);
    LinObj.LineWidth = 2;
%     hold off
    ParamStr = sprintf(...
       ' t = %.1e \n KDinv = %.1e \n nu = %.1e \n beta = %.1e \n Kon = %.1e \n Koff = %.1e \n ', ...
        TimeRec(ii),KDinv,nu,Dnl,Kon, Koff );
    title(TitlStr2)
    xlabel('x');ylabel('Concentration');
%     hold off
    textbp(ParamStr)
%     keyboard
    M_All(ii) = getframe(gcf); %Store the frame
end

% keyboard
% close all