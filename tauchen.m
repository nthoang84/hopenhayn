function [grid, transition] = tauchen(gridSize, rho, sigma, mu, m)
    % Discretize a continuous AR(1) process using Tauchen's method
    %
    % Inputs:
    %   gridSize - number of grid points
    %   rho - persistence parameter of the AR(1) process
    %   sigma - standard deviation of the shock
    %   mu - mean of the process
    %   m - number of standard deviations to cover
    %
    % Outputs:
    %   grid - vector of grid points
    %   transition - transition matrix

    % Compute grid points
    gridMin = mu / (1 - rho) - m * sqrt(sigma^2 / (1 - rho^2));
    gridMax = mu / (1 - rho) + m * sqrt(sigma^2 / (1 - rho^2));
    step = (gridMax - gridMin) / (gridSize - 1);
    grid = linspace(gridMin, gridMax, gridSize)';

    % Compute transition matrix
    transition = zeros(gridSize, gridSize);
    for i = 1:ceil(gridSize / 2)
        transition(i, 1) = normcdf((grid(1) - mu - rho * grid(i) + step / 2) / sigma);
        transition(i, gridSize) = 1 - normcdf((grid(end) - mu - rho * grid(i) - step / 2) / sigma);
        for j = 2:gridSize - 1
            transition(i, j) = normcdf((grid(j) - mu - rho * grid(i) + step / 2) / sigma) - ...
                               normcdf((grid(j) - mu - rho * grid(i) - step / 2) / sigma);
        end
        transition(floor((gridSize - 1) / 2 + 2):end, :) = transition(ceil((gridSize - 1) / 2):-1:1, end:-1:1);
    end
    transition = transition ./ sum(transition, 2);

    % Ensure the grid is in log space
    grid = exp(grid);
end