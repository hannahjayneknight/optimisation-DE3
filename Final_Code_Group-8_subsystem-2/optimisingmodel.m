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
%NB:
%objective = @(x) ...
%            p_Q.Coefficients(1) + ...
%            p_Q.Coefficients(2)*x(1) + p_Q.Coefficients(3)*x(2) + ...
%            p_Q.Coefficients(4)*x(3) + p_Q.Coefficients(5)*x(4) + ...
%            p_Q.Coefficients(6)*(x(1).^2) + p_Q.Coefficients(7)*(x(2).^2) + ...
%            p_Q.Coefficients(8)*(x(3).^2) + p_Q.Coefficients(9)*(x(4).^2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Testing the models

%linear regression - TRAINING
forecast_linearTRAIN = dataTrain_ds*beta;
difference_linearTRAIN = forecast_linearTRAIN - dataTrain_Q;
rmse_linearTRAIN = sqrt(mean((difference_linearTRAIN - forecast_linearTRAIN).^2));
rsq_linearTRAIN = 1 - norm(forecast_linearTRAIN - difference_linearTRAIN)^2/norm(difference_linearTRAIN-mean(difference_linearTRAIN))^2;

%linear regression - TESTING
forecast_linearTEST = dataTest_ds*beta;
difference_linearTEST = forecast_linearTEST - dataTest_Q;
rmse_linearTEST = sqrt(mean((forecast_linearTEST - forecast_linearTEST).^2));
rsq_linearTEST = 1 - norm(forecast_linearTEST - forecast_linearTEST)^2/norm(forecast_linearTEST-mean(forecast_linearTEST))^2;


% Polynomial regression - TRAINING
forcast_polyTRAIN = polyval(p_Q.Coefficients, dataTrain_ds);
difference_polyTRAIN = forcast_polyTRAIN - dataTrain_Q;
rmse_polyTRAIN = sqrt(mean((difference_polyTRAIN - forcast_polyTRAIN).^2));
rsq_polyTRAIN = 1 - norm(forcast_polyTRAIN - difference_polyTRAIN)^2/norm(difference_polyTRAIN-mean(difference_polyTRAIN))^2;

% Polynomial regression - TESTING
forcast_polyTEST = polyval(p_Q.Coefficients, dataTest_ds);
difference_polyTEST = forcast_polyTEST - dataTest_Q;
rmse_polyTEST = sqrt(mean((difference_polyTEST - forcast_polyTEST).^2));
rsq_polyTEST = 1 - norm(forcast_polyTEST - difference_polyTEST)^2/norm(difference_polyTEST-mean(difference_polyTEST))^2;

%NB:    the lower the rmse the better
%       the higher the rsq the better

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% setting up optimisation and SQP


% coefficients = p_Q.Coefficients(1)...
% x1 = R
% x2 = rh
% x3 = ro
% x4 = p


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


objective = @(x) 2*pi*237*x(1)*sqrt( (x(4)^2) + ( 2*pi * x(2)) ^2)*107/ log(x(3)/(x(3)-1e-03)); %derived equation for Q

% initial point for design variable (=current values of nespresso's
% thermoblock)
x0 = [5, 23.5e-03, 2.5e-03, 10e-03];

% optimisation options
options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'sqp');

% call the solver
[x, fval] = fmincon(objective, x0, A, b, Aeq, beq, lb, ub, @nonlcon, options);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ga

%{
objective = @(x) 2*pi*237*x(1)*sqrt( (x(4)^2) + ( 2*pi * x(2)) ^2)*107/ log(x(3)/(x(3)-1e-03)); %derived equation for Q

options = optimoptions('ga','ConstraintTolerance',1e-6);
x = ga(objective, 4, A, b, Aeq, beq, lb, ub, @nonlcon, options);
fval = 2*pi*237*x(1)*sqrt( (x(4)^2) + ( 2*pi * x(2)) ^2)*107/ log(x(3)/(x(3)-1e-03));
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% interior-point


%{
x0 = [5, 23.5e-03, 2.5e-03, 10e-03];

objective = @(x) 2*pi*237*x(1)*sqrt( (x(4)^2) + ( 2*pi * x(2)) ^2)*107/ log(x(3)/(x(3)-1e-03)); %derived equation for Q

options =   optimoptions('fmincon','Algorithm','interior-point');
x = fmincon(objective,x0,A,b,Aeq,beq,lb,ub,@nonlcon,options);
fval = 2*pi*237*x(1)*sqrt( (x(4)^2) + ( 2*pi * x(2)) ^2)*107/ log(x(3)/(x(3)-1e-03));
%}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%How much has Q increased?

Q = 2*pi*237*5*107*sqrt( (0.004^2) + ( 2*pi * 0.0015) ^2)/ log(0.0015/(0.00115)); %original Q
inc = (fval-Q)/100;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Functions

% non-linear constraints
function [c, ceq] = nonlcon(x)
    c(1) = 33 - x(1)*x(4); 
    c(2) = -100 + x(1)*x(4);
    c(3) = 513 - (2*pi*237*x(1)*sqrt( (x(4)^2) + ( 2*pi * x(2)) ^2)*107/ log(x(3)/(x(3)-1e-03))); %derived equation for Q
    
    ceq = mod(x(1), 1); %only include for sqp
    %ceq = [];
end

%objective = @(x) 2*pi*237*x(1)*sqrt( (x(4)^2) + ( 2*pi * x(2)) ^2)*107/ log(x(3)/(x(3)-1e-03)); %derived equation for Q
%objective = @(x) ...
%            (0.044586081200103 + ...
%            0.622902067280257*x(1) + 0.181019850073204*x(2) + ...
%            0.523621485465963*x(3) + 0.058712578215755*x(4) ...
%            -0.040340184693986*(x(1)^2) + 0.078212743725499*(x(2)^2) ...
%            -0.009806673120655*(x(3)^2) -0.016728228237762*(x(4)^2));