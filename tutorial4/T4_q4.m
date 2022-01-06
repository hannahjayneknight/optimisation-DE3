% from plotting the function, we can see the saddle shape of the function
% very clearly

clc
clear
close all

x1 = -10:0.1:10; % generating sample data
x2 = -10:0.1:10;
[x11, x22] = meshgrid(x1, x2);

zz = x11.^2-3.*x11-x22+x11.*x22;
contour3(x11, x22, zz, 100); % plotting the function
xlabel('x_1')
ylabel('x_2')
zlabel('f(x)')
hold on
plot3(1, 1, 1^2-3*1-1+1*1, 'rs');
colorbar;
plot(ones(length(x1)), x2,'k')
plot(x1,2-x1,'k')
plot(x1,x1,'r')
xlim([-10,10])
ylim([-10,10])
