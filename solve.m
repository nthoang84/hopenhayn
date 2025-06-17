% SOLVE Solves the model of firm dynamics and computes equilibrium and moments.
%
%   solve(params, modelName)
%
%   Inputs:
%       params    - Struct containing model parameters
%       modelName - String, name for output files and plots
%
%   This function solves a simplified Hopenhayn (1992, ECTA) model, computes the 
%   stationary distribution, optimal policies, and key moments, and saves results to file.

function solve(params, modelName)
    % Start solving the model
    disp(['Solving model: ', modelName]);

    % Discretize productivity process using Tauchen method
    [gridProd, transitionProd] = tauchen( ...
        params.numGridPointsProd, ...
        params.persistenceProd, ...
        params.stdDevProd, ...
        params.meanProd * (1 - params.persistenceProd), ...
        4.0 ...
    );

    % Compute the stationary distribution of productivity
    invDistProd = transitionProd^1000;
    invDistProd = invDistProd(1, :)';
    
    % Compute optimal policy functions
    [price, v, exitPolicy, optLabor, optProfit] = solve_eqm_price(params, gridProd, transitionProd, invDistProd);

    solution = struct( ...
        'price', price, ...
        'v', v, ...
        'exitPolicy', exitPolicy, ...
        'optLabor', optLabor, ...
        'optProfit', optProfit ...
    );

    % Compute the mass of entrants and ditribution of firms
    [massEntrants, industryState] = solve_eqm_entrance(params, gridProd, transitionProd, invDistProd, solution);

    if massEntrants <= 0
        error('No entrants in equilibrium. Adjust parameters or check the model.');
    end

    % Compute some moments of the model
    [pdfIndustry, pdfEmployment, avgFirmSize, aggOutput, aggProfit, exitRate, exitProductivityCutoff] = ...
        compute_moments(params, gridProd, solution, massEntrants, industryState);

    % Save the solution and moments to a text file
    outputFile = fullfile('outputs', [modelName, '.txt']);
    fileStream = fopen(outputFile, 'w');
    fprintf(fileStream, 'Equilibrium Price: %.2f\n', solution.price);
    fprintf(fileStream, 'Average Firm Size: %.2f\n', avgFirmSize);
    fprintf(fileStream, 'Aggregate Output: %.2f\n', aggOutput);
    fprintf(fileStream, 'Aggregate Profit: %.2f\n', aggProfit);
    fprintf(fileStream, 'Exit Rate: %.2f\n', exitRate);
    fprintf(fileStream, 'Exit Productivity Cutoff: %.2f\n', exitProductivityCutoff);
    fprintf(fileStream, 'Mass of Entrants: %.2f\n', massEntrants);
    fclose(fileStream);

    % Plot the stationary distribution of firm sizes and employment
    plot(solution.optLabor, pdfIndustry, 'LineWidth', 2);
    hold on;
    plot(solution.optLabor, pdfEmployment, 'LineWidth', 2);
    hold off;
    legend('Firm share', 'Employment share');
    xlabel('Size');
    ylabel('Density');
    title('Stationary Distribution');
    print(fullfile('outputs', modelName), '-dsvg');

    % Finish solving the model
    disp(['Model ', modelName, ' solved successfully.']);
    disp(' ');
end