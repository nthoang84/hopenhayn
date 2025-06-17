% SOLVE_EQM_PRICE Finds the equilibrium price that clears entry.
%
%   [price, v, exitPolicy, optLabor, optProfit] = solve_eqm_price(params, gridProd, transitionProd, invDistProd)
%
%   Inputs:
%       params        - Struct with model parameters
%       gridProd      - Productivity grid
%       transitionProd- Productivity transition matrix
%       invDistProd   - Invariant distribution of productivity
%
%   Outputs:
%       price      - Equilibrium price
%       v          - Value function
%       exitPolicy - Exit policy
%       optLabor   - Optimal labor
%       optProfit  - Optimal profit

function [price, v, exitPolicy, optLabor, optProfit] = solve_eqm_price(params, gridProd, transitionProd, invDistProd)
    function excessEntry = compute_excess_entry(price)
        v = solve_policy(params, gridProd, transitionProd, price, false);
        excessEntry = params.discountFactor * sum(invDistProd .* v) - params.entryCost * params.wage;
    end
    price = fzero(@compute_excess_entry, 5.0);
    [v, exitPolicy, optLabor, optProfit] = solve_policy(params, gridProd, transitionProd, price, false);
end