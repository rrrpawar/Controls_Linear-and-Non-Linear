% Extended Dynamic Mode Decomposition and/or Naturally Structured DMD 
% main script for Henon map
clear all; close all;clc
%% load dataset
tic
% Henon map(discrete time)
z0 =[1;0.1]; % Intial condition

N = size(z0,2); % number of initial conditions
data = z0;
a = 1.4;
b = 0.3;
f = @(z) [z(1)-z(1)^3+z(2);...
            3*z(1)-z(2)]; 
T = 5000; % simulation time
for t = 1:T-1
    data = [data f(data(:,end))];
end

%% choice of dictionary
% Psi = @Usd_func;
% % Hermite Polynomials ---Problems defined on R^N
% Psi = @HermitePoly;

% Radial Basis Functions ---Problems defined on irregular domains
Psi = @RBF;
sigma = 0.02; % Specify here for all Gaussian dictionary functions
Nk = 500; % Specify here as number of dictionary functions
[~, centers] = kmeans(data',Nk); % k-means clustering
centers = centers'; % centers size of 2 x Nk

% Discontinuous Spectral Elements ---Large problems where a block-diagonal G is benecial/computationally important
% Psi = @DSE;

figure(1)
plot(data(1,:),data(2,:),'*')
hold on
plot(centers(1,:),centers(2,:),'+')

%% Compute the G and A matrix
X = data(:,1:end-1);
Y = data(:,2:end);
G = 0;
A = 0;
M = size(X,2); % length of time-series
for i = 1:M
    PsiX = Psi(X(:,i),centers,sigma);
    PsiY = Psi(Y(:,i),centers,sigma);
    G = G + PsiX'*PsiX;
    A = A + PsiX'*PsiY;
end
G = G/M;
A = A/M;

% EDMD
Kdmd = pinv(G)*A;

%% Plotting eigenfunctions 
n = 4; % compute eigenfunctions corresponding to first n dominant eigenvalues
% Construct X-Y boxes
Nx = 100;
Ny = 100;
x_limit = [-1.5 1.5];% range of x
y_limit = [-.4 .4];% range of y
xmax=x_limit(2);xmin=x_limit(1);
ymax=y_limit(2);ymin=y_limit(1);
dx=(xmax-xmin)/(Nx);
dy=(ymax-ymin)/(Ny);
xvec = xmin+dx/2:dx:xmax-dx/2;
yvec = ymin+dy/2:dy:ymax-dy/2;
[xx,yy] = meshgrid(xvec,yvec);
x = reshape(xx,1,[]);
y = reshape(yy,1,[]);
XY =  [x;y];

[V, D, W] = eig(Kdmd); % D are eigenvalues of Koopman Operator or ln(D)/dT
D=ln(D)/dt;
% W generates Koopman modes
% V generates Koopman eigenfunctions

% Plot eigenvalues in complex plane
figure 
th=0:0.1:2*pi;
plot(cos(th),sin(th),'k-')
hold on;
plot(diag(D),'*')
grid on

% Sort the eigenvalues in descending order
[D_sorted, idx] = sort(abs(diag(D)),'descend');
eigfunc1_Kpm = zeros(size(XY,2),n);
% Compute the eigenfunction by \Psi(x)*v_j, v_j is the jthe eigenvector
for j = 1:n
    eigValue = D(idx(j),idx(j));
    for i = 1:size(XY,2)
        eigfunc1_Kpm(i,j) = Psi(XY(:,i),centers,sigma)*V(:,idx(j));% eigenfunction values for jth dominant eigenvalues
    end
    figure
    pcolor(xx,yy,reshape(real(eigfunc1_Kpm(:,j))/max(real(eigfunc1_Kpm(:,j))),Nx,Ny))
    colorbar
    colormap jet
    title(['\mu=Real(' num2str(eigValue) ') Koopman EDMD'])
end

eigfunc1_PF = zeros(size(XY,2),n);
for j = 1:n
    eigValue = D(idx(j),idx(j));
    for i = 1:size(XY,2)
        eigfunc1_PF(i,j) = Psi(XY(:,i),centers,sigma)*W(:,idx(j));% eigenfunction values for jth dominant eigenvalues
    end
    figure
    pcolor(xx,yy,reshape(real(eigfunc1_PF(:,j))/max(real(eigfunc1_PF(:,j))),Nx,Ny))
    colorbar
    colormap jet
    title(['\mu=Real(' num2str(eigValue) ') P-F EDMD'])
end
toc