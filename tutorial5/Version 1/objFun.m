% objFun is a function that computes the objective function for a nonlinear,
% continuous optimisation problem.
%
% Input(s): x - design variable vector
%
% Output(s): f - objective function value at current iterate



function f = objFun(x)

f = x(1)^2 + (x(2) - 3)^2;    % Objective function