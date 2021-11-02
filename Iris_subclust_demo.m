%% Subtractive Clustering Demo - Iris Dataset
format compact
clear 
clc

%% Load Data
data=load('iris.dat');
xmin=min(data,[],1);
xmax=max(data,[],1);
%bounds=[xmin;xmax];
data=(data-xmin)./(xmax-xmin);
setosa=data(data(:,end)==0,:);
versicolor=data(data(:,end)==0.5,:);
virginica=data(data(:,end)==1,:);

%% Initial Plot
Attributes={'Sepal Length','Sepal Width','Petal Length','Petal Width'};
pairs=[1 2;
       1 3;
       1 4;
       2 3;
       2 4;
       3 4];
for i=1:6
    x=pairs(i,1);
    y=pairs(i,2);
    subplot(3,2,i);
    plot([setosa(:,x) versicolor(:,x) virginica(:,x)],[setosa(:,y) versicolor(:,y) virginica(:,y)],'.','MarkerSize',15); grid on;
    xlabel(Attributes{x});
    ylabel(Attributes{y});
    legend('Setosa','Versicolor','Virginica');
end

%% Generate Clusters
ra=0.5;
quash_factor=1.5;
eps_high=0.5;
eps_low=0.15;
[centers,sigmas]=subtractive_clustering(data,ra,[],quash_factor,eps_high,eps_low);

%% Plot with Clusters
radius=sigmas(1);
for i=1:6
    x=pairs(i,1);
    y=pairs(i,2);
    subplot(3,2,i);
    plot([setosa(:,x) versicolor(:,x) virginica(:,x)],[setosa(:,y) versicolor(:,y) virginica(:,y)],'.','MarkerSize',15);
    legend('Setosa','Versicolor','Virginica');
    xlabel(Attributes{x});
    ylabel(Attributes{y});
    grid on;
    hold on;
    plot(centers(:,x),centers(:,y),'*','MarkerSize',20)
    hold on;
    viscircles([centers(:,x) centers(:,y)],repmat(radius,[size(centers,1) 1]));
end

%% Plot Clusters & Projections

%Obtain Membership functions
i=0:0.01:1;

%Plot
for p=1:size(pairs,1)
    figure();
    x=pairs(p,1);
    y=pairs(p,2);
    
    h=[];
    v=[];
    for j=1:size(centers,1)
        h=[h gaussmf(i,[radius centers(j,x)])'];
        v=[v gaussmf(i,[radius centers(j,y)])'];
    end
    
    subplot(3,3,[2 3 5 6])
    plot([setosa(:,x) versicolor(:,x) virginica(:,x)],[setosa(:,y) versicolor(:,y) virginica(:,y)],'.','MarkerSize',15);
    xlabel(Attributes{x});
    ylabel(Attributes{y});
    legend('Setosa','Versicolor','Virginica');
    title('Clusters in 2D subspace of Iris Dataset');
    grid on;
    hold on;
    plot(centers(:,x),centers(:,y),'*','MarkerSize',20);
    xlim([0 1]);
    ylim([0 1]);
    hold on;
    viscircles([centers(:,x) centers(:,y)],repmat(radius,[size(centers,1) 1]));
    
    subplot(3,3,[1 4]);
    plot(v,i,'LineWidth',2);
    grid on;
    ylabel('x');
    xlabel('μ');
    title('Membership Functions');
    
    subplot(3,3,[8 9]);
    plot(i,h,'LineWidth',2);
    grid on;
    xlabel('x');
    ylabel('μ');
    title('Membership Functions');
    
    disp('Press a key to continue...')
    pause;
    close;
end
