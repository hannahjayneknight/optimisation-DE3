% gradObj is a function that computes the gradient of the objective function
% for a nonlinear, continuous optimisation problem.
%
% Input(s): x - design variable vector
%
% Output(s): grad_f - gradient of the objective at current iterate



function grad_f = gradObj(x)

df_dx1 = 2*x(1);
df_dx2 = 2*(x(2)-3);

grad_f = [df_dx1,df_dx2];
