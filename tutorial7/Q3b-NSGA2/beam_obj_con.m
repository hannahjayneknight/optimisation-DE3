function [f,cons] = beam_obj_con(x)
% Define variables as elements of x
l = x(1); w = x(2); h = x(3); F = x(4);

% Define parameters
E = 2300000000;     % 2.3 GPa
sigmay = 45000000;  % 45 MPa

% f = [0,0];
cons = [0,0,0,0];

f(1) = l*w*h;
f(2) = -F;

% Define each constraint as an element of the vector g
g(1) = w-l/10;
g(2) = h-l/10;
g(3) = (6*F*l^3)/(w*h^2)-sigmay;
g(4) = (F*l^3)/(3*E*(w*h^3/12)) - 0.005;

if(g(1)>0)
    cons(1) = abs(g(1));
end

if(g(2)>0)
    cons(2) = abs(g(2));
end

if(g(3)>0)
    cons(3) = abs(g(3));
end

if(g(4)>0)
    cons(4) = abs(g(4));
end
