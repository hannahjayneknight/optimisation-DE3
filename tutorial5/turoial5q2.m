% Implement SQP in MATLAB

clear all;
x1 = linspace(-100, 100);
x2 = linspace(-100, 100);
fun = @(x)x(1)^2 + (x(2) - 3)^2;
x0 = [0.1;0.1];
c = @(x)[x(2)^2 - 2*x(1);
    (x(2)-1)^2 + 5*x(1) - 15]
ceq = @(x)[];
nonlinfcn = @(x)deal(c(x),ceq(x));

x = fmincon(fun, x0, [],[],[],[], [], [], nonlinfcn);


    
