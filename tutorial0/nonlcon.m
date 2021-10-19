%%%%%%%%%%%% Constraint Function %%%%%%%%%%%%
function [c, ceq] = nonlcon(x) 
ceq = x(1)+x(2)+x(3)+x(4)-1;

c = -[3*x(1)+6*x(2)+11*x(3)+x(4)-5;... 
    12*x(1)+12*x(2)+42*x(3)+52*x(4)-21-... 
    5*(0.3*x(1)^2+0.2*x(2)^2+21*x(3)^2)^0.5];

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%