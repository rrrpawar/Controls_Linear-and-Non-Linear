%% DC servo
global A B K uex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t0=0; tf=5;      
x0=[-4;0.5;-2]; %% define initial conditions
%%%% set-up the A, B and C matrices;
A=[0 1 0;0 0 4.438;0 -12 -24];
B=[0;0;20];C=[1 0 0];
yd=15.0; %% desired set-point for output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% closed loop simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   nsteps = 500;             % Number of time steps in [t0,tf]
   hsteps = (tf-t0)/nsteps;   % step size
   tspan = t0:hsteps:tf;
   options = odeset('JConstant','on', 'RelTol',1e-6, 'AbsTol',1e-6);
   disp('Before integrating the closed loop system')
%%%% try 2 different feedback gains
   % place the closed loop poles at -5,-5+.25j,-5-.25j
   K=place(A,B,[-5 -5+0.25*j -5-0.25*j]);  
   uex=-inv(C*inv(A-B*K)*B)*yd;
   [t,x_cl1] = ode23s('xprimesetpt_cl',tspan,x0,options);
%%%%%%%
   % place the closed loop poles at -3,-2+6j,-2-6j
   K=place(A,B,[-3 -2+6*j -2-6*j]);
   uex=-inv(C*inv(A-B*K)*B)*yd;
   [t,x_cl2] = ode23s('xprimesetpt_cl',tspan,x0,options);
   disp('After integrating the closed loop system')
   %% evaluate the output for each case
   y1 = C*x_cl1';
   y2 = C*x_cl2';
   plot(t,y1,t,y2,':',t,yd*ones(length(t)),'r--')
   title('Response of DC-servo')
   legend('\theta_{1}(t)','\theta_{2}(t)','\theta_d')%,'Location','Southeast')
   axis([0,max(t),-5,20]),xlabel('Time (sec)')

  function xdot = xprimesetpt_cl(t,x)
  global A B K uex
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  u=0;         %% initialize the input force
  u=-K*x +uex; %% define the control force
  xdot = A*x+B*u;