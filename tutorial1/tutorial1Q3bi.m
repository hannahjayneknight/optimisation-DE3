clear all;

x=[-2:0.01:2];
y=[-2:0.01:2];
[x1,x2]=meshgrid(x,y);
f = (x2 - x1).^4 + 8.*x2.*x1 - x1 + x2 + 3; % remember to use .* for matrix mutiplication
figure(1)
contour(x1,x2,f,[-50:50]);

% all correct