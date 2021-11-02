function data  = generate_dataset()

    rng('default')

    mu1 = [2 3];
    mu2 = [8 1];
    mu3 = [-4 1];
    mu4 = [1 9];
    mu5 = [5 5];

    sigma = [2 1; 1 1.5];

    R1 = mvnrnd(mu1, sigma, 50);
    R2 = mvnrnd(mu2, sigma, 50);
    R3 = mvnrnd(mu3, sigma, 50);
    R4 = mvnrnd(mu4, sigma, 50);
    R5 = mvnrnd(mu5, sigma, 50);
    
    %Plot clusters
    figure
    plot(R1(:,1), R1(:,2), '.', 'MarkerFaceColor', 'b', 'MarkerSize', 20)
    hold on
    plot(R2(:,1), R2(:,2), '.', 'MarkerFaceColor', 'r', 'MarkerSize', 20)
    plot(R3(:,1), R3(:,2), '.', 'MarkerFaceColor', 'g', 'MarkerSize', 20)
    plot(R4(:,1), R4(:,2), '.', 'MarkerFaceColor', 'k', 'MarkerSize', 20)
    plot(R5(:,1), R5(:,2), '.', 'MarkerFaceColor', 'm', 'MarkerSize', 20)
    grid on
    
    data = [R1; R2; R3; R4; R5];

end