    

    %%
    x = x_trim;
    figure()
    title('A+C')
    Maxrho = max(max( A_rec+C_rec ));
    Minrho = min(min( A_rec+C_rec ));
    % hold all
    for i = 1:N_rec
        plot( x,A_rec(i,:) + C_rec(i,:) )
        set(gca,'YLim', [Minrho Maxrho],'XLim', [0 L_box] )
        M_rho(i) = getframe(gcf);
    end
    %%
    x = x_trim;
    figure()
    title('A+C')
    % Maxrho = max(max( A_rec+C_rec ));
    % Minrho = min(min( A_rec+C_rec ));
    % hold all
    for i = 1:N_rec
        CdervTemp = real( ifft( ifftshift( -kx.^2 .* CFT_rec(i,:) ) ) );
        plot( x,(nu - 1) .* CdervTemp )
        set(gca,'YLim', [-1e-1 1e-1 ],'XLim', [0 L_box] )
        M_rho(i) = getframe(gcf);
    end
    %%
    x = x_trim;
    figure()
    title('A+C')
    % Maxrho = max(max( A_rec+C_rec ));
    % Minrho = min(min( A_rec+C_rec ));
    % hold all
    for i = 1:N_rec
        ACdervTemp = real( ifft( ifftshift( -kx.^2 .* ( AFT_rec(i,:) + CFT_rec(i,:) ) ) ) );
        plot( x,ACdervTemp )
        set(gca,'YLim', [-1 1 ],'XLim', [0 L_box] )
        M_rho(i) = getframe(gcf);
    end
    
    %%
    %%
    x = x_trim;
    figure()
    title('A+C')
    % Maxrho = max(max( A_rec+C_rec ));
    % Minrho = min(min( A_rec+C_rec ));
    % hold all
    for i = 1:N_rec
        AconcatTemp = [AL A_rec(i,:) AR];        
        AdervTemp   = (AconcatTemp(1:end-2) - 2.* AconcatTemp(2:end-1) + AconcatTemp(3:end) ) ./ dx^2;
        CconcatTemp = [CL C_rec(i,:) CR];        
        CdervTemp   = (CconcatTemp(1:end-2) - 2.* CconcatTemp(2:end-1) + CconcatTemp(3:end) ) ./ dx^2;
        
        plot( x, AdervTemp + CdervTemp,'g')
          hold on
        
        plot( x,(nu - 1) .* CdervTemp )
        legend('Diffusion','Source')
        hold off        
        set(gca,'YLim', [-0.1 0.1 ],'XLim', [0 L_box] )
        M_rho(i) = getframe(gcf);
    end
    
    %%
    
    figure()
    title('A')
    Maxrho = max(max( A_rec ));
    Minrho = min(min( A_rec ));
    % hold all
    for i = 1:N_rec
        plot( x,A_rec(i,:) )
        set(gca,'YLim', [Minrho Maxrho],'XLim', [0 L_box] )
        M_rho(i) = getframe(gcf);
    end
    
    figure()
    title('A+C')
    Maxrho = max(max( C_rec ));
    Minrho = min(min( C_rec ));
    % hold all
    for i = 1:N_rec
        plot( x, C_rec(i,:) )
        set(gca,'YLim', [Minrho Maxrho],'XLim', [0 L_box] )
        M_rho(i) = getframe(gcf);
    end