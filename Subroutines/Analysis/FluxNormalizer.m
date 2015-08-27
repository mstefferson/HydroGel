function [JAnorm_rec,JCnorm_rec,JTnorm_rec] = ...
    FluxNormalizer(JA_rec,JC_rec,JT_rec,AL,AR,CL,CR,ParamVec,N_rec,N,x_trim,ND)

dx    = x_trim(2) - x_trim(1);
L_box =  x_trim(end) + dx;

 if ND
        Jass = -1 .* ...
            ( AR - AL ) / ( L_box );
        Jcss = -ParamVec(2) .* ...
            ( CR - CL ) / ( L_box );
    else
        Jass = -ParamVec(3) .* ...
            ( AR - AL ) / ( L_box );
        Jcss = -ParamVec(4) .* ...
            ( CR - CL ) / ( L_box );
 end
 
%   keyboard
%   size(JA_rec)
%   size( repmat( Jass, [N_rec,N] ) )
 JAnorm_rec = JA_rec ./ repmat( Jass, [N_rec,N] );
 JCnorm_rec = JC_rec ./ repmat( Jcss, [N_rec,N] );
 JTnorm_rec = JT_rec ./ repmat( Jass + Jcss, [N_rec,N] ) ;
 

end