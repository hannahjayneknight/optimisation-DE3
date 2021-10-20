clear all;

% Q3a 
%x1 = linspace(-100, 100);
%x2 = linspace(-100, 100);
%meshgrid(x1, x2) % this is needed
%f = -x2 - 2.*x1.*x2 + x1.^2 + x2.^2 - 3.*(x1.^2).*x2 - 2.*(x1.^3) + 2.*(x1.^4);
%contour(x1, x2, f)

% Q3a ANSWER (plots 2 grids)
x=[-3:0.01:3];
y=[-3:0.01:3];
[x1,x2]=meshgrid(x,y); % this is needed
f=-x2-2*x1.*x2+x1.^2+x2.^2-3*x1.^2.*x2-2*x1.^3+2*x1.^4;
figure(1) % remember to define the figure
contour(x1,x2,f,[-50:50]);

% examining behaviour around [1, 1]T to find minimum
x=[0.5:0.01:1.5];
y=[0.5:0.01:1.5];
[x1,x2]=meshgrid(x,y);
f11=-x2-2*x1.*x2+x1.^2+x2.^2-3*x1.^2.*x2-2*x1.^3+2*x1.^4;
figure(2)
contour(x1,x2,f11,[-10:0.5:0],'ShowText','on');

% there is no minimum for this function as it is unbounded
