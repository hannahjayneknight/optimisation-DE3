clear; 

% Load data sets (identical sizes)
load 'red_wine_quality_data';
load 'white_wine_quality_data';

% Shuffle data sets
rng(1);                                 % MATLAB random seed 1
newInd = randperm(length(red_wine_y));  % New index order for data sets

red_wine_x_new = red_wine_x(newInd,:);      % Shuffled red wine x-data
red_wine_y_new = red_wine_y(newInd);        % Shuffled red wine y-data
white_wine_x_new = white_wine_x(newInd,:);  % Shuffled white wine x-data
white_wine_y_new = white_wine_y(newInd);    % Shuffled white wine x-data

% SPLIT DATA SETS (75%-25% RULE) & NORMALIZE WRT TRAINING SET
% CASE 1 SPLIT: FLOOR(0.75*N)

splitPt1 = floor(0.75*length(red_wine_y));  % Case 1 split point

% Normalization of training data sets
[red_wine_x_newTrain1,PS_rwxTrain1] = mapstd(red_wine_x_new(1:splitPt1,:)');
[red_wine_y_newTrain1,PS_rwyTrain1] = mapstd(red_wine_y_new(1:splitPt1)');
[white_wine_x_newTrain1,PS_wwxTrain1] = mapstd(white_wine_x_new(1:splitPt1,:)');
[white_wine_y_newTrain1,PS_wwyTrain1] = mapstd(white_wine_y_new(1:splitPt1)');

% Normalization of test data sets
red_wine_x_newTest1 = mapstd('apply',red_wine_x_new(splitPt1+1:end,:)',PS_rwxTrain1);
red_wine_y_newTest1 = mapstd('apply',red_wine_y_new(splitPt1+1:end)',PS_rwyTrain1);
white_wine_x_newTest1 = mapstd('apply',white_wine_x_new(splitPt1+1:end,:)',PS_wwxTrain1);
white_wine_y_newTest1 = mapstd('apply',white_wine_y_new(splitPt1+1:end)',PS_wwyTrain1);

% CASE 2 SPLIT: CEIL(0.75*N)

splitPt2 = ceil(0.75*length(red_wine_y));  % Case 2 split point

% Normalization of training data sets
[red_wine_x_newTrain2,PS_rwxTrain2] = mapstd(red_wine_x_new(1:splitPt2,:)');
[red_wine_y_newTrain2,PS_rwyTrain2] = mapstd(red_wine_y_new(1:splitPt2)');
[white_wine_x_newTrain2,PS_wwxTrain2] = mapstd(white_wine_x_new(1:splitPt2,:)');
[white_wine_y_newTrain2,PS_wwyTrain2] = mapstd(white_wine_y_new(1:splitPt2)');

% Normalization of test data sets
red_wine_x_newTest2 = mapstd('apply',red_wine_x_new(splitPt2+1:end,:)',PS_rwxTrain2);
red_wine_y_newTest2 = mapstd('apply',red_wine_y_new(splitPt2+1:end)',PS_rwyTrain2);
white_wine_x_newTest2 = mapstd('apply',white_wine_x_new(splitPt2+1:end,:)',PS_wwxTrain2);
white_wine_y_newTest2 = mapstd('apply',white_wine_y_new(splitPt2+1:end)',PS_wwyTrain2);

% LINEAR REGRESSION MODELS, CASE 1
betaRedWine1 = mvregress(red_wine_x_newTrain1',red_wine_y_newTrain1');
betaWhiteWine1 = mvregress(white_wine_x_newTrain1',white_wine_y_newTrain1');

% LINEAR REGRESSION MODELS, CASE 2
betaRedWine2 = mvregress(red_wine_x_newTrain2',red_wine_y_newTrain2');
betaWhiteWine2 = mvregress(white_wine_x_newTrain2',white_wine_y_newTrain2');

% R2 VALUES, CASE 1
Rsq_redWine_1 = 1 - norm(red_wine_x_newTest1'*betaRedWine1 - red_wine_y_newTest1')^2/norm(red_wine_y_newTest1-mean(red_wine_y_newTest1))^2;
Rsq_whiteWine_1 = 1 - norm(white_wine_x_newTest1'*betaWhiteWine1 - white_wine_y_newTest1')^2/norm(white_wine_y_newTest1-mean(white_wine_y_newTest1))^2;

% R2 VALUES, CASE 2
Rsq_redWine_2 = 1 - norm(red_wine_x_newTest2'*betaRedWine2 - red_wine_y_newTest2')^2/norm(red_wine_y_newTest2-mean(red_wine_y_newTest2))^2;
Rsq_whiteWine_2 = 1 - norm(white_wine_x_newTest2'*betaWhiteWine2 - white_wine_y_newTest2')^2/norm(white_wine_y_newTest2-mean(white_wine_y_newTest2))^2;
