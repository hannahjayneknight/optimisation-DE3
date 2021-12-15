% sqp is a function that solves constrained, nonlinear, continuous 
% optimisation problems using sequential quadratic programming (SQP).
%
% Input(s): x0 - initial design variable vector
%           objFun - objective function
%           gradObj - gradient of objective function
%           conFun - constraint functions
%           jacobCon - Jacobians of constraint functions
%           counter - current iterate number
%           sqpOptions - structure containing SQP optimisation settings
%                       .lineSearch - line search settings ('on' or 'off')
%                       .epsilon - termination criterion
%
% Output(s): xOpt - optimal design variable vector
%            fOpt - optimal objective function value
%            lambdaOpt - optimal Lagrange multiplier values
%            convHist - structure containing convergence history
%
% Modified by NL
% v1.0
% 17/11/2020

function [xOpt,fOpt,lambdaOpt,convHist] = sqp(x0,objFun,gradObj,conFun,jacobCon,sqpOptions)

% SQP initialisation
counter = 0;
x(:,counter+1) = x0;                                    % Initialise design variable vector
f(counter+1) = feval(objFun,x(:,counter+1));            % Objective function value at initial iterate
grad_fk = feval(gradObj,x(:,counter+1));                % Gradient of objective at initial iterate
[gk,hk] = feval(conFun,x(:,counter+1));                 % Constraint function values at initial iterate
[jacob_gk,jacob_hk] = feval(jacobCon,x(:,counter+1));   % Jacobians of constraint functions at initial iterate
lambda_k = ones(length(gk)+length(hk),1);              % Lagrange multiplier estimates at initial iterate
wts_k0 = lambda_k;                                      % Merit function weights at initial iterate

% Gradient of Lagrangian at initial iterate
if isempty(gk) && isempty(hk)

    grad_Lk = grad_fk;
   
elseif isempty(gk)
    
    grad_Lk = grad_fk + lambda_k'*jacob_hk;

elseif isempty(hk)
    
    grad_Lk = grad_fk + lambda_k'*jacob_gk;
    
else
    
     grad_Lk = grad_fk + lambda_k(length(gk)+1:end)'*jacob_hk + lambda_k(1:length(gk))'*jacob_gk;
    
end

% Norm of gradient of Lagrangian at initial iterate
KKT_norm(counter+1) = norm(grad_Lk,2);

% Hessian of Lagrangian at initial iterate
Wk = eye(length(x0));    

while KKT_norm(counter+1) >= sqpOptions.epsilon
    
    %% QP SUBPROBLEM SOLUTION
    
    % Advanced algorithm settings
    qpOptions = optimoptions(@ quadprog,'Algorithm','interior-point-convex','Display','off');
    
    % MATLAB QP Solver (QUADPROG)
    [sk,~,~,~,lambda] = quadprog(Wk,grad_fk,jacob_gk,-gk,jacob_hk,-hk,[],[],[],qpOptions);
    lambda_k1 = [lambda.ineqlin; lambda.eqlin];
    
     %% LINE SEARCH/MERIT FUNCTION MINIMIZATION
    
    if strcmp(sqpOptions.lineSearch,'on')
        
        % Line search parameters
        stepSize(counter+1) = 1;                        % Initialize step-size parameter
        betaLimit = 0.1;                                % Step-size limiting parameter
        tau = 0.5;                                      % Step-size reduction (backtracking) parameter
        
        % Perform line search/merit function minimization
        [stepSize(counter+1),wts_k,lineSearchCounter(counter+1)] = lineSearchCon(x(:,counter+1),objFun,gradObj,...
            conFun,jacobCon,sk,lambda_k,wts_k0,counter,stepSize(counter+1),betaLimit,tau);
        
    else
        
        stepSize(counter+1) = 0.1;                      % Constant step-size 
        
    end
    
     %% ITERATE UPDATE
    
    % Compute design variable at next iterate
    x(:,counter+2) = x(:,counter+1) + stepSize(counter+1)*sk;
    
    counter = counter + 1;                          % Increment counter
    
    %% OBJECTIVE, OBJECTIVE GRADIENT, CONSTRAINTS, & CONSTRAINT JACOBIAN UPDATES
    
    f(counter+1) = feval(objFun,x(:,counter+1));            % Objective function value at current iterate
    grad_fk1 = feval(gradObj,x(:,counter+1));                % Gradient of objective at current iterate
    [gk1,hk1] = feval(conFun,x(:,counter+1));                 % Constraint function values at current iterate
    [jacob_gk1,jacob_hk1] = feval(jacobCon,x(:,counter+1));   % Jacobians of constraint functions at current iterate
    
    %% LAGRANGIAN GRADIENT UPDATES
    
    if isempty(gk1) && isempty(hk1)
        
        % Gradient of Lagrangian at previous iterate
        grad_Lk01 = grad_fk;
        
        % Gradient of Lagrangian at current iterate
        grad_Lk1 = grad_fk1;

    elseif isempty(gk1)
        
        % Gradient of Lagrangian at previous iterate in x and current iterate in lambda
        grad_Lk01 = grad_fk + lambda_k1'*jacob_hk;
        
        % Gradient of Lagrangian at current iterate
        grad_Lk1 = grad_fk1 + lambda_k1'*jacob_hk1;
    
    elseif isempty(hk1)

        % Gradient of Lagrangian at previous iterate in x and current iterate in lambda
        grad_Lk01 = grad_fk + lambda_k1'*jacob_gk;
        
        % Gradient of Lagrangian at current iterate
        grad_Lk1 = grad_fk1 + lambda_k1'*jacob_gk1;

    else
        
        % Gradient of Lagrangian at previous iterate in x and current iterate in lambda
        grad_Lk01 = grad_fk + lambda_k1(length(gk1)+1:end)'*jacob_hk + lambda_k1(1:length(gk1))'*jacob_gk;

        % Gradient of Lagrangian at current iterate
        grad_Lk1 = grad_fk1 + lambda_k1(length(gk1)+1:end)'*jacob_hk1 + lambda_k1(1:length(gk1))'*jacob_gk1;
    
    end
    
    % Norm of gradient of Lagrangian at current iterate
    KKT_norm(counter+1) = norm(grad_Lk1,2);
    
     %% LAGRANGIAN HESSIAN UPDATES
    
    del_xk = stepSize(counter)*sk;  % Perturbation of iterate
    yk = grad_Lk1' - grad_Lk01';    % Perturbation of gradient of Lagrangian
    
    if del_xk'*yk >= 0.2*del_xk'*Wk*del_xk
        
        theta = 1;
    
    elseif del_xk'*yk < 0.2*del_xk'*Wk*del_xk
        
        theta = (0.8*del_xk'*Wk*del_xk)/(del_xk'*Wk*del_xk - del_xk'*yk);
        
    end
    
    % Weighted perturbation of gradient of Lagrangian
    del_grad_Lk = theta*yk + (1-theta)*Wk*del_xk;
    
    % BFGS update of Hessian of Lagrangian
    Wk1 = Wk + (del_grad_Lk*del_grad_Lk')/(del_grad_Lk'*del_xk) - (Wk*del_xk)*(Wk*del_xk)'/(del_xk'*Wk*del_xk);
    
    %% OVERWRITE PREVIOUS ITERATES
    grad_fk = grad_fk1;                             % Gradient of objective at current iterate
    gk = gk1;   hk = hk1;                           % Constraint function values at current iterate
    jacob_gk = jacob_gk1;   jacob_hk = jacob_hk1;   % Jacobians of constraint functions at current iterate
    lambda_k = lambda_k1;                           % Lagrange multipliers at current iterate          
    wts_k0 = wts_k;                                 % Merit function weights at previous iterate
    grad_Lk = grad_Lk1;                             % Gradient of Lagrangian at current iterate
    Wk = Wk1;                                       % Hessian of Lagrangian at current iterate
    
end

xOpt = x(:,counter+1);  % Optimal design variable vector
fOpt = f(counter+1);    % Optimal objective function value
lambdaOpt = lambda_k;   % Optimal Lagrange multipliers

% Convergence history information
convHist.iteration = [0:counter]';
convHist.x = x';
convHist.f = f';
convHist.KKT_norm = KKT_norm';
convHist.stepSize = stepSize';
convHist.lineSearchIteration = lineSearchCounter';
    