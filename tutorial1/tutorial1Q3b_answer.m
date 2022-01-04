clear
clc
x=[-2:0.01:2];
y=[-2:0.01:2];

[x1,x2]=meshgrid(x,y);
f=(x2-x1).^4+8*x1.*x2-x1+x2+3;
g=x1.^4-2*x1.^2.*x2+x1.^2+x2.^2-2*x1;

figure(1)
contour(x1,x2,f,[0:35]);

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