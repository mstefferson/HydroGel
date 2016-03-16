function [Btx] = BinitGelSquareBlur(Bt, sigma, x)
Nx = length(x);
Lx = x(end);
dx = x(2)-x(1);


Square = zeros(1,Nx);

SqHeight = Bt / (Lx - 2 * sigma);

Square( floor( ( sigma) / dx ) : ceil( (Lx - (sigma)) / dx ) ) = SqHeight;
% Square( 40:88 ) = SqHeight;

Gauss = exp( - (x) .^ 2  / ( 2 * sigma ^ 2  ) ) +...
exp( - (x - Lx) .^ 2  / ( 2 * sigma ^ 2  ) );

Gauss = Gauss ./ (trapz(x,Gauss) );


BtxFT =  fft(Square) .* fft(Gauss) ;
Btx   = Lx / Nx * ifft( BtxFT );

% trapz(x,Gauss)
% trapz(x,Square)
% trapz(x,Btx)

% plot(x,Square,x,Gauss,x,Btx);

% legend('Square','Gauss', 'Blurred','location','best')

end
