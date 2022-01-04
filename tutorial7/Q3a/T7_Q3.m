%% DE3 Optimisation: Tutorial 7 - MOO 
%
% This script performs multi-objective optimisation of a cantilever 
% beam. It minimises the volume and maximises the force that can be 
% applied with respect to length, width and height subject to stress, 
% deflection and geometry constraints. 
% 
% Two strategies are used and plotted, namely a weighted-sum
% approach and constraint-based approach. 
%

clear
% close all
% fclose all;
clc
%% Initialize parameters and inputs
E = 2300000000;     % 2.3 GPa
sigmay = 45000000;  % 45 MPa
x0 = [1;0.1;0.1];
xlb = [0.3;0.001;0.001];
xub = [2;2;2];
F0 = 1;
Flb = 1;
Fub = 10000;
%% Optimize for V only
options = optimset('Algorithm','sqp');
w = [1,0];
[xoptV,foptV] = fmincon(@(xF) beamVFws(xF,w),[x0;F0],[],[],[],[],[xlb;Flb],[xub;Fub],@(xF) beamconws(xF,E,sigmay),options);
foptVF = beamF(xoptV(4));
%% Optimize for F only
w = [0,1];
[xoptF,foptF] = fmincon(@(xF) beamVFws(xF,w),[x0;F0],[],[],[],[],[xlb;Flb],[xub;Fub],@(xF) beamconws(xF,E,sigmay),options);
foptFV = beamV(xoptF);
%% Optimize with a weighted sum
n = 21;     % Number of Pareto points to produce
% wsweights = linspace(0,1,n); % Note that this only results in 2 points...
wsweights = linspace(0.9995,1,n);
xws = zeros(n,4); 
fws = zeros(n,3); % 1st col V, 2nd col F, 3rd col weighted obj
for i = 1:n
    w = [wsweights(i), 1-wsweights(i)];
    [xopt,fopt] = fmincon(@(xF) beamVFws(xF,w),[x0;F0],[],[],[],[],[xlb;Flb],[xub;Fub],@(xF) beamconws(xF,E,sigmay),options);
    xws(i,:) = xopt; 
    fws(i,3) = fopt;
    fws(i,1) = beamV(xws(i,:));
    fws(i,2) = xws(i,4);
end
%% Optimize with a constraint-based approach
highestF = -foptF;
lowestF = -foptVF;
conspace = lowestF + linspace(0,1,n)*(highestF-lowestF);
xc = zeros(n,4); fc = zeros(n,2);
for i = 1:n
    epsilon = conspace(i);
    [xc(i,:),f] = fmincon(@(xF) beamV(xF),[x0;F0],[],[],[],[],[xlb;Flb],[xub;Fub],@(xF) beamconc(xF,E,sigmay,epsilon),options);
    fc(i,1) = f;
    fc(i,2) = xc(i,4);
end
%% Plot Pareto frontiers
figure()
hold on
plot(fws(:,1),fws(:,2),'ro')
xlabel('V'); ylabel('F');
plot(fc(:,1),fc(:,2),'b+')
plot(foptFV,-foptF,'k*')
plot(foptV,-foptVF,'k*')
legend({'Weighted-sum','Constraint-based'},'Location','SouthEast')