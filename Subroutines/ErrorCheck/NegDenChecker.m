function [DidIBreak] = NegDenChecker(A_rec,C_rec,B_rec,trial)
DidIBreak = 0;
if min( min( A_rec ) ) < 0
    fprintf('Caution! [A] went negative in trial %d \n',trial);
    DidIBreak = 1;
end

if min( min( B_rec ) ) < 0
    fprintf('Caution! [B] went negative in trial %d \n',trial);
    DidIBreak = 1;
end

if min( min( C_rec ) ) < 0
    fprintf('Caution! [C] went negative in trial %d \n',trial);
    DidIBreak = 1;
end

end