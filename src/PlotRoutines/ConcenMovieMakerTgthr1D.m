function [M_All] = ...
  ConcenMovieMakerTgthr1D(videoName, A_rec, C_rec, Bt,...
  x, TimeRec, paramStr, gridStr, concStr, saveMe)
% set-up movies differently depending on save
nFrames = length(TimeRec);
if saveMe
  % Video Write stuff
  Mov = VideoWriter(videoName);
  Mov.FrameRate = 4;
  open(Mov);
  M_All = 0;
else
  %Initialize the movie structure array
  M_All(nFrames)  = struct('cdata',zeros(N,N,3,'int8'), 'colormap',[]);
end
% smallest screen dimension
ScreenSize = get(0,'screensize');
ScreenWidth = ScreenSize(3); ScreenHeight = ScreenSize(4);
FigWidth    = floor( ScreenWidth * .6 );
FigHeight   =  floor( ScreenHeight * .8);
FigPos      = [ floor( 0.5 * ( ScreenWidth - FigWidth ) ) ...
  floor( 0.5 * (ScreenHeight - FigHeight ) ) ...
  FigWidth FigHeight];
%Build a square box set by smallest dimension of screen
Fig = figure();
Fig.WindowStyle = 'normal';
Fig.Position = FigPos;
% Axis
ax1 = subplot(1,2,1);
set(ax1, 'nextplot','replacechildren')
ax2 = subplot(1,2,2);
set(ax2, 'nextplot','replacechildren')
% Plot limits
lLimF1 = min( min( A_rec + C_rec ) );
uLimF1 = max( max( A_rec + C_rec ) );
lLimF2 = 0;
uLimF2 = max(Bt) + max(Bt) / 10;
% Set up zbuffer
set(Fig,'renderer','zbuffer')
%Titles
TitlStr1 = sprintf('[A]+[C]');
TitlStr2 = sprintf('$$ B_t $$');
% If Bt is constant, have it a vec for plotting
if length(Bt) == 1
  Bt = Bt * ones(1, length(x) );
end
% loop over frames
for ii = 1:nFrames
  % get the time
  timeStr = [ ' t = ' num2str( TimeRec(ii), '%.2f' ) ];
  % plot A,C
  subplot(ax1)
  LinObj = plot(x, ...
    [A_rec(:,ii)'; C_rec(:,ii)'; A_rec(:,ii)' + C_rec(:,ii)' ]  );
  LinObj(1).LineWidth = 2; LinObj(2).LineWidth = 2; LinObj(3).LineWidth = 2;
  title([ TitlStr1 timeStr ] )
  xlabel('x');ylabel('Concentration');
  set(gca,'YLim', [lLimF1 uLimF1] )
  hl = legend('A','C','A+C');
  hl.Interpreter = 'latex';
  % plot B
  subplot(ax2)
  LinObj = plot(x, [Bt;  ( Bt' - C_rec(:,ii) )' ] );
  LinObj(1).LineWidth = 2; LinObj(2).LineWidth = 2;
  title([ TitlStr2 timeStr ] )
  xlabel('x');ylabel('Concentration');
  % legend
  hl = legend('$$B_t$$','$$B_{free}$$');
  hl.Interpreter = 'latex';
  set(gca,'YLim', [lLimF2 uLimF2] )
  % text
  %paramStr1 = sprintf(...
    %'t = %.1g \n $$B_t$$ = %.1g \n $$K_A$$ = %.1g \n $$D_A$$ = %.1g \n', ...
    %TimeRec(ii), max(Bt), Ka(1), Da );
  %paramStr2 = sprintf(...
    %'$$D_C$$ = %.1g \n $$ \beta $$ = %.1g \n',  Dc(1), Dnl );
  %paramStr3 = sprintf(...
    %'$$k_{on}$$ = %.1g \n $$k_{off}$$ = %.1g \n ', Kon(1), Koff(1) );
  %paramStr = [paramStr1 paramStr2 paramStr3];
  %tl = text(0,0,paramStr);
  %tl.Position =  [0.4743 mean(Bt)/2 0];
  %tl.Interpreter = 'latex';
  try
    textbp(paramStr)
    textbp(gridStr)
    textbp(concStr)
  catch err
      fprintf('%s', err.getReport('extended')) ;
  end
  % pause, draw, and record
  drawnow; pause( 0.01 );
  if saveMe
    Fr = getframe(Fig);
    writeVideo(Mov,Fr);
  else
    M_All(ii) = getframe(gcf); %Store the frame
  end
end
if saveMe
  close(Mov);
end

