function [M_All] = ...
    FluxMovieMakerNd1D(JA_rec, JC_rec, JT_rec,Bt,x,TimeRec,nFrames,N,ParamVec,L_box)

%%%% Concentration %%%%%
xflux = ( [0 x] + [x L_box] ) ./ 2;

%Initialize the movie structure array
M_All(nFrames)  = struct('cdata',zeros(N,N,3,'int8'), 'colormap',[]);


% Set up figure
h = figure('Position', [100 100 840 630]);
% keyboard
MinJA = min( min( JA_rec ) );
MaxJA = max( max( max( JA_rec ) ), 0.00001);


MinJT = min( min( JT_rec ) );
MaxJT = max( max( max( JT_rec ) ), 0.00001);

% keyboard
MinJC = min( min( JC_rec ) );
MaxJC = max( max( max( JC_rec ) ), 0.00001);

if MaxJC == 0
    MaxJC = 0.0001;  
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
    plot(xflux, JA_rec(ii,:))
    title(TitlStrA)
    set(gca,'YLim', [MinJA MaxJA] )
    
    subplot(2,2,2)
    plot(xflux, JC_rec(ii,:))
    title(TitlStrC)
    set(gca,'YLim', [MinJC MaxJC] )
    
    
    subplot(2,2,3)
    plot(xflux, JT_rec(ii,:))
    title(TitlStrT)
    set(gca,'YLim', [MinJT MaxJT] )
    
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