%% Make Ka vs nu plot
% will probably delete
pp1Kdval = zeros(nuNum,KoffNum); %first row Ka = 0
logpp1Kdval = zeros(nuNum,KoffNum); 
for ii = 1:KoffNum
   KaBigger1 = 0;
   for jj = 1:nuNum
       KaBigger1 = 0;
        for kk = 1:KaNum
            if PhaseMat(kk,ii,jj)  > 1
                PhaseMat(kk,ii,jj);
                KaBigger1 = KaVec(kk);
      
                fprintf('Koff = %.1e Ind = %d\n',KoffVec(ii),ii)
                fprintf('nu = %.1e Ind = %d\n',nuVec(jj),jj)
                fprintf('Ka = %.1e Ind = %d\n',KaVec(kk),kk)
      
                pp1Kdval(jj,ii) = KaBigger1;
                logpp1Kdval(jj,ii) = log10(KaBigger1);
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