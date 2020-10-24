%% Bode plot
clear all;
clc;
t0=0;       %%% define the initial time
tf=15;       %%% define the final time
nsteps = 100;             % Number of time steps in [t0,tf]
hsteps = (tf-t0)/nsteps;   % step size
tspan = t0:hsteps:tf;
options = odeset('JConstant','on', 'RelTol',1e-6, 'AbsTol',1e-6);
x0=[0 0];    %%% define initial condition
[t,x] = ode45('Matlabodeprime',tspan,x0,options);
figure(3)
plot(t,x(:,1),t,x(:,2))
legend('x1','x2')
y(:,1)=x(:,1)+x(:,2);
y(:,2)=x(:,1)+0.1*cos(t);
figure(4)
plot(t,y(:,1),t,y(:,2))
legend('y1','y2')




