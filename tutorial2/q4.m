% loading data

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
% part a

%{

METHOD (nb it's very slow)
1. Run nnstart in the command line
2. Click 'Fitting'.
3. Determine the ratio by which you want to split the data by.
4. Train the model using algorithm of choice (we used LM algorithm here).
5. Look at the results.

ANALYSIS OF NON-LINEAR MODEL

R2 = 0.4176

This is considerably higher than the R2 value for the linear model. Also,
the non-linear model is a black box and more difficult to interpret than
the linear models.

%}

%% 
% part b