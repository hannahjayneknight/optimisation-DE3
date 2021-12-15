function [xOpt,fOpt, lamda] = Main()
%MAIN Summary of this function goes here
%   Detailed explanation goes here
c = @(x)[x(2)^2 - 2*x(1);
    (x(2)-1)^2 + 5*x(1) - 15]
ceq = @(x)[];
nonlinfcn = @(x)deal(c(x),ceq(x));

obj = @(x)x(1)^2 + (x(2) - 3)^2;
x0 = [0.1;0.1];
%opts = optimoptions(@fmincon, 'Algorithm', 'sqp'); <-- runs without this, Set options for fmincon to use the sqp algorithm 
%[xOpt, fOpt, exitflag, output, lamda] = fmincon(obj, x0, [], [], [], [], [], [], nonlinfcn, opts);
[xOpt, fOpt, exitflag, output, lamda] = fmincon(obj, x0, [], [], [], [], [], [], nonlinfcn);
end