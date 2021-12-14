clear all; 
clc;

data = csvread('lhs_samples2.csv');
data = normalize(data); %normalise data

%split into train, test etc
% Cross varidation (train: 80%, test: 20%)
cv = cvpartition(size(data,1),'HoldOut',0.2);
idx = cv.test;
% Separate to training and test data
dataTrain = data(~idx,:);
dataTest  = data(idx,:);

dataTrain_Q = dataTrain(:,5);
dataTrain_ds = dataTrain(:,1:4);

dataTest_Q  = dataTest(:,5);
dataTest_ds  = dataTest(:,1:4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Training the models

%linear regression
beta = mvregress(dataTrain_ds, dataTrain_Q);

%second-order polynomial regression
p_Q = polyfitn(dataTrain_ds,dataTrain_Q,'constant, x1, x2, x3, x4, x1^2, x2^2, x3^2, x4^2');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Testing the models

%linear regression
forecast_linear = dataTest_ds*beta;
difference_linear = forecast_linear - dataTest_Q;
rmse_linear = sqrt(mean((difference_linear - forecast_linear).^2));
rsq_linear = 1 - norm(forecast_linear - difference_linear)^2/norm(difference_linear-mean(difference_linear))^2;

% Polynomial regression
forcast_poly = polyval(p_Q.Coefficients, dataTest_ds);
difference_poly = forcast_poly - dataTest_Q;
rmse_poly = sqrt(mean((difference_poly - forcast_poly).^2));
rsq_poly = 1 - norm(forcast_poly - difference_poly)^2/norm(difference_poly-mean(difference_poly))^2;


%NB:    the lower the rmse the better
%       the higher the rsq the better

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Optimisation


% coefficients = p_Q.Coefficients(1)...
% x1 = R
% x2 = rh
% x3 = ro
% x4 = p
objective = @(x) ...
            p_Q.Coefficients(1) + ...
            p_Q.Coefficients(2)*x(1) + p_Q.Coefficients(3)*x(2) + ...
            p_Q.Coefficients(4)*x(3) + p_Q.Coefficients(5)*x(4) + ...
            p_Q.Coefficients(6)*(x(1).^2) + p_Q.Coefficients(7)*(x(2).^2) + ...
            p_Q.Coefficients(8)*(x(3).^2) + p_Q.Coefficients(9)*(x(4).^2);

% linear inequality constraints
A = [0, -1, 1, 0 ;
    0, 0, -1, 0;
    0, 0, 2, -1;
    0, 1, 1, 0;
    0, -1, 1, 0];
b = [0 ;
    -1.5e-03 ;
    -1e-03 ;
    25e-03 ;
    -17.5e-03 ];

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
    c(1) = 33 - x(1)*x(4); 
    c(2) = -100 + x(1)*x(4);
    %c(3) =  513 - (p_Q.Coefficients(1) + ...
%            p_Q.Coefficients(2)*x(1) + p_Q.Coefficients(3)*x(2) + ...
 %           p_Q.Coefficients(4)*x(3) + p_Q.Coefficients(5)*x(4) + ...
  %          p_Q.Coefficients(6)*(x(1).^2) + p_Q.Coefficients(7)*(x(2).^2) + ...
   %         p_Q.Coefficients(8)*(x(3).^2) + p_Q.Coefficients(9)*(x(4).^2));
    ceq = mod(x(1), 1);
    %ceq = [];
end

%function [c, ceq] = nonlcon2(x) %if g7 is made an equality
    %c = [];
    %ceq(1) = mod(x(1), 1);
    %ceq(2) = 100 - x(1)*x(4); %g7 
%ends
