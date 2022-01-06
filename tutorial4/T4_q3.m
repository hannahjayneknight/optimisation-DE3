% Using Newton's method

% TO RUN
% In the command line: T4_q3([ 1; -1]) 
% (changing the coordinates to whatever starting value of x we choose.

function T4_q3(x0)


x_1 = -20:0.1:20;
x_2 = -20:0.1:20;
[x11, x22] = meshgrid(x_1,x_2);
zz = f(x11, x22);
contour3(x11,x22,zz, 50)
hold on
mesh(x11, x22, zz)
xlabel('x_1')
ylabel('x_2')
colorbar


for i = 1:10
    f0 = f(x0(1),x0(2)); % function value for first iteration of x0 (calls the function to do this)
    [g,h] = fprime(x0(1),x0(2)); % (fprime is our own function)
    s = -h*g;
    x1 = x0+s;
    f1 = f(x1(1),x1(2));
    delta = (x0-x1)'*(x0-x1); % finding the change in the optimum value
    plot3([x0(1) x1(1)],[x0(2),x1(2)], [f0,f1],'r-*');
    x0=x1;
    fprintf('Iter %d: x1=%f, x2=%f, f=%f\n', i, x1(1), x1(2), f1)
    if delta<=1e-9 % if change is very small, stop running
        break
    end
end

function zz = f(x11, x22) % finding function value at a coordinate
zz = 0.5.*x11.^2+3.*x11+0.5.*x22.^2-7.*x22;

function [g, h] = fprime(x1, x2) % finding gradient and inverse H at a coordinate
dfdx1 = x1+3;
dfdx2 = x2-7;
g = [dfdx1;dfdx2];
h = inv([1 0; 0 1]);

