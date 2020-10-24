%% LQR_CARE

global A B 
global gain omega
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t0=0; tf=6;      
x0=[10;-3;-10];
omega=5;
F=[0 1;-omega^2 0]; 
A=[F [2;1];0 0 -3];
B=[1;0;-1];C=[1 0 0];
gain=lqr(A,B,eye(3),1);
%%%% closed loop simulation
nsteps = 300; hsteps = (tf-t0)/nsteps;  tspan = t0:hsteps:tf;
options = odeset('JConstant','on', 'RelTol',1e-6, 'AbsTol',1e-6);
disp('Before integrating the closed loop system')
[t,x]=ode23s('lqrxprime',t0:hsteps:tf,x0,options);
plot(t,x,'--')
legend('x(t)')
xlabel('Time (sec)')

function xdot = lqrxprime(t,x)
global A B  
global gain omega
u=-gain*x;
xdot = A*x + B*u;