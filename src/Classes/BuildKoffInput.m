% build structure that contains all the koff info for runs.
classdef BuildKoffInput < handle
  properties
    Type = '';
    BulkVal = 0;
    NumMult = 0;
    BulkValAllRuns = 0;
    InfoCell = 0;
    Inputs = 0;
    Inds = 0;
    NumTot = 0;
    NumBulkVal = 0;
  end % properties
  
  methods
    % constructor
    function obj = BuildKoffInput( koff, koffCellInput )
      % get type
      if isempty( koffCellInput )
        obj.Type = 'const';
      else
        obj.Type = koffCellInput{1};
      end
      obj.Inputs = koffCellInput;
      % set koff
      obj.setBulkVal( koff );
      % build cell
      obj = obj.buildCell( );
    end
    
    function obj = rebuildKoff( obj, koffNew)
      % set koff
      obj.setBulkVal( koffNew );
      % build cell
      obj = obj.buildCell( );
    end
    
    function obj = setBulkVal( obj, koff )
      obj.BulkVal = koff;
      obj.NumBulkVal = length( koff );
    end
    
    function obj = buildCell( obj )
      % get parameters based on type
      if strcmp( obj.Type, 'const' )
        numBulk = length( obj.BulkVal );
        numMult = 1;
        totBulkVal = numBulk;
        obj.InfoCell = cell( 1, totBulkVal );
        obj.BulkValAllRuns = obj.BulkVal;
        for ii = 1:numBulk
          obj.InfoCell{ii}{1} = obj.Type;
          obj.InfoCell{ii}{2} = obj.BulkVal(ii);
        end
      elseif strcmp( obj.Type, 'outletboundary' )
        numBulk = length( obj.BulkVal );
        numMult = length( obj.Inputs{2} );
        totBulkVal = numBulk * numMult;
        obj.InfoCell = cell( 1, totBulkVal );
        counter = 1;
        for ii = 1:numBulk
          for jj = 1:numMult
            obj.BulkValAllRuns(counter) = obj.BulkVal(ii);
            obj.InfoCell{counter}{1} = obj.Type;
            obj.InfoCell{counter}{2} = obj.BulkVal(ii);
            obj.InfoCell{counter}{3} = obj.Inputs{2}(jj);
            counter = counter + 1;
          end
        end
      else
        fprintf('Do not recognize koff cell\n')
        error('Do not recognize koff cell')
      end
      obj.NumMult = numMult;
      obj.Inds = 1:totBulkVal;
      obj.NumTot = totBulkVal;
    end % build cell
  end % methods
end % class
