clear all;

% Q1 Program to compute the first and second derivatives for 𝐱 = [0, 1, 2, 3, 4, 5,6,7]

x = [0, 1, 2, 3, 4, 5, 6, 7];
f = (1/100).*x.*(x-1).*(x-4).*(x-5).*(x-7);

diff1 = diff(f);
diff2 = diff(f, 2);

% Q1 ANSWER - using approximations

dx = 0.001; % delta x
fx = fun(x); % function values at x
fxdx = fun(x+dx); % function values at x+dx
fx2dx = fun(x+dx+dx); % function value at x+dx+dx
dfx = (fxdx-fx)/dx; % first derivative at x values 
dfxdx = (fx2dx-fxdx)/dx; % first derivative at x+dx
ddfx = (dfxdx-dfx)/dx; % second derivative at x


% Q2 ANSWER
x0 = [0.25,0.25,0.25,0.25];
A =[]; B=[]; Aeq=[]; Beq=[]; lb=zeros(1,4); ub=[];
[x,fval]=fmincon('obj',x0,A,B,Aeq,Beq,lb,ub,'nonlcon');


