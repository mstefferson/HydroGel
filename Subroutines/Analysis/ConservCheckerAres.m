% Check conservation of particles with a reservior for A

function [] =  ConservCheckerAres(x,A_rec,C_rec,TimeRec,Lr)

    figure()
    NumA = Lr * A_rec(1,:) + trapz(x,A_rec,1) + Lr * A_rec(end,:);
    NumC = trapz(x,C_rec,1);
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