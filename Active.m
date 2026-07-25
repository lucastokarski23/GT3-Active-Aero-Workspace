%% ==========================================================
% Iterative_Drag_Optimization.m
%
% Appends new CFD validation points
% Fits a 3rd-order polynomial to the attached flow region
% Calculates convergence error against the best CFD point
%% ==========================================================
clc;
clear;
close all;

%% ==========================================================
% 1. Input Data (Add your new CFD runs here)
%% ==========================================================
% Original dataset + newly validated point at 2.005 deg
flapAOA_raw = [-7.087; -5; 0; 2.005; 5; 10; 15; 20; 25; 30; 35; 35.218; 40; 45; 50; 55];
Cd_raw      = [0.053817; 0.050542; 0.044574; 0.043876; 0.044783; 0.051019; 0.059266; ...
               0.068876; 0.079087; 0.090977; 0.10377; 0.10432; 0.11818; ...
               0.29505; 0.3499; 0.39528];

%% ==========================================================
% 2. Filter & Sort Data
%% ==========================================================
% Exclude massive separation/stall points
valid_idx = flapAOA_raw <= 40; 
flapAOA = flapAOA_raw(valid_idx);
Cd = Cd_raw(valid_idx);

% Sort arrays in ascending order of AOA for clean plotting
[flapAOA, sortIdx] = sort(flapAOA);
Cd = Cd(sortIdx);

%% ==========================================================
% 3. 3rd-Order Polynomial Fit
%% ==========================================================
p = polyfit(flapAOA, Cd, 3);

%% ==========================================================
% 4. Find the Minimum Mathematically
%% ==========================================================
dp = polyder(p);
critical_points = roots(dp);

real_roots = critical_points(imag(critical_points) == 0);
valid_roots = real_roots(real_roots >= min(flapAOA) & real_roots <= max(flapAOA));

d2p = polyder(dp);
opt_AOA = [];
for i = 1:length(valid_roots)
    if polyval(d2p, valid_roots(i)) > 0
        opt_AOA = valid_roots(i);
        break;
    end
end

% Calculate newly predicted minimum Cd
opt_Cd = polyval(p, opt_AOA);

%% ==========================================================
% 5. Convergence Check
%% ==========================================================
% Find the lowest drag value actually achieved in CFD so far
[best_CFD_Cd, min_idx] = min(Cd);
best_CFD_AOA = flapAOA(min_idx);

% Calculate % change between model prediction and best CFD result
percent_change = abs((opt_Cd - best_CFD_Cd) / best_CFD_Cd) * 100;

%% ==========================================================
% 6. Print Results
%% ==========================================================
fprintf('=======================================\n');
fprintf('Iterative Drag Optimization\n');
fprintf('=======================================\n');
fprintf('Best CFD Point   : %.3f deg (c_d = %.5f)\n', best_CFD_AOA, best_CFD_Cd);
fprintf('New Predicted Min: %.3f deg (c_d = %.5f)\n', opt_AOA, opt_Cd);
fprintf('---------------------------------------\n');
fprintf('Convergence Error: %.2f%%\n', percent_change);

if percent_change < 1.0
    fprintf('>>> SUCCESS: Convergence reached (< 1%%) <<<\n');
else
    fprintf('>>> ACTION: Run CFD at %.3f deg <<<\n', opt_AOA);
end
fprintf('=======================================\n');

%% ==========================================================
% 7. Plotting (Professional Academic Format)
%% ==========================================================
AOA_fit = linspace(min(flapAOA), max(flapAOA), 200);
Cd_fit = polyval(p, AOA_fit);

% Force a white background for report export
figure('Name', 'Drag Bucket Refinement', 'Color', 'w', 'Position', [100, 100, 800, 600]);
hold on; grid on; box on;

% Plot the 3rd Order Fit first so it sits behind the data points
% Changed 'w--' to 'k--' (black dashed line) for light mode visibility
plot(AOA_fit, Cd_fit, 'k--', 'LineWidth', 1.5, 'DisplayName', '3rd-Order Fit');

% Scatter CFD Data
scatter(flapAOA, Cd, 70, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', '#0072BD', ...
    'DisplayName', 'CFD Data');

% Highlight Best Actual CFD Run
scatter(best_CFD_AOA, best_CFD_Cd, 120, 'r', 'o', 'LineWidth', 2, ...
    'DisplayName', 'Best Actual CFD');

% New Prediction Point
scatter(opt_AOA, opt_Cd, 140, 'p', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', '#EDB120', ...
    'DisplayName', 'Predicted Minimum');

% Labels and Title (Using TeX/LaTeX interpreter for professional formatting)
xlabel('Flap Angle of Attack, \alpha (deg)', 'FontWeight', 'bold', 'FontSize', 13);
ylabel('Sectional Drag Coefficient, c_d', 'FontWeight', 'bold', 'FontSize', 13);
title('Flap \alpha vs. Sectional Drag Coefficient', 'FontWeight', 'bold', 'FontSize', 14);

% Legend
legend('Location', 'northwest', 'FontSize', 11);