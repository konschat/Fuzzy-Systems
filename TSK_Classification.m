%% ANFIS - Classification Example
format compact
clear 
clc

%% Load data - Split data
data=load('iris.dat');
preproc=1;
[trnData,chkData,tstData]=split_scale(data,preproc);

%% ANFIS - Grid Partition
fis=genfis1(trnData,2,'gaussmf','constant');
[trnFis,trnError,~,valFis,valError]=anfis(trnData,fis,[100 0 0.01 0.9 1.1],[],chkData);
plot([trnError valError],'LineWidth',2); grid on;
legend('Training Error','Validation Error');
xlabel('# of Epochs');
ylabel('Error');
title('ANFIS Classification with Grid Partition');
Y=evalfis(tstData(:,1:end-1),valFis);
Y=round(Y);
diff=tstData(:,end)-Y;
Acc=(length(diff)-nnz(diff))/length(Y)*100;

%% ANFIS - Scatter Partition
fis=genfis2(trnData(:,1:end-1),trnData(:,end),0.4);
[trnFis,trnError,~,valFis,valError]=anfis(trnData,fis,[100 0 0.01 0.9 1.1],[],chkData);
plot([trnError valError],'LineWidth',2); grid on;
legend('Training Error','Validation Error');
xlabel('# of Epochs');
ylabel('Error');
title('ANFIS Classification with Grid Partition');
Y=evalfis(tstData(:,1:end-1),valFis);
Y=round(Y);
diff=tstData(:,end)-Y;
Acc=(length(diff)-nnz(diff))/length(Y)*100;

%% ANFIS - Scatter Partition - Clustering Per Class (Larger Dataset Example)
data=load('phoneme.dat');
preproc=1;
[trnData,chkData,tstData]=split_scale(data,preproc);

%%Clustering Per Class
radius=0.5;
[c1,sig1]=subclust(trnData(trnData(:,end)==0,:),radius);
[c2,sig2]=subclust(trnData(trnData(:,end)==1,:),radius);
num_rules=size(c1,1)+size(c2,1);

%Build FIS From Scratch
fis=newfis('FIS_SC','sugeno');

%Add Input-Output Variables
names_in={'in1','in2','in3','in4','in5'};
for i=1:size(trnData,2)-1
    fis=addvar(fis,'input',names_in{i},[0 1]);
end
fis=addvar(fis,'output','out1',[0 1]);

%Add Input Membership Functions
name='sth';
for i=1:size(trnData,2)-1
    for j=1:size(c1,1)
        fis=addmf(fis,'input',i,name,'gaussmf',[sig1(j) c1(j,i)]);
    end
    for j=1:size(c2,1)
        fis=addmf(fis,'input',i,name,'gaussmf',[sig2(j) c2(j,i)]);
    end
end

%Add Output Membership Functions
params=[zeros(1,size(c1,1)) ones(1,size(c2,1))];
for i=1:num_rules
    fis=addmf(fis,'output',1,name,'constant',params(i));
end

%Add FIS Rule Base
ruleList=zeros(num_rules,size(trnData,2));
for i=1:size(ruleList,1)
    ruleList(i,:)=i;
end
ruleList=[ruleList ones(num_rules,2)];
fis=addrule(fis,ruleList);

%Train & Evaluate ANFIS
[trnFis,trnError,~,valFis,valError]=anfis(trnData,fis,[100 0 0.01 0.9 1.1],[],chkData);
plot([trnError valError],'LineWidth',2); grid on;
legend('Training Error','Validation Error');
xlabel('# of Epochs');
ylabel('Error');
Y=evalfis(tstData(:,1:end-1),valFis);
Y=round(Y);
diff=tstData(:,end)-Y;
Acc=(length(diff)-nnz(diff))/length(Y)*100;

%Compare with Class-Independent Scatter Partition
fis=genfis2(trnData(:,1:end-1),trnData(:,end),radius);
[trnFis,trnError,~,valFis,valError]=anfis(trnData,fis,[100 0 0.01 0.9 1.1],[],chkData);
plot([trnError valError],'LineWidth',2); grid on;
legend('Training Error','Validation Error');
xlabel('# of Epochs');
ylabel('Error');
Y=evalfis(tstData(:,1:end-1),valFis);
Y=round(Y);
diff=tstData(:,end)-Y;
Acc=(length(diff)-nnz(diff))/length(Y)*100;