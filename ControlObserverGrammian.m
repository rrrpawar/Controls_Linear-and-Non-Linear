clear all;
close all;
clc;
%%%%%%%%%% check controllability and observability
A=[-3/2 1/2;1/2 -3/2];B=[1/2;1/2];C=[1 -1];D=0;
%% we need to check the rank of the observability grammian
G=ss(A,B,C,D); %% convert and store as a state space model
gram(G,'o')
rank(gram(G,'o'))
% for observability, we should have the rank equal to 2;
%% however, it is only 1, so the system is not observable.
%% let's find another way to check observability
N=[C;C*A]
rank(N)
obsv(A,C)
rank(obsv(A,C))
%% once again, the rank is 1--not observable.
%% let's check controllability
gram(G,'c')
rank(gram(G,'c'))
Q=[B A*B]
rank(Q)
ctrb(A,B)
%% the system is not controllable!
