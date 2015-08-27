function [M_All] = ...
    ConcenMovieMakerNd1DRD(A_rec, Ass,C_rec, Css,B_rec,x,TimeRec,nFrames,N,ParamVec)

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

set(gcf,'renderer','zbuffer')
% keyboard
%     keyboard
%Titles
TitlStrA = sprintf('[A]');
TitlStrB = sprintf('[B]');
TitlStrC = sprintf('[C]');

for ii = 1:nFrames
    subplot(2,2,1)
    plot(x, A_rec(ii,:), x, Ass)
    title(TitlStrA)
    set(gca,'YLim', [MinA MaxA] )
    
    subplot(2,2,2)
    plot(x, B_rec(ii,:))
    title(TitlStrB)
    set(gca,'YLim', [MinB MaxB] )
    
    
    subplot(2,2,3)
    plot(x, C_rec(ii,:), x, Css)
    title(TitlStrC)
    set(gca,'YLim', [MinC MaxC] )
    
    
    subplot(2,2,4)
    cla
    hold off
    ParamStr = sprintf(' t = %.1e \n KD = %.1e \n nu = %.1e \n', ...
        TimeRec(ii),ParamVec(1), ParamVec(2) );
    text(0.4,0.4,0.4,ParamStr)
%     keyboard
    M_All(ii) = getframe(gcf); %Store the frame
end

% keyboard
close all