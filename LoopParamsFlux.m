% Add paths and see where we are
addpath('./Subroutines');
if ~exist('./Outputs','dir'); mkdir('Outputs'); end;
Time = datestr(now);
currentdir=pwd;
fprintf('In dir %s\n',currentdir);

fprintf('Starting RunHydroGel: %s\n', Time)

% Initparams
fprintf('Initiating parameters\n');
if exist( 'InitParams.m','file');
  InitParams;
else
  cpParams
  InitParams
end

% Build TimeObj
[TimeObj] = TimeObjMakerRD(dt,t_tot,t_rec,ss_epsilon,NumPlots);

FileDir = sprintf('RdNx%dA%sC%st%d',...
  ParamObj.Nx,ParamObj.A_BC,ParamObj.C_BC,ParamObj.trial);
Where2SavePath    = sprintf('%s/%s/%s',pwd,'Outputs',FileDir);
% disp( max(dt * (Nx/Lbox)^2,nu * dt * (Nx/Lbox)^2) )

if ParamObj.SaveMe
  diary('RunDiary.txt')
end

% Display everything
fprintf('trial:%d A_BC: %s C_BC: %s\n', ...
  ParamObj.trial,ParamObj.A_BC, ParamObj.C_BC)
disp(ParamObj); disp(AnalysisObj); disp(TimeObj);


% Edits here. Change params and loop over
global Flux2ResR_rec;

%Kd = 0;
KoffVec = [1e-2 1e-1 1e0 1e1 1e2];
ParamObj.KDinv = 0;
KoffVecTmp = [0];

fprintf('\n\n Starting Kd 0\n\n');

ParamObj.Koff = 0;
ParamObj.Kon   = 0;
fprintf( 'Koff = %f\n',ParamObj.Koff );
%   tic
%   fprintf('Starting run \n')
[A,C,DidIBreak,SteadyState] = ChemDiffMain(ParamObj,TimeObj,AnalysisObj);
%   fprintf('Finished run\n')
%   toc
FluxMatKd0 = repmat(Flux2ResR_rec,[length(KoffVec) 1] );
fprintf('Break = %d Steady = %d\n',DidIBreak,SteadyState)


fprintf('Finished Kd 0\n');

%Kd = 1e1;
ParamObj.KDinv = 1e1;
FluxMatKd1e1 = zeros( length(KoffVec), TimeObj.N_rec );
fprintf('\n\n Starting Kd 1e2\n\n');
for ii = 1:length(KoffVec);
  
  ParamObj.Koff = KoffVec(ii);
  ParamObj.Kon   = ParamObj.KDinv * ParamObj.Koff;
  fprintf( 'Koff = %f\n',ParamObj.Koff );
  %   tic
  %   fprintf('Starting run \n')
  [A,C,DidIBreak,SteadyState] = ChemDiffMain(ParamObj,TimeObj,AnalysisObj);
  %   fprintf('Finished run\n')
  %   toc
  FluxMatKd1e1(ii,:) = Flux2ResR_rec;
  fprintf('Break = %d Steady = %d\n',DidIBreak,SteadyState)
end
fprintf('Finished Kd 1e1\n');

%Kd = 1e2;
ParamObj.KDinv = 1e2;
FluxMatKd1e2 = zeros( length(KoffVec), TimeObj.N_rec );
fprintf('\n\n Starting Kd 1e2\n\n');
for ii = 1:length(KoffVec);
  
  ParamObj.Koff = KoffVec(ii);
  ParamObj.Kon   = ParamObj.KDinv * ParamObj.Koff;
  fprintf( 'Koff = %f\n',ParamObj.Koff );
  %   tic
  %   fprintf('Starting run \n')
  [A,C,DidIBreak,SteadyState] = ChemDiffMain(ParamObj,TimeObj,AnalysisObj);
  %   fprintf('Finished run\n')
  %   toc
  FluxMatKd1e2(ii,:) = Flux2ResR_rec;
  fprintf('Break = %d Steady = %d\n',DidIBreak,SteadyState)
end
fprintf('Finished Kd 1e2\n');

%Kd = 1e3;
ParamObj.KDinv = 1e3;
FluxMatKd1e3 = zeros( length(KoffVec), TimeObj.N_rec );
fprintf('\n\n Starting Kd 1e3\n\n');
for ii = 1:length(KoffVec);
  
  ParamObj.Koff = KoffVec(ii);
  ParamObj.Kon   = ParamObj.KDinv * ParamObj.Koff;
  fprintf( 'Koff = %f\n',ParamObj.Koff );
  %   tic
  %   fprintf('Starting run \n')
  [A,C,DidIBreak,SteadyState] = ChemDiffMain(ParamObj,TimeObj,AnalysisObj);
  %   fprintf('Finished run\n')
  %   toc
  FluxMatKd1e3(ii,:) = Flux2ResR_rec;
  fprintf('Break = %d Steady = %d\n',DidIBreak,SteadyState)
end
fprintf('Finished Kd 1e3\n');

%Kd = 1e4;
ParamObj.KDinv = 1e4;
FluxMatKd1e4 = zeros( length(KoffVec), TimeObj.N_rec );
fprintf('\n\n Starting Kd 1e4\n\n');
for ii = 1:length(KoffVec);
  
  ParamObj.Koff = KoffVec(ii);
  ParamObj.Kon   = ParamObj.KDinv * ParamObj.Koff;
  fprintf( 'Koff = %f\n',ParamObj.Koff );
  %   tic
  %   fprintf('Starting run \n')
  [A,C,DidIBreak,SteadyState] = ChemDiffMain(ParamObj,TimeObj,AnalysisObj);
  %   fprintf('Finished run\n')
  %   toc
  FluxMatKd1e4(ii,:) = Flux2ResR_rec;
  fprintf('Break = %d Steady = %d\n',DidIBreak,SteadyState)
end
fprintf('Finished Kd 1e4\n');

%Kd = 1e5;
ParamObj.KDinv = 1e5;
FluxMatKd1e5 = zeros( length(KoffVec), TimeObj.N_rec );
fprintf('\n\n Starting Kd 1e5\n\n');
for ii = 1:length(KoffVec);
  
  ParamObj.Koff = KoffVec(ii);
  ParamObj.Kon   = ParamObj.KDinv * ParamObj.Koff;
  fprintf( 'Koff = %f\n',ParamObj.Koff );
  %   tic
  %   fprintf('Starting run \n')
  [A,C,DidIBreak,SteadyState] = ChemDiffMain(ParamObj,TimeObj,AnalysisObj);
  %   fprintf('Finished run\n')
  %   toc
  FluxMatKd1e5(ii,:) = Flux2ResR_rec;
  fprintf('Break = %d Steady = %d\n',DidIBreak,SteadyState)
end
fprintf('Finished Kd 1e5\n');
%     cd /home/mws/Documents/MATLAB/Research/BG/DDFT/HRddft/Drive/IsoDiffCube
Time = datestr(now);
fprintf('Ending RunHydroGel: %s\n', Time)

% %Kd = 1e6;
% ParamObj.KDinv = 1e6;
% KoffVec = [1e0 1e1 1e2 1e3 1e4];
% FluxMatKd1e6 = zeros( length(KoffVec), TimeObj.N_rec );
% fprintf('\n\n Starting Kd 1e6\n\n');
% for ii = 1:length(KoffVec);
%
%   ParamObj.Koff = KoffVec(ii);
%   ParamObj.Kon   = ParamObj.KDinv * ParamObj.Koff;
%   fprintf( 'Koff = %f\n',ParamObj.Koff );
% %   tic
% %   fprintf('Starting run \n')
%   [A,C,DidIBreak,SteadyState] = ChemDiffMain(ParamObj,TimeObj,AnalysisObj);
% %   fprintf('Finished run\n')
% %   toc
%   FluxMatKd1e6(ii,:) = Flux2ResR_rec;
%   fprintf('Break = %d Steady = %d\n',DidIBreak,SteadyState)
% end
% fprintf('Finished Kd 1e6\n');
% %     cd /home/mws/Documents/MATLAB/Research/BG/DDFT/HRddft/Drive/IsoDiffCube
% Time = datestr(now);
% fprintf('Ending RunHydroGel: %s\n', Time)

%% Plot time
TimeVec = (0:TimeObj.N_rec-1) * t_rec;

% KdInv 1e1
figure()
hold all

for ii = 1:length(KoffVec)
  plot( TimeVec, FluxMatKd1e1(ii,:) )
end
plot( TimeVec, FluxMatKd0(1,:) );
xlabel('time'); ylabel('flux');
title('Kd^{-1} 10^{1} (Binding Affinity)');
Ax = gca;
Ax.YLim = [ 0 1e-3 ];

legcell = cell( length(KoffVec) + 1, 1 );
for i = 1:length(KoffVec)
  legcell{i} = ['Koff = ' num2str( KoffVec(i) ) ];
end
legcell{end} = 'No binding';
legend(legcell,'location','best');

% KdInv 1e2
figure()
hold all

for ii = 1:length(KoffVec)
  plot( TimeVec, FluxMatKd1e2(ii,:) )
end
plot( TimeVec, FluxMatKd0(1,:) );
xlabel('time'); ylabel('flux');
title('Kd^{-1} 10^{2} (Binding Affinity)');
Ax = gca;
Ax.YLim = [ 0 1e-3 ];

legcell = cell( length(KoffVec) + 1, 1 );
for i = 1:length(KoffVec)
  legcell{i} = ['Koff = ' num2str( KoffVec(i) ) ];
end
legcell{end} = 'No binding';
legend(legcell,'location','best');

% KdInv 1e3
figure()
hold all

for ii = 1:length(KoffVec)
  plot( TimeVec, FluxMatKd1e3(ii,:) )
end
plot( TimeVec, FluxMatKd0(1,:) );
xlabel('time'); ylabel('flux');
title('Kd^{-1} 10^{3} (Binding Affinity)');
Ax = gca;
Ax.YLim = [ 0 1e-3 ];

legcell = cell( length(KoffVec) + 1, 1 );
for i = 1:length(KoffVec)
  legcell{i} = ['Koff = ' num2str( KoffVec(i) ) ];
end
legcell{end} = 'No binding';
legend(legcell,'location','best');

% KdInv 1e4
figure()
hold all

for ii = 1:length(KoffVec)
  plot( TimeVec, FluxMatKd1e4(ii,:) )
end
plot( TimeVec, FluxMatKd0(1,:) );
xlabel('time'); ylabel('flux');
title('Kd^{-1} 10^{4} (Binding Affinity)');
Ax = gca;
Ax.YLim = [ 0 1e-3 ];

legcell = cell( length(KoffVec) + 1, 1 );
for i = 1:length(KoffVec)
  legcell{i} = ['Koff = ' num2str( KoffVec(i) ) ];
end
legcell{end} = 'No binding';
legend(legcell,'location','best');

% KdInv 1e5
figure()
hold all

for ii = 1:length(KoffVec)
  plot( TimeVec, FluxMatKd1e5(ii,:) )
end
plot( TimeVec, FluxMatKd0(1,:) );
xlabel('time'); ylabel('flux');
title('Kd^{-1} 10^{5} (Binding Affinity)');
Ax = gca;
Ax.YLim = [ 0 1e-3 ];

legcell = cell( length(KoffVec) + 1, 1 );
for i = 1:length(KoffVec)
  legcell{i} = ['Koff = ' num2str( KoffVec(i) ) ];
end
legcell{end} = 'No binding';
legend(legcell,'location','best');

%%
% MaxFluxKdKoff = zeros( 6, length(KoffVec) );
% 
% MaxFluxKdKoff(1,:) = FluxMatKd0(:,end)';
% MaxFluxKdKoff(2,:) = FluxMatKd1e1(:,end)';
% MaxFluxKdKoff(3,:) = FluxMatKd1e2(:,end)';
% MaxFluxKdKoff(4,:) = FluxMatKd1e3(:,end)';
% MaxFluxKdKoff(5,:) = FluxMatKd1e4(:,end)';
% MaxFluxKdKoff(6,:) = FluxMatKd1e5(:,end)';

MaxFluxKdKoff = zeros( 5, length(KoffVec) );

MaxFluxKdKoff(1,:) = FluxMatKd1e1(:,end)';
MaxFluxKdKoff(2,:) = FluxMatKd1e2(:,end)';
MaxFluxKdKoff(3,:) = FluxMatKd1e3(:,end)';
MaxFluxKdKoff(4,:) = FluxMatKd1e4(:,end)';
MaxFluxKdKoff(5,:) = FluxMatKd1e5(:,end)';

figure()
imagesc( KoffVec, 10.^(1:5),  MaxFluxKdKoff)
xlabel( 'Koff'); ylabel('KdInv');
title('Max Flux')
colorbar

