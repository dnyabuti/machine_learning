%Davis Nyabuti
%Assignment #2
%SEIS 763

load patients

% categorical vars
n_Gender = nominal(Gender);
n_Location = nominal(Location);
n_SAHS = nominal(SelfAssessedHealthStatus);

% model data
x = table(Age, n_Gender, Height, Weight, Smoker ...
    , n_Location,n_SAHS,Systolic);
% normalize, outliers, Dummy Variables

% linear model
mdl = fitlm(x);

% coefficients
disp('Model Coefficients');
mdl.Coefficients

% Standardize variables
n_Age = zscore(Age);
n_Height = zscore(Height);
n_Weight = zscore(Weight);

% model data
x_norm = table(n_Age, n_Gender, n_Height, n_Weight, Smoker ...
    , n_Location,n_SAHS,Systolic);

% Build model with normalized data
mdl_norm = fitlm(x_norm);

% Use normal probability plot of residuals to check for outliers
normplot(mdl_norm.Residuals.Raw);
% identified observation 60 as a potential outlier
x_norm(60,:) = [];
mdl_norm = fitlm(x_norm);
disp('Normalized Model Coefficients');
mdl_norm.Coefficients

% Identify insignificant variables
figure,
for i = 1 : mdl_norm.NumCoefficients, ...
    subplot(mdl_norm.NumCoefficients, 1, i),
    plotAdded(mdl_norm, mdl_norm.CoefficientNames{i});
end