clear all;

x=[-2:0.01:2];
y=[-2:0.01:2];
[x1,x2]=meshgrid(x,y);
f = (x2 - x1).^4 + 8.*x2.*x1 - x1 + x2 + 3;
g = x1.^4 - 2.*x2.*(x1.^2) + (x1.^2) + (x2.^2) - 2.*x1;
figure(1)
contour(x1,x2,f,[-50:50]);
hold on
contour(x1,x2,g,[0,1],'ShowText','on'); % doesn't matter whether you put g[0,1] or g[-50,1] here
hold off

% note that adding a constraint means adding another line to the graph
% (which in this case is g <= 1)

% g[0,0] = g1
% g[0,1] = g2

% difference between g1 and g2: the minimum will not be changed
% since both g1 and g2 constrain the same minimum

% g1 IS ACTIVE AND 
% g2 IS INACTIVE 