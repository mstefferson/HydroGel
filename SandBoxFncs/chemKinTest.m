%% Playing around with kinding rates and concentrations %%

%% Two species. Nothing fixed %%
% dA/dt = -k1 A + k2 B
% dB/dt =  k1 A - k2 B
%
% Kd = k2 / k1

Ai = 1;
Bi = 0;
T  = Ai + Bi;

% Dissociation constant
Kd = 0.5;

%Theory end value
Atf =  Kd * T / (1 + Kd);
Btf =  T / (1 + Kd);

% Time scaled by k1
tend = 5;
Nt   = 100;
t    = linspace(0,tend,Nt+1);

% Record
vrec = zeros(2,Nt+1);
vi   = [Ai; Bi];
vrec(:,1) = [ Ai; Bi];

%Operator
Lop  = [ -1 Kd; 1 -Kd];

for i = 2:Nt+1
  vrec(:,i) = expm( Lop * t(i) ) * vi;
end

figure()
plot( t, vrec(1,:), t, vrec(2,:) );
xlabel('t'); ylabel('Concentration');
title('A not fixed')
legend('A','B','location','best')
fprintf('Two species A Not Fixed\n');
fprintf('A/B = %.3f \n Kd = %.3f\n', vrec(1,end) / vrec(2,end), Kd );
fprintf('Final A theory = %.3f \n Final A meas. = %.3f\n', Atf, vrec(1,end) );
fprintf('Final B theory = %.3f \n Final B meas. = %.3f\n', Btf, vrec(2,end) );



%% Two species. A fixed %%
% dA/dt = 0
% dB/dt =  k1 A - k2 B
%
% Kd = k2 / k1

Ai = 1;
Bi = 0;

%Theory end value
Atf =  Ai;
Btf =  Ai / Kd;

% Dissociation constant
Kd = 0.5;

% Time scaled by k1
tend = 15;
Nt   = 100;
t    = linspace(0,tend,Nt+1);

% Record
vrec = zeros(2,Nt+1);
vi   = [Ai; Bi];
vrec(:,1) = [ Ai; Bi];

%Operator
Lop  = [ 0 0; 1 -Kd];

for i = 2:Nt+1
  vrec(:,i) = expm( Lop * t(i) ) * vi;
end

figure()
plot( t, vrec(1,:), t, vrec(2,:) );
xlabel('t'); ylabel('Concentration');
title('A not fixed')
legend('A','B','location','best')
fprintf('Two species A Fixed\n');
fprintf('A/B = %.3f \n Kd = %.3f\n', vrec(1,end) / vrec(2,end), Kd );
fprintf('Final A theory = %.3f \n Final A meas. = %.3f\n', Atf, vrec(1,end) );
fprintf('Final B theory = %.3f \n Final B meas. = %.3f\n', Btf, vrec(2,end) );



%% Three species. Nothing fixed %%
% dA/dt = -k1 A + k2 B
% dB/dt =  k1 A - (k2 + k3) B + k4 C
% dC/dt =  k3 B - k4 C

% Kd    = k2 / k1
% alpha = k3 / k1
% beta  = k4 / k1

Ai = 1;
Bi = 0;
Ci = 0;
T  =  Ai + Bi + Ci;

% Dissociation constant
Kd    = 2.0;
alpha = 3.0;
beta  = 0.1;
lambda = alpha / beta;

Atf = Kd * T / ( 1 + Kd + lambda);
Btf = T / ( 1 + Kd + lambda);
Ctf = lambda * T / ( 1 + Kd + lambda);

% Time scaled by k1
tend = 15;
Nt   = 100;
t    = linspace(0,tend,Nt+1);

% Record
vrec = zeros(3,Nt+1);
vi   = [Ai; Bi;Ci];
vrec(:,1) = [ Ai; Bi;Ci];

%Operator
Lop  = [ -1 Kd 0; 1 -(Kd+alpha) beta; 0 alpha -beta];

for i = 2:Nt+1
  vrec(:,i) = expm( Lop * t(i) ) * vi;
end

figure()
plot( t, vrec(1,:), t, vrec(2,:),t, vrec(3,:) );
title('A not fixed')
xlabel('t'); ylabel('Concentration');
legend('A','B','C','location','best')
fprintf('Three Species. A not Fixed\n');
fprintf('Final A theory = %.3f \n Final A meas. = %.3f\n', Atf, vrec(1,end) );
fprintf('Final B theory = %.3f \n Final B meas. = %.3f\n', Btf, vrec(2,end) );
fprintf('Final C theory = %.3f \n Final C meas. = %.3f\n', Ctf, vrec(3,end) );

%% Three species. A fixed %%
% dA/dt = 0
% dB/dt =  k1 A - (k2 + k3) B + k4 C
% dC/dt =  k3 B - k4 C
%
% Kd    = k2 / k1
% alpha = k3 / k1
% beta  = k4 / k1

Ai = 1;
Bi = 0;
Ci = 0;

% Dissociation constant
Kd     = 2.0;
alpha  = 3.0;
beta   = 0.2;
lambda = alpha / beta;

Atf = Ai;
Btf = Ai / Kd;
Ctf = lambda * Ai / Kd;


% Time scaled by k1
tend = 100;
Nt   = 100;
t    = linspace(0,tend,Nt+1);

% Record
vrec = zeros(3,Nt+1);
vi   = [Ai; Bi;Ci];
vrec(:,1) = [ Ai; Bi;Ci];

%Operator
Lop  = [ 0 0 0; 1 -(Kd+alpha) beta; 0 alpha -beta];

for i = 2:Nt+1
  vrec(:,i) = expm( Lop * t(i) ) * vi;
end

figure()
plot( t, vrec(1,:), t, vrec(2,:),t, vrec(3,:) );
xlabel('t'); ylabel('Concentration');
title('A fixed')
legend('A','B','C','location','best')

fprintf('Three Species. A Fixed\n');
fprintf('Final A theory = %.3f \n Final A meas. = %.3f\n', Atf, vrec(1,end) );
fprintf('Final B theory = %.3f \n Final B meas. = %.3f\n', Btf, vrec(2,end) );
fprintf('Final C theory = %.3f \n Final C meas. = %.3f\n', Ctf, vrec(3,end) );


