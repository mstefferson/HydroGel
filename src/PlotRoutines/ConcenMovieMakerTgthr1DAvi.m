function  ConcenMovieMakerTgthr1DAvi(videoName,A_rec, C_rec,...
  x,TimeRec,nFrames,Kon,Koff,Dnl,nu,Bt,Ka)

% Video Write stuff
Mov = VideoWriter(videoName);
Mov.FrameRate = 4;
open(Mov);

% Set up figure
Fig = figure();
set(Fig, 'WindowStyle', 'normal');
PosVec = [680 558 1200 800];
Fig.Position = PosVec;

ax1 = subplot(1,2,1);
set(ax1, 'nextplot','replacechildren')
ax2 = subplot(1,2,2);
set(ax2, 'nextplot','replacechildren')

% Plot limits
lLimF1 = min( min( A_rec + C_rec ) );
uLimF1 = max( max( A_rec + C_rec ) );

lLimF2 = 0;
uLimF2 = max(Bt) + max(Bt) / 10;

set(Fig,'renderer','zbuffer')

%Titles
TitlStr1 = sprintf('[A]+[C]');
TitlStr2 = sprintf('B');

% If Bt is constant, have it a vec for plotting
if length(Bt) == 1
  Bt = Bt * ones(1, length(x) );
end

for ii = 1:nFrames
  subplot(ax1)
  LinObj = plot(x, ...
    [A_rec(:,ii)'; C_rec(:,ii)'; A_rec(:,ii)' + C_rec(:,ii)' ]  );
  LinObj(1).LineWidth = 2; LinObj(2).LineWidth = 2; LinObj(3).LineWidth = 2;
  title(TitlStr1)
  xlabel('x');ylabel('Concentration');
  set(gca,'YLim', [lLimF1 uLimF1] )
  legend('A','C','A+C')
  
  subplot(ax2)
  LinObj = plot(x, [Bt;  ( Bt' - C_rec(:,ii) )' ] );
  LinObj(1).LineWidth = 2; LinObj(2).LineWidth = 2;
  ParamStr = sprintf(...
    ' t = %.1g \n Bt = %.1g \n Ka = %.1g \n nu = %.1g \n beta = %.1g \n Kon = %.1g \n Koff = %.1g \n ', ...
    TimeRec(ii), max(Bt), Ka, nu, Dnl,Kon, Koff );
  textbp(ParamStr)
  title(TitlStr2)
  xlabel('x');ylabel('Concentration');
  legend('Bt','B_{free}')
  set(gca,'YLim', [lLimF2 uLimF2] )
  
  pause( 0.01 ); drawnow;
  
  Fr = getframe(Fig,[0 0 PosVec(3) PosVec(4)]);
  writeVideo(Mov,Fr);
  
end

% keyboard
% close all
close(Mov)
