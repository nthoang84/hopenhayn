% TAUCHEN Discretizes a continuous AR(1) process using Tauchen's method.
%
%   [grid, transition] = tauchen(gridSize, rho, sigma, mu, m)
%
%   Inputs:
%       gridSize - Number of grid points
%       rho      - Persistence parameter of the AR(1) process
%       sigma    - Standard deviation of the shock
%       mu       - Mean of the process
%       m        - Number of standard deviations to cover
%
%   Outputs:
%       grid       - Vector of grid points (in levels, not logs)
%       transition - Transition probability matrix
%
%   This function constructs a Markov chain approximation to the AR(1)
%   process using Tauchen's method. The resulting grid is exponentiated
%   to return levels rather than logs.

function [grid, transition] = tauchen(gridSize, rho, sigma, mu, m)
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