function out = makeHoppingData(selectivity)
% get parameter valus
kdVec = unique( selectivity.paramLoad(:,3) );
kHopVec = unique( selectivity.paramLoad(:,4) )';
numKd = length(kdVec);
numKhop = length(kHopVec);
numData = length( unique( selectivity.paramLoad(:,5) ) ); % hard code 3 type: middle, upper, lower
% store data
out.kdVec = kdVec;
out.kHopVec = kHopVec;
% reshape data, 3rd dimension:
dataReshapeDf = reshape( selectivity.paramLoad(:,1), [ numKd, numKhop, numData ] );
dataReshapeDb = reshape( selectivity.paramLoad(:,2), [ numKd, numKhop, numData ] );
dataReshapeSel = reshape( selectivity.val, [ numKd, numKhop, numData ] );
% calculate nu
nuDataMid = dataReshapeDb( :, :, 1 ) ./ dataReshapeDf( :, :, 1 );
out.nuData = nuDataMid;
% calculate selectivity
selDataMid = dataReshapeSel(:,:,1);
out.selData = selDataMid;
% errors
if numData == 3
  % nu error
  nuDataUpper = dataReshapeDb( :, :, 2 ) ./ dataReshapeDf( :, :, 2 );
  nuDataLower = dataReshapeDb( :, :, 3 ) ./ dataReshapeDf( :, :, 3 );
  out.nuErrLower = nuDataMid - nuDataLower;
  out.nuErrUpper = nuDataUpper - nuDataMid;
  selDataUpper = dataReshapeSel(:,:,2);
  selDataLower = dataReshapeSel(:,:,3);
  out.selErrLower = selDataMid - selDataLower;
  out.selErrUpper = selDataUpper - selDataMid;
  end
end
