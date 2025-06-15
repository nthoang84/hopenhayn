function [v, exitPolicy] = solve_policy(params, priceGuess)
    N = params.numGridPointsProd;
    v = zeros(N, 1);
    exitPolicy = zeros(N, 1);
end