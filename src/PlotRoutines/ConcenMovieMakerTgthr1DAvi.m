unction  ConcenMovieMakerTgthr1DAvi(videoName,A_rec, C_rec,...
  x,TimeRec,nFrames,Kon,Koff,Dnl,Da,Dc,Bt,Ka)

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
  hl = legend('A','C','A+C');
  hl.Interpreter = 'latex';
  
  subplot(ax2)
  LinObj = plot(x, [Bt;  ( Bt' - C_rec(:,ii) )' ] );
  LinObj(1).LineWidth = 2; LinObj(2).LineWidth = 2;
  
  title(TitlStr2)
  xlabel('x');ylabel('Concentration');
  % legend
  hl = legend('$$B_t$$','$$B_{free}$$');
  hl.Interpreter = 'latex';
  set(gca,'YLim', [lLimF2 uLimF2] )
  % text
  ParamStr = sprintf(...
    ' t = %.1g \n $$B_t$$ = %.1g \n $$K_A$$ = %.1g \n $$D_A$$ = %.1g \n $$D_C$$ = %.1g \n $$beta$$ = %.1g \n $$k_{on}B_t$$ = %.1g \n $$k_{on} = %.1g \n $$k_{off}$$ = %.1g \n ', ...
    TimeRec(ii), max(Bt), Ka, Da, Dc, Dnl,Kon*max(Bt), Kon,Koff );
  tl = text(0,0,ParamStr);
  tl.Position =  [0.4743 mean(Bt)/2 0];
  
  pause( 0.01 ); drawnow;
  
  Fr = getframe(Fig,[0 0 PosVec(3) PosVec(4)]);
  writeVideo(Mov,Fr);
  
end

% keyboard
% close all
close(Mov)
