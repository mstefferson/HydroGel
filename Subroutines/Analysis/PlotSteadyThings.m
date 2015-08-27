 %%
 nu = ParamVec(2);
 KDinv = 1/ParamVec(1);
Adiff = ( [ AL A(1:end-1) ] - 2 * A + [A(2:end) AR] ) ;
Cdiff = nu * ( [ CL C(1:end-1) ] - 2 * C + [C(2:end) CR] ) ;

Achem = -KDinv .* (A .* (Bt - C) ) + C;
Cchem =  KDinv .* (A .* (Bt - C) ) - C;

 figure()
    subplot(4,1,1)
    plot(x_trim, A)
    title('A')
    subplot(4,1,2)
    plot(x_trim, Adiff)
    title('diffusion')
    subplot(4,1,3)
    plot(x_trim, Achem)
    title('chemical')
    subplot(4,1,4)
    plot(x_trim, Achem + Adiff)
    title('change in A')
 %%
 Adiff = ( [ AL A(1:end-1) ] - 2 * A + [A(2:end) AR] ) ;
Cdiff = nu * ( [ CL C(1:end-1) ] - 2 * C + [C(2:end) CR] ) ;

Achem = -KDinv .* (A .* (Bt - C) ) + C;
Cchem =  KDinv .* (A .* (Bt - C) ) - C;

        figure()
    subplot(4,1,1)
    plot(x_trim, C)
    title('C')
    subplot(4,1,2)
    plot(x_trim, Cdiff)
    title('diffusion')
    subplot(4,1,3)
    plot(x_trim, Cchem)
    title('chemical')
    subplot(4,1,4)
    plot(x_trim, Cchem + Cdiff)
    title('Cnext-C')
 
    %%
    figure()
    subplot(4,1,1)
    plot(x_trim, A+C)
    title('total')
    subplot(4,1,2)
    plot(x_trim, Adiff + Cdiff)
    title('total diffusion')
    subplot(4,1,3)
    plot(x_trim, Achem + Cchem)
    title('total chemical')
    subplot(4,1,4)
    plot(x_trim, Anext-A + Cnext-C)
    title('total difference')
    
    %%   
    figure
    B =  Bt - C;
    subplot(2,1,1)
    plot(x_trim, B, x_trim, KD .* C ./ A)
    title('B')
 
    subplot(2,1,2)
    plot(x_trim, KDinv .* B.*A, x_trim,C)
    title('C')

    figure
    plot(x_trim, B - (KD .* C ./ A),x_trim, C- (KDinv .* B.*A))
    legend('delta B','delta C')
    title('delta')
    %%
    
    figure
    subplot(2,1,1)
    plot(x_trim,A,x_trim,Ass)
    subplot(2,1,2)
    plot(x_trim,A-Ass)
    %%
    figure
    subplot(2,1,1)
    plot(x_trim,C,x_trim,Css)
    subplot(2,1,2)
    plot(x_trim,C-Css)
    
    %%
    A = A_rec(end,:);
    C = C_rec(end,:);
    figure
    subplot(4,1,1)
    Alin = AR-AL / L_box .*x_trim + AL;
    plot(x_trim,Alin,x_trim,A)
    legend('diff steady','actual')
    title('final As')
    
    subplot(4,1,2)
    plot(x_trim,A-Alin)
    title('delta A-Alin')
    
    subplot(4,1,3)
    Clin = CR-CL / L_box .*x_trim + CL;
    plot(x_trim,Csschem,x_trim,Clin,x_trim,C)
    legend('Chem steady','diff steady','actual')
    title('final Cs')
    
    
    subplot(4,1,4)
    plot(x_trim,C-Csschem,x_trim,C-Clin,x_trim,Cchem-Clin)
    legend('C-Cchem','C-Clin','Cchem-Clin')
    title('delta Cs Css=Cchem')
    