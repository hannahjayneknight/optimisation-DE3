% jacobCon is a function that computes the Jacobians of the inequality &
% equality constraint functions for a constrained, nonlinear, continuous 
% optimisation problem. These are based on constraint functions that are 
% posed in negative-null form.
%
% Input(s): x - design variable vector
%
% Output(s): jacob_g - Jacobian of the inequality constraints at current iterate
%            jacob_h - Jacobian of the equality constraints at current iterate


function [jacob_g,jacob_h] = jacobCon(x)

% Inequality constraints
dg1_dx1 = -2;   dg1_dx2 = 2*x(2);
dg2_dx1 = 5;   dg2_dx2 = 2*x(2)-2;

jacob_g = [dg1_dx1,dg1_dx2;dg2_dx1,dg2_dx2];            % Gradient of the inequality constraints

% Equality constraints
jacob_h = [];                           % No equality constraints for this problem