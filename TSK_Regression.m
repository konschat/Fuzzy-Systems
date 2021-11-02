%% ANFIS EXAMPLE
format compact
clear
clc

%% Load data - Split data
data=load('delta_ail.dat');
preproc=1;
[trnData,chkData,tstData]=split_scale(data,preproc);
Perf=zeros(2,4);

%% Evaluation function
Rsq = @(ypred,y) 1-sum((ypred-y).^2)/sum((y-mean(y)).^2);

%% FIS with grid partition
fis=genfis1(trnData,2,'gbellmf','constant');
[trnFis,trnError,~,valFis,valError]=anfis(trnData,fis,[100 0 0.01 0.9 1.1],[],chkData);
plotMFs(fis,size(trnData,2)-1);

%% No Validation
figure(1);
plot(trnError,'LineWidth',2); grid on;
legend('Training Error');
xlabel('# of Iterations'); ylabel('Error');
title('ANFIS Hybrid Training - No Validation');
Y=evalfis(tstData(:,1:end-1),trnFis);
R2=Rsq(Y,tstData(:,end));
RMSE=sqrt(mse(Y,tstData(:,end)));
Perf(:,1)=[R2;RMSE];
figure(2);
plotMFs(trnFis,size(trnData,2)-1);

%% Validation
figure(1);
plot([trnError valError],'LineWidth',2); grid on;
xlabel('# of Iterations'); ylabel('Error');
legend('Training Error','Validation Error');
title('ANFIS Hybrid Training - Validation');
Y=evalfis(tstData(:,1:end-1),valFis);
R2=Rsq(Y,tstData(:,end));
RMSE=sqrt(mse(Y,tstData(:,end)));
Perf(:,2)=[R2;RMSE];
figure(2);
plotMFs(valFis,size(trnData,2)-1);

%% Scatter Partition - Subtractive Clustering
fis=genfis2(trnData(:,1:end-1),trnData(:,end),0.5);
plotMFs(fis,size(trnData,2)-1);
[trnFis,trnError,~,valFis,valError]=anfis(trnData,fis,[100 0 0.01 0.9 1.1],[],chkData);
figure(1);
plot([trnError valError],'LineWidth',2); grid on;
xlabel('# of Iterations'); ylabel('Error');
legend('Training Error','Validation Error');
title('ANFIS Hybrid Training - Validation');
Y=evalfis(tstData(:,1:end-1),valFis);
R2=Rsq(Y,tstData(:,end));
RMSE=sqrt(mse(Y,tstData(:,end)));
Perf(:,3)=[R2;RMSE];
figure(2);
plotMFs(valFis,size(trnData,2)-1);

%% Scatter Partition - Fuzzy C-Means
fis=genfis3(trnData(:,1:end-1),trnData(:,end),'sugeno',8);
[trnFis,trnError,~,valFis,valError]=anfis(trnData,fis,[100 0 0.01 0.9 1.1],[],chkData);
figure(1);
plot([trnError valError],'LineWidth',2); grid on;
xlabel('# of Iterations'); ylabel('Error');
legend('Training Error','Validation Error');
title('ANFIS Hybrid Training - Validation');
Y=evalfis(tstData(:,1:end-1),valFis);
R2=Rsq(Y,tstData(:,end));
RMSE=sqrt(mse(Y,tstData(:,end)));
Perf(:,4)=[R2;RMSE];
figure(2);
plotMFs(valFis,size(trnData,2)-1);

%% Results Table
varnames={'Grid_No_Validation','Grid_Validation','Scatter_SC','Scatter_FCM'};
rownames={'Rsquared','RMSE'};
Perf=array2table(Perf,'VariableNames',varnames,'RowNames',rownames);
