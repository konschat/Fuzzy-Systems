%% Subtractive clustering main script
clear all
close all
clc

% Generate dataset
data = generate_dataset();
dmin = min(data);
dmax = max(data);
data = (data - dmin) ./ (dmax - dmin);

% Perform subtractive clustering
ra = 0.1;
quash_factor = 1.0;
eps_high = 0.5;
eps_low = 0.15;

centers = [];
alpha = 4 / (ra^2);
P = Potential(data, centers, alpha);
[P1_star, idx] = max(P);
centers = [centers; data(idx,:)];
rb = quash_factor * ra;
beta = 4 / (rb^2);
cluster_sigmas = repmat(1 / (sqrt(2) * sqrt(alpha)), [1 size(data, 2)]);
cluster_sigma = cluster_sigmas(1);
figure
rotate3d on
grid on
scatter3(data(:,1), data(:,2), P, 'filled', 'k')
hold on
plot(data(:,1), data(:,2), '.', 'MarkerSize', 10)
hold on
stem3(centers(1), centers(2), P1_star, 'LineWidth', 4)
hold on
viscircles([centers(:,1) centers(:,2)],repmat(cluster_sigma,[size(centers,1) 1]))
for i = 2 : length(data)
    P = P - P1_star * Potential(data, centers, beta);
    count = 0;
    figure
    rotate3d on
    grid on
    scatter3(data(:,1), data(:,2), P, 'filled', 'k')
    hold on
    while(count < length(P) - 1)
        [Pk_star,idx] = max(P);
        candidate = data(idx,:);
        check = criteria(P1_star, Pk_star, eps_high, eps_low, ra, centers, candidate);
        if(check == 1)
            new_center = candidate;
            centers = [centers; new_center];
            break;
        elseif(check == 0)
            break;
        else
            P(idx) = 0;
            continue;
        end
    end
    if(check == 0)
        break;
    end
    plot(data(:,1), data(:,2), '.', 'MarkerSize', 10)
    hold on
    stem3(new_center(1), new_center(2), Pk_star, 'LineWidth', 4)
    hold on
    viscircles([centers(:,1) centers(:,2)],repmat(cluster_sigma,[size(centers,1) 1]));
end
plot(data(:,1), data(:,2), '.', 'MarkerSize', 10)
hold on
stem3(new_center(1), new_center(2), Pk_star, 'LineWidth', 4)
hold on
viscircles([centers(:,1) centers(:,2)],repmat(cluster_sigma,[size(centers,1) 1]));
