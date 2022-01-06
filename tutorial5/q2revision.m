clear all; clc;

% linear inequality constraints
A = [];
b = [];

% linear equality constraints
Aeq = [];
beq = [];

% lower and upper bounds
lb = []; ub = [];


objective = @(x) x(1)^2 + (x(2) - 3)^2;

% initial point for design variable (=current values of nespresso's
% thermoblock)
x0 = [1 1];

% optimisation options
options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'sqp');

% call the solver
[x, fval] = fmincon(objective, x0, A, b, Aeq, beq, lb, ub, @nonlcon, options);

% non-linear constraints
function [c, ceq] = nonlcon(x)
    c(1) = x(2)^2 - 2*x(1); 
    c(2) = (x(2) - 1)^2 + 5*x(1) - 15;
   
    ceq = [];
end
