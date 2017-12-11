function out = makeHoppingData(selectivity)
% get parameter valus
kdVec = unique( selectivity.paramLoad(:,3) );
kHopVec = unique( selectivity.paramLoad(:,4) )';
numKd = length(kdVec);
numKhop = length(kHopVec);
numData = 3; % hard code 3 type: middle, upper, lower
% store data
out.kdVec = kdVec;
out.kHopVec = kHopVec;
% reshape data, 3rd dimension:
dataReshapeDf = reshape( selectivity.paramLoad(:,1), [ numKd, numKhop, numData ] );
dataReshapeDb = reshape( selectivity.paramLoad(:,2), [ numKd, numKhop, numData ] );
dataReshapeSel = reshape( selectivity.val, [ numKd, numKhop, numData ] );
% calculate nu
nuDataMid = dataReshapeDb( :, :, 1 ) ./ dataReshapeDf( :, :, 1 );
nuDataUpper = dataReshapeDb( :, :, 2 ) ./ dataReshapeDf( :, :, 2 );
nuDataLower = dataReshapeDb( :, :, 3 ) ./ dataReshapeDf( :, :, 3 );
out.nuData = nuDataMid;
out.nuErrLower = nuDataMid - nuDataLower;
out.nuErrUpper = nuDataUpper - nuDataMid;
% calculate selectivity
selDataMid = dataReshapeSel(:,:,1);
selDataUpper = dataReshapeSel(:,:,2);
selDataLower = dataReshapeSel(:,:,3);
out.selData = selDataMid;
out.selErrLower = selDataMid - selDataLower;
out.selErrUpper = selDataUpper - selDataMid;
end
