%% Mamdani FIS
format compact
clear
clc

%% Creating Mamdani Fuzzy Inference System
fis=newfis('tipper','mamdani');

%Add input - output variables and fuzzy partition
fis=addvar(fis,'input','service',[0 10]);
fis=addmf(fis,'input',1,'poor','gaussmf',[2 0]);
fis=addmf(fis,'input',1,'good','gaussmf',[2 5]);
fis=addmf(fis,'input',1,'excellent','gaussmf',[2 10]);

fis=addvar(fis,'input','food', [0 10]);
fis=addmf(fis,'input',2,'rancid','trapmf',[-3 0 2 4]);
fis=addmf(fis,'input',2,'mediocre','trapmf',[2 4 6 8]);
fis=addmf(fis,'input', 2,'delicious','trapmf',[6 8 10 13]);

fis=addvar(fis,'output','tip',[0 30]);
fis=addmf(fis,'output',1,'cheap','trimf',[0 5 10]);
fis=addmf(fis,'output',1,'medium','trimf',[10 15 20]);
fis=addmf(fis,'output',1,'generous','trimf',[20 25 30]);

%% Add Fuzzy Rule Base
ruleList=[1 1 1 1 1;
          1 2 1 1 1;
          1 3 2 1 1;
          2 1 1 1 1;
          2 2 2 1 1;
          2 3 3 1 1;
          3 1 2 1 1;
          3 2 3 1 1;
          3 3 3 1 1];
fis=addrule(fis,ruleList);

%% Plotting Rule Firing Strength
[x1,y1]=plotmf(fis,'input',1);
[x2,y2]=plotmf(fis,'input',2);
RuleStrength=zeros(length(y1),length(y2));
count=1;
for i=1:3
    for j=1:3
        figure(count);
        subplot(3,3,[1 4]);
        plot(y2(:,j),x2(:,j),'LineWidth',2); grid on;
        legend(fis.input(2).mf(j).name);
        xlabel(fis.input(2).name);
        subplot(3,3,[8 9])
        plot(x1(:,i),y1(:,i),'LineWidth',2); grid on;
        legend(fis.input(1).mf(i).name);
        xlabel(fis.input(1).name);
        Y1=repmat(y1(:,i),[1 length(y1)]);
        Y2=repmat(y2(:,j),[1 length(y2)])';
        Y=min(Y1,Y2);
        subplot(3,3,[2 3 5 6]);
        surf(x1(:,i),x2(:,j),Y);
        title(['Rule #' num2str(count) 'firing Strength']);
        count=count+1;
        RuleStrength=max(RuleStrength,Y);
    end
end

%% Plot Overall Rule Base
figure;
subplot(3,3,[1 4]);
plot(y2,x2,'LineWidth',2); grid on;
legend(fis.input(2).mf(1).name,fis.input(2).mf(2).name,fis.input(2).mf(3).name);
ylabel(fis.input(2).name);
xlabel('μ');
title('Food Variable Partition');
subplot(3,3,[8 9]);
plot(x1,y1,'LineWidth',2); grid on;
legend(fis.input(1).mf(1).name,fis.input(1).mf(2).name,fis.input(1).mf(3).name);
xlabel(fis.input(1).name);
ylabel('μ');
title('Service Variable Partition');
subplot(3,3,[2 3 5 6]);
surf(linspace(0,10,length(y1)),linspace(0,10,length(y2)),RuleStrength);
xlabel('Food Variable');
ylabel('Service Variable');
zlabel('μ');
title('Rule Activation Surface');
zlim([0 1]);
