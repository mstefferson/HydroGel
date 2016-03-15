function [DA,DC] = BtDepDiffBuilder(Bt, Btc, DA,DC)
   
   DA = DA .* (1 - Bt ./ Btc );
   DC = DC .* ( Bt ./ Btc );
   
 
end