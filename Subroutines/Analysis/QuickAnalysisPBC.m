    

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
    for i = 1:1
      
        ACdervTemp = real( ifft( ifftshift( -kx.^2 .* ( AFT_rec(i,:) + CFT_rec(i,:) ) ) ) );
        plot( x,ACdervTemp )
          hold on
        CdervTemp = real( ifft( ifftshift( -kx.^2 .* CFT_rec(i,:) ) ) );
        plot( x,(nu - 1) .* CdervTemp )
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