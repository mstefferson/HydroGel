%%
function [IntPart,FinPart,MinPart,MaxPart] = ConservDenCheck(x,A_rec,C_rec,TimeRec)

TotalPartvsTime = trapz(x,A_rec+C_rec,2)';

IntPart = TotalPartvsTime(1);
FinPart = TotalPartvsTime(end);
MaxPart = max(TotalPartvsTime);
MinPart = min(TotalPartvsTime);


ConsInfStr = sprintf(' Int    = %e \n Fin   = %e\n Min  = %e\n Max = %e\n', ...
    IntPart, FinPart,MinPart,MaxPart);

if 0
   plot( TimeRec,TotalPartvsTime)
   textbp( ConsInfStr )
end


disp(ConsInfStr);


end
