function [M_All] = ...
    ConcenMovieMakerTgthr1D(A_rec, C_rec,...
    x,TimeRec,nFrames,N,Kon,Koff,Dnl,nu,Bt,KDinv)


%Initialize the movie structure array
M_All(nFrames)  = struct('cdata',zeros(N,N,3,'int8'), 'colormap',[]);

% Set up figure
% h = figure('Position', [100 100 840 630]);
% keyboard


MinT = min( min( A_rec + C_rec ) );
MaxT = max( max( A_rec + C_rec ) );

set(gcf,'renderer','zbuffer')
% keyboard
%     keyboard
%Titles
TitlStr3 = sprintf('[A]+[C]');

for ii = 1:nFrames
    subplot(1,2,1)
    plot(x, A_rec(:,ii) , x, C_rec(:,ii),x, A_rec(:,ii) + C_rec(:,ii) )
    title(TitlStr3)
    xlabel('x');
    set(gca,'YLim', [MinT MaxT] )
    legend('A','C','A+C')
%         keyboard

    subplot(1,2,2)
    cla
    hold off
   ParamStr = sprintf(...
       ' t = %.1e \n KDinv = %.1e \n nu = %.1e \n beta = %.1e \n Bt = %.1e \n Kon = %.1e \n Koff = %.1e \n ', ...
        TimeRec(ii),KDinv,nu,Dnl,Bt,Kon, Koff );
    text(0.4,0.4,0.4,ParamStr)
%     keyboard
    M_All(ii) = getframe(gcf); %Store the frame
end

% keyboard
% close all