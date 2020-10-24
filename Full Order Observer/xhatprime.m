% FUNCTION xprime15.m
function xdot = xhatprime(t,x)
global A B C G 
global Abig

u=0;u=sin(2*t);
y=0;y=C*x(1:3);
xdot = Abig*x + [B;B]*u+[zeros(3,1);G]*y;

