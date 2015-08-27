function [M_All] = ...
    ConcenFluxMovieMaker1D(A_rec, Ass,C_rec, Css,JA_rec,JC_rec,JT_rec,Bt,...
                                 x,TimeRec,nFrames,N,ParamVec)

%%%% Concentration %%%%%


%Initialize the movie structure array
M_All(nFrames)  = struct('cdata',zeros(N,N,3,'int8'), 'colormap',[]);

% Set up figure
figure
% keyboard
MaxA = max( max( A_rec ) );
MinA = min( min( A_rec ) );

MinJA = min( min( JA_rec ) );
MaxJA = max( max( JA_rec ) );

MaxC = max( max( C_rec ) );
MinC = min( min( C_rec ) );

MinJC = min( min( JC_rec ) );
MaxJC = max( max( JC_rec ) );

if MaxJC == 0
    MaxJC = 0.0001;  
end

MaxT = max( max( A_rec + C_rec ) );
MinT = min( min( A_rec + C_rec ) );

MinJT = min( min( JT_rec ) );
MaxJT = max( max( JT_rec) );

set(gcf,'renderer','zbuffer')
% keyboard
%     keyboard
%Titles
TitlStr1 = sprintf('[A]');
TitlStr2 = sprintf('[C]');
TitlStr3 = sprintf('[A] + [C]');



for ii = 1:nFrames
    subplot(2,2,1)
%     plot(x, A_rec(ii,:), x, Ass)
    [hAx,hLine1,hLine2] = ...
        plotyy([x x], [A_rec(ii,:) Ass], x, JA_rec(ii,:));
    ylabel(hAx(1),'[A]');ylabel(hAx(2),'J_A');xlabel('x');
    set(hAx(1),'YLim', [ MinA MaxA ],'YTick',[MinA MaxA] )
    set(hAx(2),'YLim', [ MinJA MaxJA ],'YTick',[MinJA MaxJA] )
    
%     axis(hAx(2),[x(1) x(end) MinJA MaxJA])
%     ,'YLim', [MinA MaxA],'XLabel','x')
    title(TitlStr1)
%     set(gca,'YLim', [MinA MaxA] )
    

    subplot(2,2,2)
  [hAx,hLine1,hLine2] = ...
        plotyy([x x], [C_rec(ii,:) Css], x, JC_rec(ii,:));
    ylabel(hAx(1),'[C]');ylabel(hAx(2),'J_C');xlabel('x');
%     axis(hAx(2),[x(1) x(end) MinJC MaxJC])
   set(hAx(1),'YLim', [ MinC MaxC ],'YTick',[MinC MaxC] )
   set(hAx(2),'YLim', [ MinJC MaxJC ],'YTick',[MinJC MaxJC] )
        
title(TitlStr2)
%     set(gca,'YLim', [MinC MaxC] )

% keyboard
    subplot(2,2,3)
   [hAx,hLine1,hLine2] = ...
        plotyy([x x], [A_rec(ii,:) + C_rec(ii,:) Ass + Css ], x, JT_rec(ii,:) );
    title(TitlStr3)
    ylabel(hAx(1),'[A]+[C]');ylabel(hAx(2),'J_T');xlabel('x');
    set(hAx(1),'YLim', [ MinT MaxT ],'YTick',[MinT MaxT] )
    set(hAx(2),'YLim', [ MinJT MaxJT ],'YTick',[MinJT MaxJT] )
    
    
%     set(gca,'YLim', [MinT MaxT] )
        
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