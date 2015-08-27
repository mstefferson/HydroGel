function [M_All] = ...
    JustConcenMovieMakerNd1D(A_rec, C_rec,Bt,...
    x,TimeRec,nFrames,Nt,ParamVec)

%%%% Concentration %%%%%


%Initialize the movie structure array
M_All(nFrames)  = struct('cdata',zeros(Nt,Nt,3,'int8'), 'colormap',[]);

% Set up figure
h = figure('Position', [100 100 840 630]);
% keyboard
MaxA = max( max( max( A_rec ), 0.00001 ) );
MinA = min( min( A_rec ) );

MaxC = max( max( max( C_rec ), 0.00001 ) );
MinC = min( min( C_rec ) );

MaxT = max( max( A_rec + C_rec ) );
MinT = min( min( A_rec + C_rec ) );

set(gcf,'renderer','zbuffer')
% keyboard
%     keyboard
%Titles
TitlStr1 = sprintf('[A]');
TitlStr2 = sprintf('[C]');
TitlStr3 = sprintf('[A] + [C]');



for ii = 1:nFrames
    
    %     plot(x, A_rec(ii,:), x, Ass)
%     keyboard
    subplot(2,2,1)
    plot(x, A_rec(ii,:));
    ylabel('[A]');xlabel('x');
    set(gca,'YLim', [ MinA MaxA ],'YTick',[MinA MaxA] )
    title(TitlStr1)
    %     axis(hAx(2),[x(1) x(end) MinJA MaxJA])
    %     ,'YLim', [MinA MaxA],'XLabel','x')
    
    %     set(gca,'YLim', [MinA MaxA] )
    subplot(2,2,2)
    plot(x, C_rec(ii,:));
    ylabel('[C]');xlabel('x');
    set(gca,'YLim', [ MinC MaxC ],'YTick',[MinC MaxC] )
    title(TitlStr2)
    
    subplot(2,2,3)
    plot(x, A_rec(ii,:) + C_rec(ii,:));
    ylabel('[A]+ [C]');xlabel('x');
    set(gca,'YLim', [ MinT MaxT ],'YTick',[MinT MaxT] )
    title(TitlStr3)
    
    %     set(gca,'YLim', [MinT MaxT] )
    
    subplot(2,2,4)
    cla
    hold off
    ParamStr = sprintf(' t = %.1e \n KD = %.1e \n nu = %.1e \n Bt = %.1e \n', ...
        TimeRec(ii),ParamVec(1), ParamVec(2),Bt );
    text(0.4,0.4,0.4,ParamStr)
    %     keyboard
    M_All(ii) = getframe(gcf); %Store the frame
end

% keyboard
close all