sectionsInt = 1;

%%
dtvec = [1e-2 1e-3 1e-4];

load('ConsNLNdFD_t20.mat')
[IntPart20,FinPart20,MinPart20,MaxPart20] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t21.mat')
[IntPart21,FinPart21,MinPart21,MaxPart21] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t22.mat')
[IntPart22,FinPart22,MinPart22,MaxPart22] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

MinVec = [MinPart20 MinPart21 MinPart22];
FinVec = [FinPart20 FinPart21 FinPart22];

figure
plot(dtvec,MinVec ,dtvec,FinVec)
legend('Minimum','Final')
xlabel('dt'); ylabel('Particle Number')

%%
dtvec = [1e-2 1e-3 1e-4];

load('ConsNLNdFD_t23.mat')
[IntPart23,FinPart23,MinPart23,MaxPart23] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t24.mat')
[IntPart24,FinPart24,MinPart24,MaxPart24] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t25.mat')
[IntPart25,FinPart25,MinPart25,MaxPart25] = ConservDenCheck(x,A_rec,C_rec,TimeRec);


MinVec = [MinPart23 MinPart24 MinPart25];
FinVec = [FinPart23 FinPart24 FinPart25];

figure
plot(dtvec,MinVec ,dtvec,FinVec)
legend('Minimum','Final')
xlabel('dt'); ylabel('Particle Number')


%%
dtvec = [1e-2 1e-3 1e-4];

load('ConsNLNdFD_t20.mat')
[IntPart20,FinPart20,MinPart20,MaxPart20] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t21.mat')
[IntPart21,FinPart21,MinPart21,MaxPart21] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t22.mat')
[IntPart22,FinPart22,MinPart22,MaxPart22] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t23.mat')
[IntPart23,FinPart23,MinPart23,MaxPart23] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t24.mat')
[IntPart24,FinPart24,MinPart24,MaxPart24] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t25.mat')
[IntPart25,FinPart25,MinPart25,MaxPart25] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

MinVec1 = [MinPart20 MinPart21 MinPart22 ];
FinVec1 = [FinPart20 FinPart21 FinPart22 ];
IntVec = [IntPart20 IntPart21 IntPart22 ];

MinVec2 = [MinPart23 MinPart24 MinPart25 ];
FinVec2 = [FinPart23 FinPart24 FinPart25 ];


figure(2)
plot(dtvec,MinVec1,dtvec,MinVec2,dtvec,FinVec1,dtvec,FinVec2,dtvec,IntVec)
legend('Min Euler','Min AB','Final Euler','Final AB','Intial')
xlabel('dt'); ylabel('Particle Number')

%%
% N all
sectionsInt = 1;
Nloop      = [12 16 20 24 29 32];

if sectionsInt
    load('ConsNLNdFD_t30.mat')
    [IntPart30,FinPart30,MinPart30,MaxPart30] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t31.mat')
    [IntPart31,FinPart31,MinPart31,MaxPart31] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t32.mat')
    [IntPart32,FinPart32,MinPart32,MaxPart32] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t33.mat')
    [IntPart33,FinPart33,MinPart33,MaxPart33] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t34.mat')
    [IntPart34,FinPart34,MinPart34,MaxPart34] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t35.mat')
    [IntPart35,FinPart35,MinPart35,MaxPart35] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
else
    load('ConsNLNdFD_t30.mat')
    [IntPart30,FinPart30,MinPart30,MaxPart30] =  ConservDenCheck(x,A_rec,C_rec,TimeRec);
    
    load('ConsNLNdFD_t31.mat')
    [IntPart31,FinPart31,MinPart31,MaxPart31] =  ConservDenCheck(x,A_rec,C_rec,TimeRec);
    
    load('ConsNLNdFD_t32.mat')
    [IntPart32,FinPart32,MinPart32,MaxPart32] =  ConservDenCheck(x,A_rec,C_rec,TimeRec);
    
    load('ConsNLNdFD_t33.mat')
    [IntPart33,FinPart33,MinPart33,MaxPart33] = ConservDenCheck(x,A_rec,C_rec,TimeRec);
    
    load('ConsNLNdFD_t34.mat')
    [IntPart34,FinPart34,MinPart34,MaxPart34] = ConservDenCheck(x,A_rec,C_rec,TimeRec);
    
    load('ConsNLNdFD_t35.mat')
    [IntPart35,FinPart35,MinPart35,MaxPart35] = ConservDenCheck(x,A_rec,C_rec,TimeRec);
end

MinVec = [MinPart30 MinPart31 MinPart32 FinPart33 FinPart34 FinPart35];
FinVec = [FinPart30 FinPart31 FinPart32 FinPart33 FinPart34 FinPart35 ];
IntVec = [IntPart30 IntPart31 IntPart32 IntPart33 IntPart34 IntPart35];

figure(32)
plot(Nloop,MinVec,Nloop,FinVec,Nloop,IntVec)
legend('Min','Fin','Int')
xlabel('N (left,mid,right)'); ylabel('Particle Number')

%%
% Nm
Nloop      = [12 16 20 24 28 32];

if sectionsInt
    load('ConsNLNdFD_t40.mat')
    [IntPart40,FinPart40,MinPart40,MaxPart40] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t41.mat')
    [IntPart41,FinPart41,MinPart41,MaxPart41] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t42.mat')
    [IntPart42,FinPart42,MinPart42,MaxPart42] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t43.mat')
    [IntPart43,FinPart43,MinPart43,MaxPart43] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t44.mat')
    [IntPart44,FinPart44,MinPart44,MaxPart44] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t45.mat')
    [IntPart45,FinPart45,MinPart45,MaxPart45] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
else
    load('ConsNLNdFD_t40.mat')
    [IntPart40,FinPart40,MinPart40,MaxPart40] = ConservDenCheck(x,A_rec,C_rec,TimeRec);
    
    load('ConsNLNdFD_t41.mat')
    [IntPart41,FinPart41,MinPart41,MaxPart41] =  ConservDenCheck(x,A_rec,C_rec,TimeRec);
    
    load('ConsNLNdFD_t42.mat')
    [IntPart42,FinPart42,MinPart42,MaxPart42] =  ConservDenCheck(x,A_rec,C_rec,TimeRec);
    
    load('ConsNLNdFD_t43.mat')
    [IntPart43,FinPart43,MinPart43,MaxPart43] = ConservDenCheck(x,A_rec,C_rec,TimeRec);
    
    load('ConsNLNdFD_t44.mat')
    [IntPart44,FinPart44,MinPart44,MaxPart44] = ConservDenCheck(x,A_rec,C_rec,TimeRec);
    
    load('ConsNLNdFD_t45.mat')
    [IntPart45,FinPart45,MinPart45,MaxPart45] = ConservDenCheck(x,A_rec,C_rec,TimeRec);
end

MinVec = [MinPart40 MinPart41 MinPart42 FinPart43 FinPart44 FinPart45];
FinVec = [FinPart40 FinPart41 FinPart42 FinPart43 FinPart44 FinPart45 ];
IntVec = [IntPart40 IntPart41 IntPart42 IntPart43 IntPart44 IntPart45];

figure(4)
plot(Nloop,MinVec,Nloop,FinVec,Nloop,IntVec)
legend('Min','Fin','Int')
xlabel('N mid)'); ylabel('Particle Number')

%%
% Nl Nr
Nloop      = [12 16 20 24 28 32];

if sectionsInt
    load('ConsNLNdFD_t50.mat')
    [IntPart50,FinPart50,MinPart50,MaxPart50] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t51.mat')
    [IntPart51,FinPart51,MinPart51,MaxPart51] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t52.mat')
    [IntPart52,FinPart52,MinPart52,MaxPart52] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t55.mat')
    [IntPart53,FinPart53,MinPart53,MaxPart53] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t54.mat')
    [IntPart54,FinPart54,MinPart54,MaxPart54] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t55.mat')
    [IntPart55,FinPart55,MinPart55,MaxPart55] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
else
    load('ConsNLNdFD_t50.mat')
[IntPart50,FinPart50,MinPart50,MaxPart50] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t51.mat')
[IntPart51,FinPart51,MinPart51,MaxPart51] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t52.mat')
[IntPart52,FinPart52,MinPart52,MaxPart52] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t53.mat')
[IntPart53,FinPart53,MinPart53,MaxPart53] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t54.mat')
[IntPart54,FinPart54,MinPart54,MaxPart54] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t55.mat')
 [IntPart55,FinPart55,MinPart55,MaxPart55] = ConservDenCheck(x,A_rec,C_rec,TimeRec);
end

[IntPart55,FinPart55,MinPart55,MaxPart55] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

MinVec = [MinPart50 MinPart51 MinPart52 FinPart53 FinPart54 FinPart55];
FinVec = [FinPart50 FinPart51 FinPart52 FinPart53 FinPart54 FinPart55 ];
IntVec = [IntPart50 IntPart51 IntPart52 IntPart53 IntPart54 IntPart55];

figure(5)
plot(Nloop,MinVec,Nloop,FinVec,Nloop,IntVec)
legend('Min','Fin','Int')
xlabel('N left right)'); ylabel('Particle Number')

%%
% Lm
Lmloop     = [1 5 10 15 20 25];
if sectionsInt
    load('ConsNLNdFD_t60.mat')
    [IntPart60,FinPart60,MinPart60,MaxPart60] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t61.mat')
    [IntPart61,FinPart61,MinPart61,MaxPart61] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t62.mat')
    [IntPart62,FinPart62,MinPart62,MaxPart62] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t63.mat')
    [IntPart63,FinPart63,MinPart63,MaxPart63] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t64.mat')
    [IntPart64,FinPart64,MinPart64,MaxPart64] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t65.mat')
    [IntPart65,FinPart65,MinPart65,MaxPart65] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
else
load('ConsNLNdFD_t60.mat')
[IntPart60,FinPart60,MinPart60,MaxPart60] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t61.mat')
[IntPart61,FinPart61,MinPart61,MaxPart61] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t62.mat')
[IntPart62,FinPart62,MinPart62,MaxPart62] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t63.mat')
[IntPart63,FinPart63,MinPart63,MaxPart63] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t64.mat')
[IntPart64,FinPart64,MinPart64,MaxPart64] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t65.mat')
[IntPart65,FinPart65,MinPart65,MaxPart65] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

end

MinVec = [MinPart60 MinPart61 MinPart62 FinPart63 FinPart64 FinPart65];
FinVec = [FinPart60 FinPart61 FinPart62 FinPart63 FinPart64 FinPart65 ];
IntVec = [IntPart60 IntPart61 IntPart62 IntPart63 IntPart64 IntPart65];

figure(6)
plot(Lmloop,MinVec,Lmloop,FinVec,Lmloop,IntVec)
legend('Min','Fin','Int')
xlabel('Lmid'); ylabel('Particle Number')

%%
%%
% Lres
Lresloop   = [50 100 150 200 250 300];

if sectionsInt
    load('ConsNLNdFD_t70.mat')
    [IntPart70,FinPart70,MinPart70,MaxPart70] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t71.mat')
    [IntPart71,FinPart71,MinPart71,MaxPart71] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t72.mat')
    [IntPart72,FinPart72,MinPart72,MaxPart72] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t73.mat')
    [IntPart73,FinPart73,MinPart73,MaxPart73] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t74.mat')
    [IntPart74,FinPart74,MinPart74,MaxPart74] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t75.mat')
    [IntPart75,FinPart75,MinPart75,MaxPart75] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
else


load('ConsNLNdFD_t70.mat')
[IntPart70,FinPart70,MinPart70,MaxPart70] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t71.mat')
[IntPart71,FinPart71,MinPart71,MaxPart71] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t72.mat')
[IntPart72,FinPart72,MinPart72,MaxPart72] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t73.mat')
[IntPart73,FinPart73,MinPart73,MaxPart73] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t74.mat')
[IntPart74,FinPart74,MinPart74,MaxPart74] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t75.mat')
[IntPart75,FinPart75,MinPart75,MaxPart75] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

end

MinVec = [MinPart70 MinPart71 MinPart72 FinPart73 FinPart74 FinPart75];
FinVec = [FinPart70 FinPart71 FinPart72 FinPart73 FinPart74 FinPart75 ];
IntVec = [IntPart70 IntPart71 IntPart72 IntPart73 IntPart74 IntPart75];

figure(7)
% plot(Lresloop,MinVec,Lresloop,FinVec,Lresloop,IntVec)
plot(Lresloop,MinVec./IntVec,Lresloop,FinVec./IntVec)

legend('Min','Fin','Int')
xlabel('L reserv'); ylabel('Particle Number')

%% L R Diff
DiffLRLoop   = [1 50 100 150 200 250];


if sectionsInt
    load('ConsNLNdFD_t80.mat')
    [IntPart80,FinPart80,MinPart80,MaxPart80] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t81.mat')
    [IntPart81,FinPart81,MinPart81,MaxPart81] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t82.mat')
    [IntPart82,FinPart82,MinPart82,MaxPart82] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t83.mat')
    [IntPart83,FinPart83,MinPart83,MaxPart83] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t84.mat')
    [IntPart84,FinPart84,MinPart84,MaxPart84] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t85.mat')
    [IntPart85,FinPart85,MinPart85,MaxPart85] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
else

load('ConsNLNdFD_t80.mat')
[IntPart80,FinPart80,MinPart80,MaxPart80] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t81.mat')
[IntPart81,FinPart81,MinPart81,MaxPart81] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t82.mat')
[IntPart82,FinPart82,MinPart82,MaxPart82] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t83.mat')
[IntPart83,FinPart83,MinPart83,MaxPart83] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t84.mat')
[IntPart84,FinPart84,MinPart84,MaxPart84] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t85.mat')
[IntPart85,FinPart85,MinPart85,MaxPart85] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

end

MinVec = [MinPart80 MinPart81 MinPart82 FinPart83 FinPart84 FinPart85];
FinVec = [FinPart80 FinPart81 FinPart82 FinPart83 FinPart84 FinPart85 ];
IntVec = [IntPart80 IntPart81 IntPart82 IntPart83 IntPart84 IntPart85];

figure(8)
plot(DiffLRLoop ,MinVec,DiffLRLoop ,FinVec,DiffLRLoop ,IntVec)


legend('Min','Fin','Int')
xlabel('L R diff'); ylabel('Particle Number')

%% nu Diff
sectionsInt = 1;
DiffnuLoop = [0 0.2 0.4 0.6 0.8 1];
if sectionsInt
    load('ConsNLNdFD_t90.mat')
    [IntPart90,FinPart90,MinPart90,MaxPart90] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t91.mat')
    [IntPart91,FinPart91,MinPart91,MaxPart91] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t92.mat')
    [IntPart92,FinPart92,MinPart92,MaxPart92] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t93.mat')
    [IntPart93,FinPart93,MinPart93,MaxPart93] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t94.mat')
    [IntPart94,FinPart94,MinPart94,MaxPart94] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
    
    load('ConsNLNdFD_t95.mat')
    [IntPart95,FinPart95,MinPart95,MaxPart95] =  ConservDenCheckSec(A_rec,B_rec,C_rec,Ll,Lm,Lr,Nl,Nm,Nr,TimeRec,0);
else


load('ConsNLNdFD_t90.mat')
[IntPart90,FinPart90,MinPart90,MaxPart90] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t91.mat')
[IntPart91,FinPart91,MinPart91,MaxPart91] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t92.mat')
[IntPart92,FinPart92,MinPart92,MaxPart92] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t93.mat')
[IntPart93,FinPart93,MinPart93,MaxPart93] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t94.mat')
[IntPart94,FinPart94,MinPart94,MaxPart94] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

load('ConsNLNdFD_t95.mat')
[IntPart95,FinPart95,MinPart95,MaxPart95] = ConservDenCheck(x,A_rec,C_rec,TimeRec);

end

MinVec = [MinPart90 MinPart91 MinPart92 FinPart93 FinPart94 FinPart95];
FinVec = [FinPart90 FinPart91 FinPart92 FinPart93 FinPart94 FinPart95 ];
IntVec = [IntPart90 IntPart91 IntPart92 IntPart93 IntPart94 IntPart95];

figure(9)
plot(DiffnuLoop,MinVec,DiffnuLoop,FinVec,DiffnuLoop,IntVec)


legend('Min','Fin','Int')
xlabel('nu diff'); ylabel('Particle Number')