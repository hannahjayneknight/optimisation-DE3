%% DE3 Optimisation: Tutorial 5 Question 2 

% Modified by NL
% v1.0
% 18/11/2020

clear; clc;

%% Algorithm Settings

% Sequential quadratic programming (SQP) algorithm settings

x0 = [0.01,0.01]';                    % Initial design variable vector (starting point) 
sqpOptions.lineSearch = 'on';           % Line search settings ('on' or 'off')
sqpOptions.epsilon = 1e-6;              % Termination criterion

% Initial feasibility check

[g0,h0] = feval('conFun',x0);

if isempty(g0)
else
    if max(g0)> 0
        errordlg('Initial iterate is infeasible. Select a feasible starting point.');
        return
    end
end

% SQP algorithm

[xOpt,fOpt,lambdaOpt,convHist] = sqp(x0,'objFun','gradObj','conFun','jacobCon',sqpOptions);