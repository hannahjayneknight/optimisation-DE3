% lineSearchCon is a function that performs the back-tracking algorithm 
% (also named Armijo Line Search)for a constrained,nonlinear, continuous 
% optimisation problem.  
% This is accomplished by minimising a merit function 
% PHI(X,LAMBDA,MU,ALPHA) with respect to ALPHA.
%
% Input(s): xk - design variable vector at current iterate
%           objFun - objective function
%           gradObj - gradient of objective function
%           conFun - constraint functions
%           jacobCon - Jacobians of constraint functions
%           sk - search direction vector at current iterate
%           lambda_k - Lagrange multipliers at current iterate
%           wts_k0 - merit function weights at previous iterate
%           counter - current iterate number
%           alpha_k_ini - initial step size at current iterate
%           betaLimit - step-size limiting parameter
%           tau - step-size reduction (backtracking) parameter
%
% Output(s): alpha_k_final - final step size at current iterate
%            wts_k - merit function weights at current iterate
%            counter - number of line search iterations
%
% Modified by NL 
% v1.0
% 17/11/2020

function [alpha_k_final,wts_k,counterLS] = lineSearchCon(xk,objFun,gradObj,conFun,jacobCon,sk,lambda_k,wts_k0,counter,alpha_k_ini,betaLimit,tau)

% Initialize line search counter
counterLS = 0;

%% MERIT FUNCTION WEIGHTS

if counter == 0
    
    wts_k = abs(lambda_k);

else

    wts_k = max([abs(lambda_k) mean([wts_k0 abs(lambda_k)],2)],[],2);
    
end

%% INITIAL MERIT FUNCTION EVALUATIONS

alpha_k = alpha_k_ini;                      % Initialize step-size parameter

fk = feval(objFun,xk);                      % Objective function value at current iterate
grad_fk = feval(gradObj,xk);                % Gradient of objective at current iterate
[gk,hk] = feval(conFun,xk);                 % Constraint function values at current iterate
[jacob_gk,jacob_hk] = feval(jacobCon,xk);   % Jacobians of constraint functions at current iterate

fk1 = feval(objFun,xk + alpha_k*sk);                        % Estimated objective function value at next iterate 
grad_fk1 = feval(gradObj,xk + alpha_k*sk);                  % Estimated gradient of objective at next iterate
[gk1,hk1] = feval(conFun,xk + alpha_k*sk);                  % Estimated constraint function values at next iterate
[jacob_gk1,jacob_hk1] = feval(jacobCon,xk + alpha_k*sk);    % Estimated Jacobians of constraint functions at next iterate

% Initialize constraint magnitude storage vectors at current iterate
gk_mag = zeros(length(gk),1);
hk_mag = zeros(length(hk),1);              

% Initialize constraint magnitude storage vectors at next iterate
gk1_mag = zeros(length(gk1),1);
hk1_mag = zeros(length(hk1),1);

% Inequality constraint magnitudes and merit function-based Jacobian at current and next iterate
for i=1:length(gk_mag)
    
    gk_mag(i) = abs(min([0,-gk(i)]));
     
    if gk_mag(i) == 0
        
        jacob_gk(i,:) = zeros(1,size(jacob_gk,2));
        
    end
    
    gk1_mag(i) = abs(min([0,-gk1(i)]));
    
    if gk1_mag(i) == 0
        
        jacob_gk1(i,:) = zeros(1,size(jacob_gk1,2));
        
    end
    
end

% Equality constraint magnitudes and merit function-based Jacobian at current and next iterate
for i=1:length(hk_mag)
    
    hk_mag(i) = abs(hk(i));
     
    if hk_mag(i) < 0
        
        jacob_hk(i,:) = -jacob_hk(i,:);
        
    end
    
    hk1_mag(i) = abs(hk1(i));
    
    if hk1_mag(i) < 0
        
        jacob_hk1(i,:) = -jacob_hk1(i,:);
        
    end
    
end

% Merit function values at current and next iterate
if iscolumn(wts_k(1:length(gk))) && iscolumn(wts_k(length(gk)+1:end))
    phi_k = fk + wts_k(1:length(gk))'*gk_mag + wts_k(length(gk)+1:end)'*hk_mag;
    phi_k1 = fk1 + wts_k(1:length(gk1))'*gk1_mag + wts_k(length(gk1)+1:end)'*hk1_mag;
elseif ~iscolumn(wts_k(1:length(gk))) && iscolumn(wts_k(length(gk)+1:end))
    phi_k = fk + wts_k(1:length(gk))*gk_mag + wts_k(length(gk)+1:end)'*hk_mag;
    phi_k1 = fk1 + wts_k(1:length(gk1))*gk1_mag + wts_k(length(gk1)+1:end)'*hk1_mag;
elseif iscolumn(wts_k(1:length(gk))) && ~iscolumn(wts_k(length(gk)+1:end))
    phi_k = fk + wts_k(1:length(gk))'*gk_mag + wts_k(length(gk)+1:end)*hk_mag;
    phi_k1 = fk1 + wts_k(1:length(gk1))'*gk1_mag + wts_k(length(gk1)+1:end)*hk1_mag;
elseif ~iscolumn(wts_k(1:length(gk))) && ~iscolumn(wts_k(length(gk)+1:end))
    phi_k = fk + wts_k(1:length(gk))*gk_mag + wts_k(length(gk)+1:end)*hk_mag;
    phi_k1 = fk1 + wts_k(1:length(gk1))*gk1_mag + wts_k(length(gk1)+1:end)*hk1_mag;
end

% Gradient of merit function wrt x at current and next iterate
if isempty(gk) && isempty(hk)
    
    grad_phi_k = grad_fk;
    grad_phi_k1 = grad_fk1;
    
elseif isempty(gk)
    
    grad_phi_k = grad_fk + wts_k(length(gk)+1:end)'*jacob_hk;
    grad_phi_k1 = grad_fk1 + wts_k(length(gk1)+1:end)'*jacob_hk1;
    
elseif isempty(hk)
    grad_phi_k = grad_fk + wts_k(1:length(gk))'*jacob_gk;
    grad_phi_k1 = grad_fk1 + wts_k(1:length(gk1))'*jacob_gk1;

else
    grad_phi_k = grad_fk + wts_k(1:length(gk))'*jacob_gk + wts_k(length(gk)+1:end)'*jacob_hk;
    grad_phi_k1 = grad_fk1 + wts_k(1:length(gk1))'*jacob_gk1 + wts_k(length(gk1)+1:end)'*jacob_hk1;

end

%% ARMIJO LINE SEARCH

while ((phi_k1 > phi_k + alpha_k*betaLimit*grad_phi_k*sk) || (grad_phi_k1*sk < betaLimit*grad_phi_k*sk)) && (counterLS < 100)
    
    alpha_k = tau*alpha_k;                                      % Backtrack step size
    fk1 = feval(objFun,xk + alpha_k*sk);                        % Estimated objective function value at next iterate 
    grad_fk1 = feval(gradObj,xk + alpha_k*sk);                  % Estimated gradient of objective at next iterate
    [gk1,hk1] = feval(conFun,xk + alpha_k*sk);                  % Estimated constraint function values at next iterate
    [jacob_gk1,jacob_hk1] = feval(jacobCon,xk + alpha_k*sk);    % Estimated Jacobians of constraint functions at next iterate
    
    % Initialize constraint magnitude storage vectors at next iterate
    gk1_mag = zeros(length(gk1),1);
    hk1_mag = zeros(length(hk1),1);

    % Inequality constraint magnitudes and merit function-based Jacobian at next iterate
    for i=1:length(gk1_mag)

        gk1_mag(i) = abs(min([0,-gk1(i)]));

        if gk1_mag(i) == 0

            jacob_gk1(i,:) = zeros(1,size(jacob_gk1,2));

        end

    end

    % Equality constraint magnitudes and merit function-based Jacobian at next iterate
    for i=1:length(hk1_mag)

        hk1_mag(i) = abs(hk1(i));

        if hk1_mag(i) < 0

            jacob_hk1(i,:) = -jacob_hk1(i,:);

        end

    end

    % Merit function value at next iterate
    if iscolumn(wts_k(1:length(gk))) && iscolumn(wts_k(length(gk)+1:end))
        phi_k1 = fk1 + wts_k(1:length(gk1))'*gk1_mag + wts_k(length(gk1)+1:end)'*hk1_mag;
    elseif ~iscolumn(wts_k(1:length(gk))) && iscolumn(wts_k(length(gk)+1:end))
        phi_k1 = fk1 + wts_k(1:length(gk1))*gk1_mag + wts_k(length(gk1)+1:end)'*hk1_mag;
    elseif iscolumn(wts_k(1:length(gk))) && ~iscolumn(wts_k(length(gk)+1:end))
        phi_k1 = fk1 + wts_k(1:length(gk1))'*gk1_mag + wts_k(length(gk1)+1:end)*hk1_mag;
    elseif ~iscolumn(wts_k(1:length(gk))) && ~iscolumn(wts_k(length(gk)+1:end))
        phi_k1 = fk1 + wts_k(1:length(gk1))*gk1_mag + wts_k(length(gk1)+1:end)*hk1_mag;
    end
    
    % Gradient of merit function wrt x at next iterate
    if isempty(gk) && isempty(hk)

        grad_phi_k = grad_fk;
        grad_phi_k1 = grad_fk1;

    elseif isempty(gk)

        grad_phi_k = grad_fk + wts_k(length(gk)+1:end)'*jacob_hk;
        grad_phi_k1 = grad_fk1 + wts_k(length(gk1)+1:end)'*jacob_hk1;

    elseif isempty(hk)
        grad_phi_k = grad_fk + wts_k(1:length(gk))'*jacob_gk;
        grad_phi_k1 = grad_fk1 + wts_k(1:length(gk1))'*jacob_gk1;

    else
        grad_phi_k = grad_fk + wts_k(1:length(gk))'*jacob_gk + wts_k(length(gk)+1:end)'*jacob_hk;
        grad_phi_k1 = grad_fk1 + wts_k(1:length(gk1))'*jacob_gk1 + wts_k(length(gk1)+1:end)'*jacob_hk1;

    end
    
    counterLS = counterLS + 1;                  % Increment counter
    
end

alpha_k_final = alpha_k;