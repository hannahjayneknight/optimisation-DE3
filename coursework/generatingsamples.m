clear all;

% sampling
lhs = lhsdesign(30, 4, 'Iterations', 20); %<--- increase this to 70
R_min = 2e-03; R_max = 25e-03; %revolutions of the helix
rh_min = 17.5e-03; rh_max = 23.5e-03; %radius of the helix
ro_min = 1.5e-03; ro_max = 7.5e-03; %outer radius of the water pipe
p_min = 4e-03; p_max = 50e-03; %pitch of the helix

R_range = R_max - R_min; %ranges
rh_range = rh_max - rh_min;
ro_range = ro_max - ro_min;
p_range = p_max - p_min;

lhs_R = R_min + lhs(:,1)*R_range;
lhs_rh = rh_min + lhs(:,2)*rh_range;
lhs_ro = ro_min + lhs(:,3)*ro_range;
lhs_p = p_min + lhs(:,4)*p_range;
lhs_ri = lhs_ro - 1e-03;

%getting results from the equation

%constants
k = 237;
delta_T = 107;
squareroot = sqrt( (lhs_p.^2) + ( 2*pi .* lhs_rh) .^2);
lhs_Q = ( 2*pi*k*lhs_R.*squareroot*delta_T)./ log(lhs_ro./(lhs_ri));
lhs_var = [lhs_R lhs_rh lhs_ro lhs_p lhs_Q];
writematrix(lhs_var, 'lhs_samples.csv');
