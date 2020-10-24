%% ZIZO response
clear all;
close all;
clc;
%%% zero-state and zero-input response
A=[-10 0 0 1;0.5 -3 0 1;0 2 -2 0;0 1 1 -1];
B=[1;1;0;1];C=[0 1 0 1];
D=0;
sys=ss(A,B,C,D); 
t=0:0.01:15;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% get the zero-state response
%% generate the input signal using the command gensig
U=gensig('square',2,15,0.01);
%%% get the response due to signal u, assume zero I.C.'s
x0=[0;0;0;0];  %%% define initial conditions
[yzs,xzs]=lsim(sys,U,t,x0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% now find the zero-input response
%%% use the command initial
x0=[-1;0.5;0;1];
[yzi,xzi]=initial(sys,x0,t);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Now find the response due to both u and x0
[y,x]=lsim(sys,U,t,x0);
%%%%%%%%%%%%%%%%%%%%%%%%%
%% compare
figure;
plot(t,y,t,yzs,'--',t,yzi,':')
legend('combined','zero-state','zero-input')
