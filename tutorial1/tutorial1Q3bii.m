clear all;

x=[-2:0.01:2];
y=[-2:0.01:2];
[x1,x2]=meshgrid(x,y);
f = (x2 - x1).^4 + 8.*x2.*x1 - x1 + x2 + 3;
g = x1.^4 - 2.*x2.*(x1.^2) + (x1.^2) + (x2.^2) - 2.*x1;
figure(1)
contour(x1,x2,f,[-50:50]);
hold on
contour(x1,x2,g,[0,0],'ShowText','on');
hold off

% note that adding a constraint means adding another line to the graph
% (which in this case is g=0)