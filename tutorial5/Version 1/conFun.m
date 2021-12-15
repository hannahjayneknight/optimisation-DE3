% conFun is a function that computes the inequality & equality constraint
% functions for a constrained, nonlinear, continuous optimisation problem. 
% These functions must be in negative-null form.
%
% Input(s): x - design variable vector
%
% Output(s): g - inequality constraint function vector value at current iterate
%            h - equality constraint function vector value at current iterate


function [g,h] = conFun(x)

% Inequality constraints
g1 = x(2)^2 - 2*x(1);
g2 = (x(2)-1)^2 + 5*x(1) - 15;

g = [g1;g2];                               % Inequality constraint function

% Equality constraints
h = [];                                 % No equality constraints for this problem