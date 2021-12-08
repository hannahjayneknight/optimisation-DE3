clear all;

% sampling
lhs = lhsdesign(30, 4, 'Iterations', 20);
R_min = 0; R_max = 0; %revolutions of the helix
rh_min = 0; rh_max = 0; %radius of the helix
ro_min = 0; ro_max = 0; %outer radius of the water pipe
p_min = 0; p_max = 0; %pitch of the helix

R_range = R_max - R_min; %ranges
rh_range = rh_max - rh_min;
ro_range = ro_max - ro_min;
p_range = p_max - p_min;

lhs_R = R_min + lhs(:,1)*R_range;
lhs_rh = rh_min + lhs(:,1)*rh_range;
lhs_ro = ro_min + lhs(:,1)*ro_range;
lhs_p = p_min + lhs(:,1)*p_range;
lhs_var = [lhs_R lhs_rh lhs_ro lhs_p];