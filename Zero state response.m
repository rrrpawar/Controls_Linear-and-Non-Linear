%%% zero-state and zero-input response
kb=0.05;kT=0.05;R=1.2;L=0.05;Jm=8e-4;Jl=0.02;N=12;Je=Jl+N^2*Jm;  
A=[0 1 0;0 0 N*kT/Je;0 -N*kb/L -R/L];  
B=[0 0;0 -1/Je;1/L 0];
C=[1 0 0;0 1 0];
D=zeros(2,2);
%%% you can define the system as:
sys=ss(A,B,C,D); 
t=0:0.01:4;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% get the zero-state response
%% generate the input signal using the command gensig
U(2,:)=gensig('square',2,4,0.01);  %signal type, period, total time duration, spacing%% use sin(pi*t), i.e. period=2
U(1,:)=3;
%plot(0:0.01:4,u);
%%% get the response due to signal u, assume zero I.C.'s
x0=[0;0;0];  %%% define initial conditions
[yzs,xzs]=lsim(sys,U,t,x0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% now find the zero-input response
%%% use the command initial
x0=[2;3;-1];
[yzi,xzi]=initial(sys,x0,t);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Now find the response due to both u and x0
[y,x]=lsim(sys,U,t,x0);
%%%%%%%%%%%%%%%%%%%%%%%%%
%% compare
figure;
plot(t,y(:,1),t,yzs(:,1),'--',t,yzi(:,1),'*')
legend('combined','zero-state','zero-input')
title('\theta')
figure;
plot(t,y(:,2),t,yzs(:,2),'--',t,yzi(:,2),'*')
legend('combined','zero-state','zero-input')
title('\omega')

