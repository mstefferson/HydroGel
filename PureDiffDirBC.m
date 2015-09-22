%% Solution for semi-infinite rod with a fixed concentration at x = 0;
% General solution is c(x,t) = Ci * erfc( x / (2 *sqrt(D*t) )

Nx    = 1000;         % Spatial gridpoints 
Nt    = 10;           % Temporal gridpoints
Ct    = zeros(Nt,Nx); % Concentration C(t,x)

% Parameters
Lbox  = 10;    % Box size. Should be infinity...
D     = 1;     % Diffusion coefficient
t_tot = 10;    % End time;
Ci    = 10;     % Concentration at x = 0;

% Set up time and position vectors
xvec = linspace(0,Lbox,Nx);
tvec = linspace(0,t_tot,Nt);

% erfc doesn't really like 0/0 so do that by hand
Ct(1,:) = 0; Ct(1,1) = Ci;

for  i = 2:Nt
    Ct(i,:) = Ci * erfc(xvec / (2 * sqrt( D*tvec(i) ) ) );
end

%%% Movie stuff
%Initialize the movie structure array
M_All(Nt)  = struct('cdata',zeros(Nx,Nx,3,'int8'), 'colormap',[]);


figure()
xlabel('x'); ylabel('concentration')
for  i = 1:Nt
    titlstr = sprintf('Pure diffusion in a semi-infinite rod t = %.1f',...
        tvec(i) );
    plot( xvec, Ct(i,:) )
    title(titlstr);
    M_All(i) = getframe(gcf);
end
