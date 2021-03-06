clear all;
clc;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i) gradient-based algorithm ( e.g. Sequential Quadratic Programming )

% linear inequality constraints
A = [];
b = [];

% linear equality constraints
Aeq = [ 1, 3, 0, 0, 0;
        0, 0, 1, 1, -2;
        0, 1, 0, 0, -1  ];
beq = [ 0;
        0;
        0   ];

% non-linear constraints
nonlcon = [];

% lower and upper bounds
lb = [-10, -10, -10, -10, -10]; ub = [10, 10, 10, 10, 10];

% initial point
x0 = [2,2,2,2,2];

objective = @(x) ( x(1) - x(2) )^2 + ( x(2) + x(3) )^2 + ( x(4) - 1 )^2 + (x(5) - 1)^2;

% optimisation options
%options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'sqp');

% call the solver
%[x, fval] = fmincon(objective, x0, A, b, Aeq, beq, lb, ub, nonlcon, options);

%  SOLUTION

%   x = -0.3488    0.1163   -0.4419    0.6744    0.1163
    
%   fval = 1.2093

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ii)  genetic algorithm

options = optimoptions(@ga,'Display','iter');

[x,fval] = ga(objective,5,A,b,Aeq,beq,lb,ub,nonlcon);

%  SOLUTION

%   x = -0.3461    0.1157   -0.4214    0.6558    0.1167
    
%   fval = 1.2054



