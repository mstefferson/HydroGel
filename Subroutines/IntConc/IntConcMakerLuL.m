% Makes the initial concentration for labeled and unlabeled species
% with known boundary concentrations of species A labeled and saturated
% unlabeled.

function [ALab,ALablin,AuLab,CLab,CLablin,CLabL,CLabR,CuLab] = ...
    IntConcMakerLuL(ALabL, ALabR, AuLi,Bt, KDinv, Lbox, x,linearEq)

% [A,Ass,Ap,ApFT] = IntConcAcalcExp(AL, AR, L_box,x,lambda);
% [A,Ass,Ap,ApFT] = IntConcAtanhStep(AL, AR, L_box,x,lambda);
[ALab,ALablin] = IntConcAcalcStepL(ALabL, ALabR, Lbox,x);
[AuLab] = IntConcAcalcStepUl(AuLi,x);
% keyboard

[CLab,CLablin,CLabL,CLabR] = ...
    IntConcCcalcEql(ALab,ALabL,ALabR,Bt,KDinv,linearEq,Lbox,x);
CLab(1) = 0; CLab(end) = 0;

[CuLab,~,~,~] = ...
    IntConcCcalcEql(AuLab,AuLi,AuLi,Bt,KDinv,linearEq,Lbox,x);

end