%%%%% Reduced order Observer
clear all;
clc;
A=[-11 86 261 -56;3 0 -3 1;-1 1 4 -1;1 0 -1 0];  
B=[1;0;2;0];
C=[1 0 0 0;0 0 0 1;0 0 1 0];
D=zeros(3,1);
%%%%% generate the Plant
%%consider as initial conditions:
x0=[2;-20;5;-7];
%% and as input u=sin(3*t)
t=0:0.01:4; u=sin(3*t);
[Yp,Xp]=lsim(A,B,C,D,u,t,x0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Define R
R=[0 1 0 0];
%% Define W
W=[C;R];
%% define Abar=W*A*inv(W), Bbar = W*B;
Abar=W*A*inv(W); Bbar=W*B;
Cbar=C*inv(W);
A11=Abar(1:3,1:3); A12=Abar(1:3,4);
A21=Abar(4,1:3);   A22=Abar(4,4);
B1=Bbar(1:3); B2=Bbar(4);  L=[0 0 2];
%% find equation for psi
%% psi'=(A22-L*A12)psi+((A22-L*A12)*L+A21-L*A11)z1+(B2-L*B1)u
Apsi=(A22-L*A12)*L+A21-L*A11;
Bpsi=B2-L*B1;
psi=lsim(A22-L*A12,[Apsi Bpsi],1,0,[Yp';u],t,0);
%%%%% find the estimate of the vector x
xhat=inv(W)*[Yp';psi'+L*Yp'];
%% in fact, the estimate of the component x2 is psi+Ly
xhat2=psi'+L*Yp'; %% OR equivalently xhat2=xhat(2,:);
plot(t,xhat(2,:),t,Xp(:,2),'--')
legend('estimate of x_{2}','true x_{2}')
xlabel('Time (sec)')