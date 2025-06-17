% SET_PARAMS Sets and returns model parameters as a struct.
%
%   params = set_params()
%
%   Outputs:
%       params - Struct with model parameters

function params = set_params()
    params.discountFactor = 0.8;
    params.laborElasticity = 0.6;
    params.persistenceProd = 0.9;
    params.stdDevProd = 0.2;
    params.meanProd = 1;
    params.numGridPointsProd = 50;
    params.entryCost = 40;
    params.fixedCost = 20;
    params.demandValue = 50;
    params.wage = 1;
end