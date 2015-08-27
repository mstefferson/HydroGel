function [M_All] = ...
    ConcenMovieMaker1D(A_rec, Ass,C_rec, Css,B_rec,Bt,x,TimeRec,nFrames,N,ParamVec)

%%%% Concentration %%%%%


%Initialize the movie structure array
M_All(nFrames)  = struct('cdata',zeros(N,N,3,'int8'), 'colormap',[]);

% Set up figure
figure
% keyboard
MinA = min( min( A_rec ) );
MaxA = max( max( A_rec ) );

MinB = min( min( B_rec ) );
MaxB = max( max( B_rec ) );

MinC = min( min( C_rec ) );
MaxC = max( max( C_rec ) );


MinT = min( min( A_rec + C_rec ) );
MaxT = max( max( A_rec + C_rec ) );

set(gcf,'renderer','zbuffer')
% keyboard
%     keyboard
%Titles
TitlStr1 = sprintf('[A] and [C]');
TitlStr2 = sprintf('[A] + [C]');
TitlStr3 = sprintf('[B]');

for ii = 1:nFrames
    subplot(2,2,1)
%     plot(x, A_rec(ii,:), x, Ass)
    [hAx,hLine1,hLine2] = ...
        plotyy([x x], [A_rec(ii,:) Ass], [x x], [C_rec(ii,:) Css]);
    ylabel(hAx(1),'[A]');ylabel(hAx(2),'[C]');xlabel('x');
%     ,'YLim', [MinA MaxA],'XLabel','x')
    title(TitlStr1)
    set(hAx(1),'YLim', [ MinA MaxA ],'YTick',[MinA MaxA] )
    set(hAx(2),'YLim', [ MinC MaxC ],'YTick',[MinC MaxC] )
%     set(gca,'YLim', [MinA MaxA] )
    
%     keyboard
    subplot(2,2,2)
    plot(x, A_rec(ii,:) + C_rec(ii,:), x, Ass + Css )
    title(TitlStr2)
    xlabel('x');
    set(gca,'YLim', [MinT MaxT] )
    
    subplot(2,2,3)
    plot(x, B_rec(ii,:))
    title(TitlStr3)
    set(gca,'YLim', [MinB MaxB] )
    
    
    subplot(2,2,4)
    cla
    hold off
    ParamStr = sprintf(' t = %.1e \n kon = %.1e \n koff = %.1e \n D_A = %.1e \n F_C = %.1e\n Bt = %.1e', ...
        TimeRec(ii),ParamVec(1), ParamVec(2), ParamVec(3), ParamVec(4),Bt );
    text(0.4,0.4,0.4,ParamStr)
%     keyboard
    M_All(ii) = getframe(gcf); %Store the frame
end

% keyboard
close all