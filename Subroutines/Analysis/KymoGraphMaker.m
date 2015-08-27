%%
clear
% close all

load('ConsNLNdFD_t19.mat')
L_box = 100;

data = A_rec+C_rec;
[rows,columns] = size(data);

%% 

% plot without endpoints
figure

image( x_trim, TimeRec,data ./ max(max(data)),'CDataMapping','scaled')
colormap gray
xlabel('Position')
ylabel('time')
titstr = sprintf('coupled chemical diffusion kymograph trial %d',trial);
title(titstr )

% plot with endpoint
AwEndPts = zeros(rows,columns+2);
CwEndPts = zeros(rows,columns+2);

AwEndPts(:,1)       = AL;
AwEndPts(:,2:end-1) = A_rec;
AwEndPts(:,end)     = AR;

CwEndPts(:,1)       = CL;
CwEndPts(:,2:end-1) = C_rec;
CwEndPts(:,end)     = CR;

x = [ 0 x_trim L_box];
data = AwEndPts + CwEndPts;
figure
image( x, TimeRec, data ./ max(max(data)),'CDataMapping','scaled')
colormap gray
xlabel('Position')
ylabel('time')
title(titstr)

%%
Nss    = 100;
SubSet = 1:Nss;

data = A_rec+C_rec;
data = data(:,SubSet);
% plot without endpoints
figure
image( x_trim(SubSet), TimeRec,data ./ max(max(data)),'CDataMapping','scaled')
colormap gray
xlabel('Position')
ylabel('time')
titstr = sprintf('coupled chemical diffusion kymograph trial %d',trial);
title(titstr )

% plot with endpoint
AwEndPts = zeros(rows,Nss+2);
CwEndPts = zeros(rows,Nss+2);

AwEndPts(:,1)        = AL;
AwEndPts(:,2:Nss+1 ) = A_rec(:,SubSet);
AwEndPts(:,Nss+2)    = A_rec(:,Nss +1);
 

CwEndPts(:,1)        = CL;
CwEndPts(:,2:Nss+1 ) = C_rec(:,SubSet);
CwEndPts(:,end)      = C_rec(:,Nss +1);


x = [ 0 x_trim(SubSet) x_trim(Nss+1)];
data = AwEndPts + CwEndPts;
figure
image( x, TimeRec, data ./ max(max(data)),'CDataMapping','scaled')
colormap gray
xlabel('Position')
ylabel('time')
title(titstr)

%%
Tsubset = 1:20; 
data = data(Tsubset,:);
% plot without endpoints
figure
image( x_trim, TimeRec(Tsubset),data ./ max(max(data)),'CDataMapping','scaled')
colormap gray
xlabel('Position')
ylabel('time')
titstr = sprintf('coupled chemical diffusion kymograph trial %d',trial);
title(titstr )

% plot with endpoint
AwEndPts = zeros(rows,columns+2);
CwEndPts = zeros(rows,columns+2);

AwEndPts(:,1)       = AL;
AwEndPts(:,2:end-1) = A_rec;
AwEndPts(:,end)     = AR;

CwEndPts(:,1)       = CL;
CwEndPts(:,2:end-1) = C_rec;
CwEndPts(:,end)     = CR;

x = [ 0 x_trim L_box];
data = AwEndPts + CwEndPts;
data = data(Tsubset,:);
figure
image( x, TimeRec(Tsubset), data ./ max(max(data)),'CDataMapping','scaled')
colormap gray
xlabel('Position')
ylabel('time')
title(titstr)
