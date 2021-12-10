clear all;

data = csvread('lhs_samples.csv');
data = normalize(data); %normalise data
Q = data(:,5);
ds = data(:,1:4); %design variables

% fit model
p_Q = polyfitn(ds,Q,'constant, x1, x2, x3, x4, x1^2, x2^2, x3^2, x4^2');

% coefficients
% p_Q.Coefficients(1)...
% x1, x2, x3, x4, x1^2, x2^2, x3^2, x4^2
objective = p_Q.Coefficients(1) + ...
            p_Q.Coefficients(2)*ds(:,1) + p_Q.Coefficients(3)*ds(:,2) + ...
            p_Q.Coefficients(4)*ds(:,3) + p_Q.Coefficients(5)*ds(:,4) + ...
            p_Q.Coefficients(6)*(ds(:,1).^2) + p_Q.Coefficients(7)*(ds(:,2).^2) + ...
            p_Q.Coefficients(8)*(ds(:,3).^2) + p_Q.Coefficients(9)*(ds(:,4).^2);

% non-linear constraints

% linear constraints

% lower and upper bounds
lb = []; ub = [];

% initial point for design variable --> ??
x0 = 0;

% optimisation options
options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'sqp');

% call the solver
[x, fval] = fmincon(objective, x0, A, b, Aeq, beq, lb, ub, @nonlcon, options);

function [c, ceq] = nonlcon(x)
    c(1) = x(1);
    ceq = [];
end