% build structure that contains all the koff info for runs.
classdef BuildKoffInput < handle
  properties
    Type = '';
    BulkVal = 0;
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
    
    function obj = rebuildBulkVal( obj, koffNew)
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
        numBulkVal = length( obj.BulkVal );
        totBulkVal = numBulkVal;
        obj.InfoCell = cell( 1, totBulkVal );
        obj.BulkValAllRuns = obj.BulkVal;
        for ii = 1:numBulkVal
          obj.InfoCell{ii}{1} = obj.Type;
          obj.InfoCell{ii}{2} = obj.BulkVal(ii);
        end
      elseif strcmp( obj.Type, 'outletboundary' )
        numBulkVal = length( obj.BulkVal );
        numInfoCell = length( obj.Inputs{2} );
        totBulkVal = numBulkVal * numInfoCell;
        obj.InfoCell = cell( 1, totBulkVal );
        counter = 1;
        for ii = 1:numBulkVal
          for jj = 1:numInfoCell
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
      obj.Inds = 1:totBulkVal;
      obj.NumTot = totBulkVal;
    end % build cell
  end % methods
end % class
