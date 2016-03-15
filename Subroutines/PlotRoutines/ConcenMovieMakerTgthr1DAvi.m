function  ConcenMovieMakerTgthr1DAvi(A_rec, C_rec,...
    x,TimeRec,nFrames,Kon,Koff,Dnl,nu,Bt,KDinv)


% Video Write stuff
Mov = VideoWriter('HydroGRD.avi');
Mov.FrameRate = 4;
open(Mov);


% Set up figure
% Set up figure
Fig = figure();
set(Fig, 'WindowStyle', 'normal');
PosVec = [680 558 1200 800];
Fig.Position = PosVec;

ax1 = subplot(1,2,1);
set(ax1, 'nextplot','replacechildren')
ax2 = subplot(1,2,2);
set(ax2, 'nextplot','replacechildren')
MinT = min( min( A_rec + C_rec ) );
MaxT = max( max( A_rec + C_rec ) );

set(Fig,'renderer','zbuffer')
% keyboard
%     kedyboard
%Titles
TitlStr1 = sprintf('[A]+[C]');
TitlStr2 = sprintf('Bt');

% If Bt is constant, have it a vec for plotting
if length(Bt) == 1
    Bt = Bt * ones(1, length(x) );
end

for ii = 1:nFrames
    subplot(ax1)
    LinObj = plot(x, [A_rec(:,ii)'; C_rec(:,ii)'; A_rec(:,ii)' + C_rec(:,ii)']  );
    LinObj(1).LineWidth = 2; LinObj(2).LineWidth = 2; LinObj(3).LineWidth = 2;
    title(TitlStr1)
    xlabel('x');ylabel('Concentration');
    set(gca,'YLim', [MinT MaxT] )
    legend('A','C','A+C')
%         keyboard

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
    textbp(ParamStr)
%     keyboard
    Fr = getframe(Fig,[0 0 PosVec(3) PosVec(4)]);
    writeVideo(Mov,Fr);
    
end

% keyboard
% close all
close(Mov)
