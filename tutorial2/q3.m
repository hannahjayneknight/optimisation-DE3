clear all; clc; 

% Load data sets (identical sizes)
% 11 attributes and 1599 entries for each
load 'red_wine_quality_data';
load 'white_wine_quality_data';

% Shuffle data sets
rng(1);                                 % MATLAB random seed 1
newInd = randperm(length(red_wine_y));  % New index order for data sets

red_wine_x_new = red_wine_x(newInd,:);      % Shuffled red wine x-data
red_wine_y_new = red_wine_y(newInd);        % Shuffled red wine y-data
white_wine_x_new = white_wine_x(newInd,:);  % Shuffled white wine x-data
white_wine_y_new = white_wine_y(newInd);    % Shuffled white wine x-data

%%
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

%%
% extracting the first 5 test data points for red wine
extractx = red_wine_x_newTest1(:,(1: 5));
extracty = red_wine_y_newTest1(:,(1: 5));


%%
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

%%
% regression
% we apply mvregress to the training data

% LINEAR REGRESSION MODELS, CASE 1
betaRedWine1 = mvregress(red_wine_x_newTrain1',red_wine_y_newTrain1');
betaWhiteWine1 = mvregress(white_wine_x_newTrain1',white_wine_y_newTrain1');

% LINEAR REGRESSION MODELS, CASE 2
betaRedWine2 = mvregress(red_wine_x_newTrain2',red_wine_y_newTrain2');
betaWhiteWine2 = mvregress(white_wine_x_newTrain2',white_wine_y_newTrain2');

%%
% analysis
% we apply r2 formula to the testing data

% R2 VALUES, CASE 1
Rsq_redWine_1 = 1 - norm(red_wine_x_newTest1'*betaRedWine1 - red_wine_y_newTest1')^2/norm(red_wine_y_newTest1-mean(red_wine_y_newTest1))^2;
Rsq_whiteWine_1 = 1 - norm(white_wine_x_newTest1'*betaWhiteWine1 - white_wine_y_newTest1')^2/norm(white_wine_y_newTest1-mean(white_wine_y_newTest1))^2;

% R2 VALUES, CASE 2
Rsq_redWine_2 = 1 - norm(red_wine_x_newTest2'*betaRedWine2 - red_wine_y_newTest2')^2/norm(red_wine_y_newTest2-mean(red_wine_y_newTest2))^2;
Rsq_whiteWine_2 = 1 - norm(white_wine_x_newTest2'*betaWhiteWine2 - white_wine_y_newTest2')^2/norm(white_wine_y_newTest2-mean(white_wine_y_newTest2))^2;


%%
%{


R2 ANALYSIS

| R2 value | Red wine | White wine |
|----------|----------|------------|
| CASE 1   | 0.2629   | 0.2526     |
| CASE 2   | 0.2628   | 0.2511     |

This shows that the R2 value for case 2 is lower for both wines. White wine
has a lower R2 than red wine for both cases.


LINEAR MODEL ANALYSIS

| betaRedWine1                                                                                                         | betaRedWine2                                                                                                         | betaWhiteWine1                                                                                                       | betaWhiteWine2                                                                                                       |
|----------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------|
| 0.0026    -0.2386    -0.0238    -0.0144    -0.0900     0.0925    -0.1538    -0.0080    -0.1101     0.1968     0.3950 | 0.0023    -0.2389    -0.0243    -0.0145    -0.0900     0.0925    -0.1537    -0.0076    -0.1108     0.1969     0.3952 | 0.1759    -0.1852    -0.0410     0.6110    -0.0330     0.1313     0.0187    -0.8032     0.2470     0.1097     0.1017 | 0.1765    -0.1851    -0.0413     0.6118    -0.0331     0.1315     0.0187    -0.8054     0.2466     0.1095     0.1017 |

This shows that, for red wine, the largest influencer on prediction is x11
= Alcohol content and the smallest influencer is x1 = Fixed Acidity. This
is the same for both cases.

For white wine, the largest influencer is x4 = Residual Sugar, and the smallest influencer
is x7 = Total Sulfur Dioxide.


NON-LINEAR MODEL ANALYSIS

%}

