global A B C G
global Abig
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t0=0;tf=2;
A=[0 1 0;0 0 1;-24 -26 -9];B=[0;0;1];
C=[2 -1 1]; x0=[3;-3;-3;0;0;0];
G=place(A',C',[-5 -5+0.001*j -5-0.001*j])';
Ao=A-G*C;
Abig=[A zeros(3,3);zeros(3,3) Ao];
%%%%% closed loop simulation
nsteps = 200; hsteps = (tf-t0)/nsteps;  tspan = t0:hsteps:tf;
options = odeset('JConstant','on', 'RelTol',1e-6, 'AbsTol',1e-6);
disp('Before integrating the closed loop system')
[t,x]=ode23s('xhatprime',t0:hsteps:tf,x0,options);
disp('After integrating the closed loop system')

subplot(311),plot(t,x(:,1),t,x(:,4),'--')
title('x_{1} and its estimate')
legend('x_{1}(t)','xhat_{1}(t)')
subplot(312),plot(t,x(:,2),t,x(:,5),'--')
title('x_{2} and its estimate')
legend('x_{2}(t)','xhat_{2}(t)')
subplot(313),plot(t,x(:,3),t,x(:,6),'--')
title('x_{3} and its estimate')
legend('x_{3}(t)','xhat_{3}(t)')
xlabel('Time (sec)')
