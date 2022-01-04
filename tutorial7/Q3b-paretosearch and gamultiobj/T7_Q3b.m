%% DE3 Optimisation: Tutorial 7 Q3b 
%
% This script performs multi-objective optimisation of a cantilever 
% beam. It minimises the volume and maximises the force that can be 
% applied with respect to length, width and height subject to stress, 
% deflection and geometry constraints. 
% 
% Two strategies are used and plotted, namely a paretosearch solution
% and gamultiobj solution. 
%
clear
clc
%% Initialize parameters and inputs
E = 2300000000;     % 2.3 GPa
sigmay = 45000000;  % 45 MPa

A = [-1/10,1,0,0;-1/10,0,1,0];
b = [0,0];
Aeq=[];
beq=[];

xlb = [0.3;0.001;0.001]; % length = x(1); width = x(2); hight = x(3);
xub = [2;2;2];

Flb = 1;
Fub = 10000;

fun = @(x)objval(x);
fun1 = @(x)pickindex(x,1);
fun2 = @(x)pickindex(x,2);
nlcon = @(x)nonlcon(x,E,sigmay);

%% paretosearch
opts_ps = optimoptions('paretosearch','PlotFcn','psplotparetof','ParetoSetSize',160);
[x_ps,fval_ps,] = paretosearch (fun,4,A,b,Aeq,beq,[xlb;Flb/1e4],[xub;Fub/1e4],nlcon,opts_ps);

%% gamultiobj
opts_ga = optimoptions('gamultiobj','PlotFcn','gaplotpareto','PopulationSize',160,'ConstraintTolerance',1e-6);
[x_ga,fval_ga,] = gamultiobj (fun,4,A,b,Aeq,beq,[xlb;Flb/1e4],[xub;Fub/1e4],nlcon,opts_ga);

%% Start from Single-Objective Solution
x0=zeros(2,4);
x0f = [1;0.1;0.1;1/10000];
options = optimset('Algorithm','sqp');
x0(1,:) = fmincon(fun1,x0f,A,b,Aeq,beq,[xlb;Flb/1e4],[xub;Fub/1e4],nlcon,options);
x0(2,:) = fmincon(fun2,x0f,A,b,Aeq,beq,[xlb;Flb/1e4],[xub;Fub/1e4],nlcon,options);

% paretosearch
opts_ps = optimoptions('paretosearch','PlotFcn','psplotparetof','ParetoSetSize',160,'InitialPoints',x0);
[x_psx0,fval_psx0] = paretosearch(fun,4,A,b,Aeq,beq,[xlb;Flb/1e4],[xub;Fub/1e4],nlcon,opts_ps);

%% gamultiobj
opts_ga = optimoptions('gamultiobj','PlotFcn','gaplotpareto','PopulationSize',160,'InitialPopulationMatrix',x0,'ConstraintTolerance',1e-6);
[x_gax0,fval_gax0,] = gamultiobj (fun,4,A,b,Aeq,beq,[xlb;Flb/1e4],[xub;Fub/1e4],nlcon,opts_ga);


%% Compare Solution
figure(1)
hold on
% fps = sortrows(fval_ps,1,'ascend');
% plot(fps(:,1),-fps(:,2),'r--')
% fga = sortrows(fval_ga,1,'ascend');
% plot(fga(:,1),-fga(:,2),'b--')
fpsx0 = sortrows(fval_psx0,1,'ascend');
plot(fpsx0(:,1),-fpsx0(:,2),'r-')
fgax0 = sortrows(fval_gax0,1,'ascend');
plot(fgax0(:,1),-fgax0(:,2),'b-')
legend({'paretosearch','gamultiobj','paretosearch x0','gamultiobj x0'},'Location','SouthEast')
xlabel 'volume'
ylabel 'Force'
hold off

%% Objective function
function Fun = objval(x)
    % Define 3 elements of x vector as individual variables length, width, height
    l = x(1); w = x(2); h = x(3); F = x(4);
    % Define volume
    Fun(1) = l*w*h;
    Fun(2) = -F*10000;
    
    
end

function z = pickindex(x,k)
    z = objval(x);
    z = z(k);
end

%% Constraints function
function [g,geq] = nonlcon(x,E,sigmay)

    % Define 3 elements of x vector as individual variables length, width, height
    l = x(1); w = x(2); h = x(3); F = x(4)*10000;
    % Define each constraint as an element of the vector g
    g(1) = (6*F*l)/(w*h^2)-sigmay;
    g(2) = (F*l^3)/(3*E*(w*h^3/12)) - 0.005;

    % Since there are no equality constraints, we create "geq" as an empty vector
    geq = [];
end




