clear all; clc;

%%
% array indexing 101

A = [   1, 2, 3, 4;
        5, 6, 7, 8;
        9, 10, 11, 12;
        13, 14, 15, 16;     ];

% indexing entire 3rd column
r1 = A(:,3);

% indexing first 2 rows
r2 = A([1 2],:);

% indexing first 2 columns
r3 = A(:,[1 2]);

% indexing MANY rows
r4 = A((1: 4),:);

% indexing MANY columns
r5 = A(:,(1: 4));

% indexing element in 3rd row 2nd column
e = A(3,2);

% indexing 1st and 3rd elements of the second row
r = A(2,[1 3]);

% converting to a vector
Alinear = A(:);

%%
% plotting a contour of a function with more than one input

x=[-2:0.01:2];
y=[-2:0.01:2];

[x1,x2]=meshgrid(x,y);
f=(x2-x1).^4+8*x1.*x2-x1+x2+3;
g=x1.^4-2*x1.^2.*x2+x1.^2+x2.^2-2*x1;

contour(x1,x2,f,[0:35]);

%%
% annotating

figure(2)
hold on
contour(x1,x2,f,[0:35]);

contour(x1,x2,g,[0,0],'ShowText','on');
hold off

figure(3)
hold on
contour(x1,x2,f,[0:35]);

contour(x1,x2,g,[0,1],'ShowText','on');
hold off

%%
% Second-order Taylors series approximation at stationary point

syms dx1 dx2;

H = [   4, 5;
        5, 0; ] % change this depending on q

grad = [dx1, dx2];

df = simplify(0.5*grad*H*transpose(grad));

%%
% fmincon SQP

% linear inequality constraints
A = [0, -1, 1, 0 ;
    0, 0, -1, 0;
    0, 0, 2, -1;
    0, 1, 1, 0;
    0, -1, 1, 0];
b = [0 ;
    -1.5e-03 ;
    -1e-03 ;
    25e-03 ;
    -17.5e-03 ];

% linear equality constraints
Aeq = [];
beq = [];

% lower and upper bounds
lb = [2, 17.5e-03, 1.5e-03, 4e-03]; ub = [25, 23.5e-03, 7.5e-03, 50e-03];


objective = @(x) 2*pi*237*x(1)*sqrt( (x(4)^2) + ( 2*pi * x(2)) ^2)*107/ log(x(3)/(x(3)-1e-03)); %derived equation for Q

% initial point for design variable (=current values of nespresso's
% thermoblock)
x0 = [5, 23.5e-03, 2.5e-03, 10e-03];

% optimisation options
options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'sqp');

% call the solver
[x, fval] = fmincon(objective, x0, A, b, Aeq, beq, lb, ub, @nonlcon, options);

% non-linear constraints
function [c, ceq] = nonlcon(x)
    c(1) = 33 - x(1)*x(4); 
    c(2) = -100 + x(1)*x(4);
    c(3) = 513 - (2*pi*237*x(1)*sqrt( (x(4)^2) + ( 2*pi * x(2)) ^2)*107/ log(x(3)/(x(3)-1e-03))); %derived equation for Q
    
    ceq = mod(x(1), 1); %only include for sqp
    %ceq = [];
end
