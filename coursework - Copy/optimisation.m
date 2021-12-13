clear all;

data = csvread('lhs_samples.csv');
data = normalize(data); %normalise data
Q = data(:,5);
ds = data(:,1:4); %design variables

% fit model
p_Q = polyfitn(ds,Q,'constant, x1, x2, x3, x4, x1^2, x2^2, x3^2, x4^2');

% coefficients = p_Q.Coefficients(1)...
% x1 = R
% x2 = ri
% x3 = ro
% x4 = p
objective = @(x) ...
            p_Q.Coefficients(1) + ...
            p_Q.Coefficients(2)*x(1) + p_Q.Coefficients(3)*x(2) + ...
            p_Q.Coefficients(4)*x(3) + p_Q.Coefficients(5)*x(4) + ...
            p_Q.Coefficients(6)*(x(1).^2) + p_Q.Coefficients(7)*(x(2).^2) + ...
            p_Q.Coefficients(8)*(x(3).^2) + p_Q.Coefficients(9)*(x(4).^2);

% linear inequality constraints
A = [0, 0, -1, 0;
    0, 0, 2, -1;
    0, -1, 1, 0];
b = [-1.5e-03 ;
    -1e-03 ;
    0.5e-03 ];

% linear equality constraints
Aeq = [];
beq = [];

% lower and upper bounds
lb = [2, 17.5e-03, 1.5e-03, 4e-03]; ub = [25, 23.5e-03, 7.5e-03, 50e-03];

% initial point for design variable (=current values of nespresso's
% thermoblock)
x0 = [5, 23.5e-03, 2.5e-03, 10e-03];

% optimisation options
options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'sqp');

% call the solver
[x, fval] = fmincon(objective, x0, A, b, Aeq, beq, lb, ub, @nonlcon, options);

% non-linear constraints
function [c, ceq] = nonlcon(x)
    c(1) = 100 - x(1)*x(4); %g7
    ceq = mod(x(1), 1);
end