function [M_All] = ...
    ConcenMovieMakerNd1D(A_rec, Ass,C_rec, Css,B_rec,...
    x,TimeRec,nFrames,N,AllParamVec)

%%%% Concentration %%%%%
Kon = AllParamVec(1);
Koff = AllParamVec(2);
beta = AllParamVec(3);
nu = AllParamVec(4);
Bt = AllParamVec(6);
KDinv = Kon/Koff;

%Initialize the movie structure array
M_All(nFrames)  = struct('cdata',zeros(N,N,3,'int8'), 'colormap',[]);

% Set up figure
h = figure('Position', [100 100 840 630]);
% keyboard
MinA = min( min( A_rec ) );
MaxA = max( [max( max( A_rec ) ) 1e-10 max(Ass)] );

MinB = min( min( min( B_rec ) ),0 );
MaxB = max( [max( max( B_rec ) ) 1e-10] );


MinC = min( min( C_rec ) );
MaxC = max( [max( max( C_rec ) ) 1e-10 max(Css)] );

MinT = min( min( A_rec + C_rec ) );
MaxT = MaxA + MaxC;

set(gcf,'renderer','zbuffer')
% keyboard
%     keyboard
%Titles
TitlStr1 = sprintf('[A]');
TitlStr2 = sprintf('[C]');
TitlStr3 = sprintf('[A]+[C]');

for ii = 1:nFrames
    subplot(2,2,1)
    plot(x, A_rec(:,ii) , x, Ass )
    title(TitlStr2)
    xlabel('x');
    set(gca,'YLim', [MinA MaxA] )
    %     keyboard
%     plot(x, A_rec(ii,:), x, Ass)
% keyboard
%     [hAx,hLine1,hLine2] = ...
%         plotyy(x, [A_rec(ii,:)' Ass'], x, [C_rec(ii,:)' Css']);
%     set(hLine1,'Color','b');set(hLine2,'Color','r');
%     ylabel(hAx(1),'[A]');ylabel(hAx(2),'[C]');xlabel('x');
%     set(hAx(1),'YLim',[MinA MaxA],'YTick',[MinA MaxA] );
%     set(hAx(2),'YLim',[MinC MaxC],'YTick',[MinC MaxC]); 
    title(TitlStr1)
%     set(gca,'YLim', [MinA MaxA] )
    
%     keyboard
    subplot(2,2,2)
    plot(x,C_rec(:,ii), x,Css )
    title(TitlStr2)
    xlabel('x');
    set(gca,'YLim', [MinC MaxC] )
    
     subplot(2,2,3)
    plot(x, A_rec(:,ii) + C_rec(:,ii), x, Ass + Css )
    title(TitlStr3)
    xlabel('x');
    set(gca,'YLim', [MinT MaxT] )
    
    
    subplot(2,2,4)
    cla
    hold off
   ParamStr = sprintf(...
       ' t = %.1e \n KDinv = %.1e \n nu = %.1e \n beta = %.1e \n Bt = %.1e \n Kon = %.1e \n Koff = %.1e \n ', ...
        TimeRec(ii),KDinv,nu,beta,Bt,Kon, Koff );
    text(0.4,0.4,0.4,ParamStr)
%     keyboard
    M_All(ii) = getframe(gcf); %Store the frame
end

% keyboard
% close all