% SOLVE_EQM_ENTRANCE Computes mass of entrants and industry state.
%
%   [massEntrants, industryState] = solve_eqm_entrance(params, gridProd, transitionProd, invDistProd, solution)
%
%   Inputs:
%       params        - Struct with model parameters
%       gridProd      - Productivity grid
%       transitionProd- Productivity transition matrix
%       invDistProd   - Invariant distribution of productivity
%       solution      - Struct with optimal policies
%
%   Outputs:
%       massEntrants  - Mass of entrants in equilibrium
%       industryState - Stationary distribution of firms

function [massEntrants, industryState] = solve_eqm_entrance(params, gridProd, transitionProd, invDistProd, solution)

    % Compute industry dynamics given optimal exit policy and productivity transition
    transitionEntry = ((1 - solution.exitPolicy) .* transitionProd)';
    
    % Given the mass of entrants, compute the stationary distribution of firms
    inv_dist = @(massEntrants) massEntrants * inv(eye(length(transitionEntry)) - transitionEntry) * invDistProd;
    
    % Using market clearing, compute the mass of entrants
    output = gridProd .* (solution.optLabor .^ params.laborElasticity);
    supply = sum(inv_dist(1) .* output);
    demand = params.demandValue / solution.price;
    massEntrants = demand / supply;

    % Compute state of the industry
    industryState = inv_dist(massEntrants);
end