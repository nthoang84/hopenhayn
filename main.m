[gridProd, transitionProd] = tauchen(101, 0.9, 0.2, 0.1, 4.0);

disp('Productivity grid:');
disp(gridProd(1:10));

disp('Productivity transition matrix:');
disp(transitionProd(1:10, 1:10));