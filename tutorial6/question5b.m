clear all;
clc;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i) gradient-based algorithm ( e.g. Sequential Quadratic Programming )

% linear inequality constraints
A = [ -2.3, -5.6, -11.1, -1.3 ];
b = [-5];

% linear equality constraints
Aeq = [ 1, 1, 1, 1 ];
beq = [ 1 ];

% lower and upper bounds
lb = [0, 0, 0, 0]; ub = [];

% initial point
x0 = [1,1,1,1];

objective = @(x) 24.55*x(1) + 26.75*x(2) + 39*x(3) + 40.5*x(4);

% optimisation options
%options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'sqp');

% call the solver
%[x, fval] = fmincon(objective, x0, A, b, Aeq, beq, lb, ub, @nonlcon, options);

%  SOLUTION

%   x = 0.6355    0.0000    0.3127    0.0518
    
%   fval = 29.8944

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ii)  genetic algorithm

options = optimoptions(@ga,'Display','iter');

[x,fval] = ga(objective,4,A,b,Aeq,beq,lb,ub,@nonlcon);

%  SOLUTION

%   x = 0.0648    0.1401    0.3558    0.4383
    
%   fval = 36.9671


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% functions

function [c, ceq] = nonlcon(x)
    c(1) = -12*x(1) - 11.9*x(2) - 41.8*x(3) - 52.1*x(4) + 21 + 1.645*(0.28*(x(1)^2) + 0.19*(x(2)^2) + 20.5*(x(3)^2) + 0.62*(x(4)^2))^0.5; 
    ceq = [];
end



