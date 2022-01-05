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
% evaluating at (1, 1)

f()

