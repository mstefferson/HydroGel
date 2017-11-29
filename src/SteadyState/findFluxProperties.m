%[jMax, aMax, djdtHm, tHm] = ...
%  findFluxProperties( FluxVsT, AccumVsT, timeObj, Np1, Np2, Np3 )
%
% Given a flux and accumulationvs time, function returns the max flux,
% time until half max flux, and slope at half max flux

function [jMax, aMax, djdtHm, tHm] = ...
  findFluxProperties( fluxEnd, fluxVsT, accumVsT, timeObj, Np1, Np2, Np3 )
% store some things
timeVec = (0:timeObj.N_rec-1) * timeObj.t_rec;
% allocate
djdtHm = zeros( Np1, Np2, Np3  );
tHm = zeros( Np1, Np2, Np3  );
jMax = zeros( Np1, Np2, Np3  );
aMax = zeros( Np1, Np2, Np3  );
% loop
for ii = 1:Np1
  for jj = 1:Np2
    for kk = 1:Np3
      fluxVsTimeVec = fluxVsT{ii,jj,kk};
      accumVsTimeVec = accumVsT{ii,jj,kk};
      jMax(ii,jj,kk) = fluxEnd(ii,jj,kk);
      aMax(ii,jj,kk) = accumVsTimeVec(end);
      % Find index where flux passes half max
      indTemp = find( fluxVsTimeVec > jMax(ii,jj,kk) / 2, 1 );
      if isempty( indTemp )
        djdtHm(ii,jj,kk) = 0;
        tHm(ii,jj,kk) = 0;
      else
        if indTemp == 1
          indTemp = 2;
        end
        djdtHm(ii,jj,kk) = ...
          ( fluxVsTimeVec(indTemp) - fluxVsTimeVec(indTemp - 1) ) ...
          ./ timeObj.t_rec;
        tHm(ii,jj,kk) = timeVec(indTemp);
      end
    end
  end
end