clear all; close all;

x = [2, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6]';
y = [0.2, 0.46, 1.28, 1.31, 2.71, 7, 8.64, 14.76, 26.85]';

ln_y = log(y);

X = [ones(size(y)),x];
y_hat = ln_y;

betas = inv(X'*X)*X'*y_hat;

y_val = exp(betas(1))*exp(betas(2)*x);

figure;
plot(x,y_val);
hold on
scatter(x,y);