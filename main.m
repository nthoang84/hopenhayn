% MAIN Script to run the baseline and counterfactual model solutions.
%
%   This script sets parameters and solves the model for different
%   parameterizations, saving results and plots for each case.

clc;
clear;
close all;

% Run the baseline model
params = set_params();
solve(params, 'baseline');

% Run counterfactuals with higher entry cost
params = set_params();
params.entryCost = 60;
solve(params, 'higher_entry_cost');

% Run counterfactuals with higher fixed cost
params = set_params();
params.fixedCost = 30;
solve(params, 'higher_fixed_cost');