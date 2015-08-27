function [M_All] = ...
    ConcenFluxMovieMakerNd1D(A_rec, Alin,C_rec, Clin,JA_rec,JC_rec,JT_rec,Bt,...
    x,TimeRec,nFrames,N,ParamVec)


% position between grid points
xflux = ( x(1:end-1) + x(2:end) ) ./ 2;

%Initialize the movie structure array
M_All(nFrames)  = struct('cdata',zeros(N,N,3,'int8'), 'colormap',[]);

% Set up figure
h = figure('Position', [100 100 840 630]);
% keyboard
MaxA = max( max( max( A_rec ), 0.00001 ) );
MinA = min( min( A_rec ) );

MinJA = min( min( JA_rec ) );
MaxJA = max( max( max( JA_rec ) ), 0.00001);

MaxC = max( max( max( C_rec ), 0.00001 ) );
MinC = min( min( C_rec ) );

MinJC = min( min( JC_rec ) );
MaxJC = max( max( max( JC_rec ) ), 0.00001);

if MaxJC == 0
    MaxJC = 0.0001;
end

MaxT = max( max( A_rec + C_rec ) );
MinT = min( min( A_rec + C_rec ) );

MinJT = min( min( JT_rec ) );
MaxJT = max( max( max( JT_rec ) ), 0.00001);

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
    [hAx,hLine1,hLine2] = ...
        plotyy(x, [A_rec(ii,:)' Alin'], xflux, JA_rec(ii,:));
    ylabel(hAx(1),'[A]');ylabel(hAx(2),'J_A');xlabel('x');
    set(hLine1,'Color','b'); set(hLine2(1),'Color','r');
    set(hAx(1),'YLim', [ MinA MaxA ],'YTick',[MinA MaxA] )
    set(hAx(2),'YLim', [ MinJA MaxJA ],'YTick',[MinJA MaxJA] )
    title(TitlStr1)
    %     axis(hAx(2),[x(1) x(end) MinJA MaxJA])
    %     ,'YLim', [MinA MaxA],'XLabel','x')
    
    %     set(gca,'YLim', [MinA MaxA] )
    
    
    subplot(2,2,2)
    [hAx,hLine1,hLine2] = ...
        plotyy([x], [C_rec(ii,:)' Clin'], xflux, JC_rec(ii,:));
    ylabel(hAx(1),'[C]');ylabel(hAx(2),'J_C');xlabel('x');
    set(hLine1,'Color','b'); set(hLine2,'Color','r');
    %     axis(hAx(2),[x(1) x(end) MinJC MaxJC])
    set(hAx(1),'YLim', [ MinC MaxC ],'YTick',[MinC MaxC] )
    set(hAx(2),'YLim', [ MinJC MaxJC ],'YTick',[MinJC MaxJC] )
    title(TitlStr2)
    %     set(gca,'YLim', [MinC MaxC] )
    
    % keyboard
    subplot(2,2,3)
    [hAx,hLine1,hLine2] = ...
        plotyy([x], [A_rec(ii,:)' + C_rec(ii,:)' Alin' + Clin' ], xflux, JT_rec(ii,:) );
    title(TitlStr3)
    ylabel(hAx(1),'[A]+[C]');ylabel(hAx(2),'J_T');xlabel('x');
    set(hLine1,'Color','b'); set(hLine2,'Color','r');
    set(hAx(1),'YLim', [ MinT MaxT ],'YTick',[MinT MaxT] )
    set(hAx(2),'YLim', [ MinJT MaxJT ],'YTick',[MinJT MaxJT] )
    
    
    %     set(gca,'YLim', [MinT MaxT] )
    
    subplot(2,2,4)
    cla
    hold off
    ParamStr = sprintf(' t = %.1e \n KDinv = %.1e \n nu = %.1e \n Bt = %.1e \n', ...
        TimeRec(ii),ParamVec(1), ParamVec(2),Bt );
    text(0.4,0.4,0.4,ParamStr)
    %     keyboard
    M_All(ii) = getframe(gcf); %Store the frame
end

% keyboard
close all