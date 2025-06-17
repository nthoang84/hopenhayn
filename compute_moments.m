% COMPUTE_MOMENTS Computes moments and distributions from model solution.
%
%   [pdfIndustry, pdfEmployment, avgFirmSize, aggOutput, aggProfit, exitRate, exitProductivityCutoff] = ...
%       compute_moments(params, gridProd, solution, massEntrants, industryState)
%
%   Inputs:
%       params        - Struct with model parameters
%       gridProd      - Productivity grid
%       solution      - Struct with optimal policies
%       massEntrants  - Mass of entrants
%       industryState - Stationary distribution of firms
%
%   Outputs:
%       pdfIndustry             - Stationary distribution of firms
%       pdfEmployment           - Employment-weighted distribution
%       avgFirmSize             - Average firm size
%       aggOutput               - Aggregate output
%       aggProfit               - Aggregate profit
%       exitRate                - Exit rate
%       exitProductivityCutoff  - Productivity cutoff for exit

function [pdfIndustry, pdfEmployment, avgFirmSize, aggOutput, aggProfit, exitRate, exitProductivityCutoff] = ...
    compute_moments(params, gridProd, solution, massEntrants, industryState)

    % Compute the stationary distribution of firms
    pdfIndustry = industryState / sum(industryState);

    % Compute the employment distribution
    distEmployment = industryState .* solution.optLabor;
    pdfEmployment = distEmployment / sum(distEmployment);

    % Compute the exit productivity cutoff
    exitIndex = find(solution.exitPolicy == 0, 1);
    exitProductivityCutoff = gridProd(exitIndex);

    % Compute average firm size, aggregate output, aggregate profit, and exit rate
    avgFirmSize = sum(distEmployment) / sum(industryState);
    exitRate = massEntrants / sum(industryState);
    aggOutput = sum((gridProd .* solution.optLabor .^ params.laborElasticity) .* industryState);
    aggProfit = sum(solution.optProfit .* industryState);
end