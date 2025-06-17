% SOLVE_POLICY Solves the firm's dynamic programming problem.
%
%   [v, exitPolicy, optLabor, optProfit] = solve_policy(params, gridProd, transitionProd, price, verbose)
%
%   Inputs:
%       params         - Struct with model parameters
%       gridProd       - Productivity grid (vector)
%       transitionProd - Productivity transition matrix
%       price          - Output price
%       verbose        - (Optional) Print convergence info (default: true)
%
%   Outputs:
%       v          - Value function
%       exitPolicy - Exit policy (1 if exit, 0 otherwise)
%       optLabor   - Optimal labor for each state
%       optProfit  - Optimal profit for each state

function [v, exitPolicy, optLabor, optProfit] = solve_policy(params, gridProd, transitionProd, price, verbose)
    % Check input arguments
    if nargin < 5
        verbose = true;
    end

    numGridPointsProd = params.numGridPointsProd;
    discountFactor    = params.discountFactor;
    fixedCost         = params.fixedCost;
    wage              = params.wage;
    laborElas         = params.laborElasticity;

    % Compute optimal labor and profit for each state
    optLabor  = (laborElas * price .* gridProd / wage).^(1 / (1 - laborElas));
    optProfit = price * gridProd .* (optLabor .^ laborElas) - wage .* optLabor - wage * fixedCost;

    % Value function iteration (nested function)
    function [v, exitPolicy] = value_function_iteration(v, tol, maxIter)
        for iter = 1:maxIter
            currV = v;
            v = optProfit + discountFactor * max(0, transitionProd * currV);
            crit = max(abs(v - currV));
            if crit < tol * max(abs(v))
                if verbose
                    fprintf('Converged after %d iterations with crit = %f\n', iter, crit);
                end
                break;
            end
            if iter == maxIter
                if verbose
                    fprintf('Did not converge after %d iterations, crit = %f\n', iter, crit);
                end
            end
        end
        exitPolicy = zeros(numGridPointsProd, 1);
        exitPolicy(transitionProd * v < 0) = 1;
    end

    % Run value function iteration
    [v, exitPolicy] = value_function_iteration(optProfit, 1e-9, 500);
end