% Description: Tracks the position of a constant concentration as a
% function of time

function [xDesVsTime,x2VsTime,DesCon] = WaveFrontTracker(Conc,TimeRec,x,alpha,PlotMe)


%Save some things
% MinConcvsT = min( Conc,[],2 );
MaxConcvsT = max( Conc,[],2 );
% AveConcvsT = mean( Conc,2 );

% Get the size
[Nrec, Nx] = size(Conc);

% Conc = Conc(:,1:Nx/2);
% Pick a subset for plotting if you want
subset = 1:ceil(Nrec/4);
%Pick the concentration you want to track
DesCon = alpha .* max(MaxConcvsT);
% DesCon = Conc(2,1);
xDesVsTime = zeros(1,Nrec);

% keyboard

if DesCon ~= 0
    for i = 1:Nrec
        Atemp = Conc(i,:);
        if max(Atemp) > DesCon
            %          keyboard
            SwitchInd = find(Atemp - DesCon >= 0, 1, 'last' ) + 1; % Matlab wanted me to do this instead of max(find(blah))
            if SwitchInd > Nx
                SwitchInd =  SwitchInd - 1;
            end
            
            m = ( Atemp(SwitchInd) - Atemp(SwitchInd - 1) ) / ( x(SwitchInd) - x(SwitchInd - 1) );
            xDesVsTime(i) = x(SwitchInd) + ( DesCon - Atemp(SwitchInd) ) / m;
        else
            xDesVsTime(i) = 0;
        end
    end
    %Plot it
end

x2VsTime = xDesVsTime .^ 2;
if PlotMe
    figure
    plot(TimeRec,x2VsTime )
    xlabel('Time'); ylabel('x^2'); title('wavefront displacement')
end

end