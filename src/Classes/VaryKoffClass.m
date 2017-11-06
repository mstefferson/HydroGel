classdef VaryKoffClass   
  properties
    KoffScale = 0;
    FunctForm = '';
    Koff = 0;
    MultFac = 0;
    LengthScale = 0;
    N = 0;
  end % properties
  
  methods
    % constructor
    function obj = VaryKoffClass( koffCell, n )
      % set inputs
      if isempty( koffCell )
        koffCell = {'const'};
      end
      obj.FunctForm = koffCell{1};
      obj.KoffScale = koffCell{2};
      obj.N = n;
      if strcmp( obj.FunctForm, 'const' )
        obj.Koff = obj.KoffScale .* ones( obj.N, 1 );
      elseif strcmp( obj.FunctForm, 'outletboundary' )
        obj.Koff = obj.KoffScale .* ones( obj.N, 1 );
        obj.MultFac = koffCell{3};
        obj.Koff(end) = koffCell{3} .* obj.Koff(end);
      end
    end
  end % methods
end % class
