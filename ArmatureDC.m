%% DC Armature
clear all;
clc;
%%%% simulation of dc motor
kT=0.05;kb=0.05;R=1.2;L=0.05;Jm=8e-4;Jl=0.02;N=12;  %%% define the parameters
Je=Jl+N^2*Jm;  %%% calculate Je
A=[0 1 0;0 0 N*kT/Je;0 -N*kb/L -R/L];   %% set-up the A matrix
B=[0 0;0 -1/Je;1/L 0];   %%% set-up the B matrix
C=[1 0 0;0 1 0];  %%% set-up the C matrix
D=zeros(2,2);  %%%%% define the D matrix (feedforward)
t=0:0.01:4; %%% define the time vector
%%%%% now define the input vector U (dimension is 2 x 401)
Va=3;
Tl=1;
for i=1:length(t)
U(1,i)=Va;% Va=0;
U(2,i)=Tl;
  if t(i)>2
    U(1,i)=-Va;
  end
end
x0=[0;0;0];  %%% define initial conditions
[y,x]=lsim(A,B,C,D,U,t,x0); %Simulate time response of dynamic systems to arbitrary inputs.
figure(1)
plot(t,x(:,1),t,x(:,2),t,x(:,3))
legend('shaft angle \theta(t)','angular velocity \omega(t)','current i(t)','Location','SouthWest')
xlabel('Time (sec)')
ylabel('State variables')
title('Time response of dc servo')
%%% to print it, simply type print
%%% to save it as a postscript file, type   print -dps plot1.ps