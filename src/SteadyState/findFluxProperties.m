%[jMax, aMax, djdtHm, tHm] = ...
%  findFluxProperties( FluxVsT, AccumVsT, timeObj, Np1, Np2, Np3 )
%
% Given a flux and accumulationvs time, function returns the max flux,
% time until half max flux, and slope at half max flux

function [jMax, aMax, djdtHm, tHm] = ...
  findFluxProperties( FluxVsT, AccumVsT, timeObj, Np1, Np2, Np3 )
% store some things
TimeVec = (0:timeObj.N_rec-1) * timeObj.t_rec;
jMax = FluxVsT(:,:,:,end);
aMax = AccumVsT(:,:,:,end);
% allocate
djdtHm = zeros( Np1, Np2, Np3  );
tHm = zeros( Np1, Np2, Np3  );
% loop
for ii = 1:Np1
  for jj = 1:Np2
    for kk = 1:Np3
      % Find index where flux passes half max
      indTemp = find( FluxVsT(ii,jj,kk,:) > jMax(ii,jj,kk) / 2, 1 );     
      if indTemp == 1
        indTemp = 2;
      end
      djdtHm(ii,jj,kk) = ...
        ( FluxVsT(ii,jj,kk,indTemp) - FluxVsT(ii,jj,kk,indTemp - 1) ) ...
        ./ timeObj.t_rec;
      tHm(ii,jj,kk) = TimeVec(indTemp);      
    end
  end
end


