%%
close all
figure
recHolder = 100;
plot(x_trim, A_rec(recHolder,:)+C_rec(recHolder,:))

%%
recHolder = 101;
x          = [0 x_trim L_box];
Total1     = [AL+CL A_rec(recHolder,:)+C_rec(recHolder,:) AR+CR];
Total2 = [ AL+CL Totaltemp(recHolder,:) AR+CR];

close all
figure
plot(x, Total1 ,x,Total2)
xlabel('Position')
ylabel('[A]+[C]')
title('[A]+[C] at fixed time')
legStr1 = sprintf('D/F = %.1f',1);
legStr2 = sprintf('D/F = %.1f',0);
legend(legStr1,legStr2,'Location','Best')
%%

%%


%%


%%
recHolder = 11;

close all
figure
plot(x_trim, A_rec(recHolder,:)+C_rec(recHolder,:),x_trim,Totaltemp(recHolder,:) )
xlabel('Position')
ylabel('[A]+[C]')
title('[A]+[C] at fixed time')
legStr1 = sprintf('D/F = %.1f',1);
legStr2 = sprintf('D/F = %.1f',0);
legend(legStr1,legStr2,'Location','Best')
%%


Totaltemp = A_rec + C_rec;