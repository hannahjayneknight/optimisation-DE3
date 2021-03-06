clear all; clc;

x=[-3:0.01:3];
y=[-3:0.01:3];
[x1,x2]=meshgrid(x,y);
f = -x2-2.*x1.*x2+x1.^2 +x2.^2-3.*(x1.^2).*x2-2.*(x1.^3)+2.*(x1.^4);

figure(1)
contour(x1,x2,f);

%%
% looking at more levels

figure(2)
contour(x1,x2,f, [-50:50]);

%%
% at (1, 1) f= -4

clear all; clc;

x=[0.5:0.01:1.5];
y=[0.5:0.01:1.5];
[x1,x2]=meshgrid(x,y);
f11 = -x2-2.*x1.*x2+x1.^2 +x2.^2-3.*(x1.^2).*x2-2.*(x1.^3)+2.*(x1.^4);

figure(3)
contour(x1,x2,f11,[-10:0.5:0], 'ShowText','on');

% you can see from graph that function continuously decreases at this point
% which means that the function is unbounded. Can see roughly on the graph
% where the min for f is

%%
% adding a constraint for the min of f
clear all; clc;

x=[-2:0.01:2];
y=[-2:0.01:2];
[x1,x2]=meshgrid(x,y);
f22=(x2-x1).^4+8*x1.*x2-x1+x2+3;
g=x1.^4-2*x1.^2.*x2+x1.^2+x2.^2-2*x1;

figure(4)
hold on
contour(x1,x2,f22,[0:35]);

contour(x1,x2,g,[0,0],'ShowText','on'); % this plots a line where g=0
hold off

figure(5)
hold on
contour(x1,x2,f22,[0:35]);

contour(x1,x2,g,[1,1],'ShowText','on'); % this plots a line where g2<=1
hold off

%% 
% which one is active: g or g2?

figure(6)
hold on
contour(x1,x2,f22,[0:35]);

contour(x1,x2,g,[0,1],'ShowText','on'); % on this we see g= and g2<=1
hold off

% the objective value will not change as g1 is active (dominates) and g2 in
% inactive.

