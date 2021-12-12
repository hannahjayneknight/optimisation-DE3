clear all; 

data = csvread('lhs_samples.csv');
data = normalize(data); %normalise data
Q = data(:,5);
ds = data(:,1:4); %design variables

%split into train, test etc

%linear regression
beta_Q = mvregress(ds, Q);
%evaluate results
rsq = 1-norm(ds*beta_Q - Q)^2/norm(Q-mean(Q))^2 %coefficient of determination
rmse = sqrt(norm(ds*beta_Q - Q)^2/length(Q))

%second-order polynomial regression
p_Q = polyfitn(ds,Q,'constant, x1, x2, x3, x4, x1^2, x2^2, x3^2, x4^2');