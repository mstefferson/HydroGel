classdef VaryKoffClass < handle
  properties
    KoffScale = 0;
    FunctForm = 0;
    Koff = 0;
    MultFac = 0;
    LengthScale = 0;
    N = 0;
  end % properties
  
  methods
    % constructor
    function obj = VaryKoffClass( koff, koffCell, n )
      % set inputs
      if isempty( koffCell )
        koffCell = {'const'};
      end
      obj.KoffScale = koff;
      obj.FunctForm = koffCell{1};
      obj.N = n;
      if strcmp( koffCell{1}, 'const' )
        obj.Koff = obj.KoffScale .* ones( obj.N, 1 );
      elseif strcmp( koffCell{1}, 'outletboundary' )
        obj.Koff = obj.KoffScale .* ones( obj.N, 1 );
        obj.MultFac = koffCell{2};
        obj.Koff(end) = koffCell{2} .* obj.Koff(end);
      end
    end
  end % methods
end % class
