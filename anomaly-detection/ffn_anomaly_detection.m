% Anomaly Detection Feedforward net

%"timestamps","value","anomaly","changepoint","trend","noise","seasonality1","seasonality2","seasonality3"
dname='C:\Users\movis\Documents\githubprojects\machine_learning\preprocessing\data\';
%{
files=dir([dname,'*.csv']);
data = ones([1,9]);
for i=1:length(files)
    data = [data;dlmread([dname,files(i).name],',',1,0)];
end
%}
train_data = dlmread([dname,'anomaly_train.csv'],',',1,1);

valid = dlmread([dname,'anomaly_valid.csv'],',',1,1);

train_x = transpose(train_data(:,[2,4,5,6,7,8,9]));
t = transpose(train_data(:,3)>0);

valid_x = transpose(valid(:,[2,4,5,6,7,8,9]));
valid_t = transpose(valid(:,3)>0);

net = feedforwardnet([23 17 7 2],'trainlm');
net.layers{2}.transferFcn = 'logsig';
net.layers{3}.transferFcn = 'logsig';
net.layers{4}.transferFcn = 'logsig';

%net = feedforwardnet(10);
net = train(net,train_x,t);
view(net)
train_y = net(train_x);
perf = perform(net,train_y,t);

nn_pred = net(valid_x);

% Add output of network to data
train_data(:,10) = transpose(train_y);
valid(:,10) = transpose(nn_pred);

%train
X = train_data(:,[2,4,5,6,7,8,9,10]);
Y = train_data(:,3)>0;

%validation data
valid_y_actual = (valid(:,3)>0);
valid_x_svm = valid(:,[2,4,5,6,7,8,9,10]);

SVM = fitcsvm(X,Y,'KernelFunction','linear','Standardize',true);

% Predict on validation data
[label, NegLoss] = predict(SVM,valid_x_svm);

% Calculate Accuracy, Precision and Recall
cfMat = confusionmat(valid_y_actual,label);
accuracy = (cfMat(1,1)+cfMat(2,2))/33936;
recall = cfMat(1,1)/(cfMat(1,1)+cfMat(2,2));
precision = cfMat(1,1)/(cfMat(1,1) + cfMat(2,1));
disp(accuracy);
disp(recall);
disp(precision);
disp(cfMat)

modelResults = NegLoss(:,1);
modelResults(:,1)=valid_y_actual;
modelResults(:,2)= label;
modelResults(:,3) = NegLoss(:,1);



