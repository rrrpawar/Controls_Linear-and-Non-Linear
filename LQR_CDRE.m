%%  program system - LQR
global a b q r
global gain
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t0=0; tf=10;      
x0=10;p0=0;
a=0.05;b=1;q=0.1;r=1;
%%%% closed loop simulation
nsteps = 500; hsteps = (tf-t0)/nsteps;  tspan = t0:hsteps:tf;
options = odeset('JConstant','on', 'RelTol',1e-6, 'AbsTol',1e-6);
disp('Before integrating the closed loop system')
[tric,p]=ode23s('pprime',tf:-hsteps:t0,p0,options);
figure(1);
subplot(211),plot(flipud(tric),flipud(p)) 
%% calculate optimal feedback gain for each t 
k=-b*flipud(p)/r;
x(1)=x0;
for i=1:nsteps
   tl=(i-1)*hsteps; tr=i*hsteps;
   gain=0;gain=k(i);clear xcl 
   [t,xcl] = ode23s('xprime13',[tl:(tr-tl)/2:tr],x0,options);
   x(i+1)=xcl(3);
   x0=0;x0=x(i+1); 
end
u=-k*x; %% find the optimal control
disp('After integrating the closed loop system')
subplot(212),plot(flipud(tric),x)    

% FUNCTION xprime13.m
  function xdot = xprime13(t,x)
  global a b q r
  global gain
  
  u=0;  u=-gain*x; 
  xdot = a*x+b*u;
  
  % FUNCTION pprime.m
  function pdot = pprime(t,p)
  global a b q r 
  
  pdot = -2*p*a + (b*p)^2/r -q;
