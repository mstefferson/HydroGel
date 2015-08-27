function [M_All] = ...
    FluxMovieMaker1D(JA_rec, JC_rec, JT_rec,Bt,x,TimeRec,nFrames,N,ParamVec)

%%%% Concentration %%%%%


%Initialize the movie structure array
M_All(nFrames)  = struct('cdata',zeros(N,N,3,'int8'), 'colormap',[]);


% Set up figure
figure
% keyboard
MinA = min( min( JA_rec ) );
MaxA = max( max( JA_rec ) );


MinT = min( min( JT_rec ) );
MaxT = max( max( JT_rec ) );

% keyboard
MinC = min( min( JC_rec ) );
MaxC = max( max( JC_rec ) );

if MaxC == 0
    MaxC = 0.0001;  
end

set(gcf,'renderer','zbuffer')
% keyboard
%     keyboard
%Titles
TitlStrA = sprintf('J_A');
TitlStrC = sprintf('J_C');
TitlStrT = sprintf('J_T');

for ii = 1:nFrames
    
    subplot(2,2,1)
    plot(x, JA_rec(ii,:))
    title(TitlStrA)
    set(gca,'YLim', [MinA MaxA] )
    
    subplot(2,2,2)
    plot(x, JC_rec(ii,:))
    title(TitlStrC)
    set(gca,'YLim', [MinC MaxC] )
    
    
    subplot(2,2,3)
    plot(x, JT_rec(ii,:))
    title(TitlStrT)
    set(gca,'YLim', [MinT MaxT] )
    
    subplot(2,2,4)
    cla
    hold off
    PParamStr = sprintf(' t = %.1e \n kon = %.1e \n koff = %.1e \n D_A = %.1e \n F_C = %.1e\n Bt = %.1e', ...
        TimeRec(ii),ParamVec(1), ParamVec(2), ParamVec(3), ParamVec(4),Bt );
    text(0.4,0.4,0.4,ParamStr)
%     keyboard
    M_All(ii) = getframe(gcf); %Store the frame
end

% keyboard
close all