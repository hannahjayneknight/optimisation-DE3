% Using NSGA-II code downloaded from:
% http://www.mathworks.com/matlabcentral/fileexchange/31166-ngpm-a-nsga-ii-program-in-matlab-v1-4

options = nsgaopt();                    % create default options structure
options.popsize = 10;                   % populaion size
options.maxGen  = 100;                  % max generation

options.numObj = 2;                     % number of objectives
options.numVar = 4;                    % number of design variables
options.numCons = 4;                    % number of constraints
options.lb = [0.3,0.001,0.001,1];
options.ub = [2,2,2,1000];                % upper bound of x
options.objfun = @beam_obj_con;         % objective function handle

options.plotInterval = 10;              % large interval for efficiency
options.outputInterval = 10;

result = nsga2(options);






