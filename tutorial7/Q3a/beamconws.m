function [g,geq] = beamconws(xF,E,sigmay)
% Define 3 elements of x vector as individual variables length, width, height
l = xF(1); w = xF(2); h = xF(3); F = xF(4);
% Define each constraint as an element of the vector g
g(1) = w-l/10;
g(2) = h-l/10;
g(3) = (6*F*l)/(w*h^2)-sigmay;
g(4) = (F*l^3)/(3*E*(w*h^3/12)) - 0.005;
% Since there are no equality constraints, we create "geq" as an empty vector
geq = [];