%% Make KDinv vs nu plot
% will probably delete
pp1Kdval = zeros(nuNum,KoffNum); %first row KDinv = 0
logpp1Kdval = zeros(nuNum,KoffNum); 
for ii = 1:KoffNum
   KDinvBigger1 = 0;
   for jj = 1:nuNum
       KDinvBigger1 = 0;
        for kk = 1:KDinvNum
            if PhaseMat(kk,ii,jj)  > 1
                PhaseMat(kk,ii,jj);
                KDinvBigger1 = KDinvVec(kk);
      
                fprintf('Koff = %.1e Ind = %d\n',KoffVec(ii),ii)
                fprintf('nu = %.1e Ind = %d\n',nuVec(jj),jj)
                fprintf('KDinv = %.1e Ind = %d\n',KDinvVec(kk),kk)
      
                pp1Kdval(jj,ii) = KDinvBigger1;
                logpp1Kdval(jj,ii) = log10(KDinvBigger1);
                break
            end
        end
    end
end

        
    
    %plot(nuVec,pp1Kdval)
    plot(nuVec,pp1Kdval)
    plot(nuVec,logpp1Kdval)
    legcell = cellstr(num2str( [KoffVec'], 'koff = %.1e'));
    legend(legcell)


%%