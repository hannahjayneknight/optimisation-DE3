clear all; 

data = csvread('lhs_samples.csv');

%split into train, test etc
% Cross varidation (train: 80%, test: 20%)
cv = cvpartition(size(data,1),'HoldOut',0.2);
idx = cv.test;
% Separate to training and test data
dataTrain = data(~idx,:);
dataTest  = data(idx,:);
dataTrain_Q = dataTrain(:,5);
dataTest_Q  = dataTest(:,5);
dataTrain_ds = dataTrain(:,1:4);
dataTest_ds  = dataTest(:,1:4);