% Check conservation of particles with a reservior for A

function [] =  ConservCheckerPBC(x,A_rec,C_rec,TimeRec)

    figure()
    NumA = trapz_periodic(x,A_rec,1);
    NumC = trapz_periodic(x,C_rec,1);
    NumT = NumA + NumC;
    plot( TimeRec ,NumA,...
        TimeRec ,NumC,...
        TimeRec , NumT)
    legend('A','C','A+C')
    title('Number particles include reserviors')
    xlabel('Time'); ylabel('Number of particles')
    
    RelParticleLoss = ( NumT(end) - NumT(1)  ) ./ NumT(1);
    
    fprintf('Relative particle loss = %.2e\n',RelParticleLoss)

%     keyboard
end