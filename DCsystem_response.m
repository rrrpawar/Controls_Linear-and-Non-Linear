%% program DCsystem.m
clear all;
clc;
global kT kb R L N Je;
%%%% simulation of dc motor
kT=0.05;kb=0.05;R=1.2;L=0.05;Jm=8e-4;Jl=0.02;N=12;  %%% define the parameters
Je=Jl+N^2*Jm;  %%% calculate Je
t0=0;       %%% define the initial time
tf=4;       %%% define the final time
nsteps = 100;             % Number of time steps in [t0,tf]
hsteps = (tf-t0)/nsteps;   % step size
tspan = t0:hsteps:tf;
options = odeset('JConstant','on', 'RelTol',1e-6, 'AbsTol',1e-6);
x0=[0 0 0];    %%% define initial condition
[t,x] = ode45('DCxprime1',tspan,x0,options);
figure(2)
plot(t,x(:,1),t,x(:,2),t,x(:,3)),title('Response of DC Motor')
xlabel('Time (sec)')
legend('shaft angle \theta(t)','angular velocity \omega(t)','current i(t)','Location','SouthWest')

% FUNCTION DCXprime1.M
function dx = DCxprime1(t,x)
global kT kb R L N Je;
dx = zeros(3,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Va=3;% Va=3 and change direction after 2
Tl=1;% Tl=0;
if t>2
   Va=-3;
end
dx(1)=x(2);
dx(2)=N*kT/Je*x(3)-1/Je*Tl;
dx(3)=-N*kb/L*x(2)-R/L*x(3)+1/L*Va;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  end of DCxprime1.m