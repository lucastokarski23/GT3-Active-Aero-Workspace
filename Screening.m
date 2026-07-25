% ==========================================
% DATA INITIALIZATION
% ==========================================
% 20 Degree Data
cl20 = [3.4917, 3.4403, 3.1018, 3.4063, 3.3339, 2.9617, 3.4381, 3.0956, 3.0057, 3.2479, 3.2019, 2.6929, 3.3043, 3.2661, 2.9881];
cd20 = [0.08863, 0.08415, 0.07584, 0.07246, 0.06966, 0.061956, 0.075489, 0.07495, 0.06481, 0.09503, 0.08922, 0.0774, 0.1061, 0.09943, 0.0863];

% 25 Degree Data
cl25 = [3.5794, 3.543, 3.1965, 3.6143, 3.5427, 3.193, 3.6172, 3.553, 3.2001, 3.2646, 3.2603, 2.9794, 3.2932, 3.2977, 3.0479];
cd25 = [0.10478, 0.09837, 0.09187, 0.08229, 0.07938, 0.07143, 0.0869, 0.083, 0.07576, 0.11684, 0.10725, 0.09583, 0.13012, 0.11961, 0.10586];

% 30 Degree Data
cl30 = [3.4856, 3.5303, 3.1552, 3.7378, 3.6846, 3.3599, 3.6901, 3.6575, 3.2929, 2.9541, 3.11, 2.8473, 3.0708, 3.1712, 2.9799];
cd30 = [0.13068, 0.11802, 0.11609, 0.09467, 0.09055, 0.08358, 0.10219, 0.09624, 0.09214, 0.1688, 0.14084, 0.13053, 0.17419, 0.15186, 0.13533];

% Efficiency Calculations (cl / cd)
clcd20 = cl20 ./ cd20;
clcd25 = cl25 ./ cd25;
clcd30 = cl30 ./ cd30;

% Generate combinations using proper academic naming conventions
mainplanes = ["Selig 1223", "Eppler 420", "Eppler 423", "Eppler 397", "NACA 4412"];
flaps = ["Selig 1223"; "Eppler 423"; "NACA 2412"];
combos = mainplanes' + " / " + flaps'; % Creates a 5x3 matrix

% Transpose before flattening so it reads across the rows (M1F1, M1F2, M1F3...)
combos_transposed = combos';
labels = combos_transposed(:)'; 

% Generate 15 distinct colors (turbo works well, but lines/parula are also standard)
colors = turbo(15); 

%% ==========================================
% FIGURE 1: SCATTERPLOT WITH ALL LABELS
% ==========================================
figure('Name', 'Aerodynamic Performance Scatter', 'Color', 'w', 'Position', [100, 100, 900, 600]);
hold on; grid on; box on;

% Plot each dataset
scatter(cd20, cl20, 50, 'filled', 'MarkerFaceColor', '#0072BD', 'MarkerEdgeColor', 'k', 'DisplayName', 'Flap \alpha = 20^\circ');
scatter(cd25, cl25, 50, 'filled', 'MarkerFaceColor', '#D95319', 'MarkerEdgeColor', 'k', 'DisplayName', 'Flap \alpha = 25^\circ');
scatter(cd30, cl30, 50, 'filled', 'MarkerFaceColor', '#EDB120', 'MarkerEdgeColor', 'k', 'DisplayName', 'Flap \alpha = 30^\circ');

% Attach the combination names to ALL points
for i = 1:length(labels)
    text(cd20(i), cl20(i), "  " + labels(i), 'FontSize', 9, 'FontName', 'Times New Roman', 'Color', '#0072BD');
    text(cd25(i), cl25(i), "  " + labels(i), 'FontSize', 9, 'FontName', 'Times New Roman', 'Color', '#D95319');
    text(cd30(i), cl30(i), "  " + labels(i), 'FontSize', 9, 'FontName', 'Times New Roman', 'Color', '#EDB120');
end

% Format Figure 1
xlabel('Sectional Drag Coefficient, c_d', 'FontWeight', 'bold', 'FontSize', 13);
ylabel('Sectional Lift Coefficient, c_l', 'FontWeight', 'bold', 'FontSize', 13);
title('Aerodynamic Performance by Flap Angle of Attack', 'FontWeight', 'bold', 'FontSize', 14);
legend('Location', 'southeast', 'FontSize', 11);
hold off;

%% ==========================================
% FIGURE 2: LIGHT MODE DRAG POLAR TRENDS
% ==========================================
figure('Name', 'Drag Polar Trends', 'Color', 'w', 'Position', [150, 150, 900, 600]);
hold on; grid on; box on;

% Loop through each combination and plot its trend line
for i = 1:length(labels)
    x_data = [cd20(i), cd25(i), cd30(i)];
    y_data = [cl20(i), cl25(i), cl30(i)];
    
    plot(x_data, y_data, '-o', ...
        'LineWidth', 1.5, ...
        'MarkerSize', 7, ...
        'MarkerFaceColor', colors(i,:), ...
        'MarkerEdgeColor', 'k', ...
        'Color', colors(i,:), ...
        'DisplayName', labels(i));
end

% Format Figure 2
xlabel('Sectional Drag Coefficient, c_d', 'FontWeight', 'bold', 'FontSize', 13);
ylabel('Sectional Lift Coefficient, c_l', 'FontWeight', 'bold', 'FontSize', 13);
title('Aerodynamic Trends (Flap \alpha: 20^\circ \rightarrow 25^\circ \rightarrow 30^\circ)', 'FontWeight', 'bold', 'FontSize', 14);

% Configure legend
lgd2 = legend('Location', 'eastoutside', 'FontSize', 11);
hold off;

%% ==========================================
% FIGURE 3: LIGHT MODE EFFICIENCY VS ANGLE
% ==========================================
figure('Name', 'Efficiency vs Angle', 'Color', 'w', 'Position', [200, 200, 900, 600]);
hold on; grid on; box on;

angles = [20, 25, 30];

% Loop through each combination and plot efficiency trend
for i = 1:length(labels)
    y_data_eff = [clcd20(i), clcd25(i), clcd30(i)];
    
    plot(angles, y_data_eff, '-o', ...
        'LineWidth', 1.5, ...
        'MarkerSize', 7, ...
        'MarkerFaceColor', colors(i,:), ...
        'MarkerEdgeColor', 'k', ...
        'Color', colors(i,:), ...
        'DisplayName', labels(i));
end

% Format Figure 3
xticks(angles); % Force X-axis to only show the tested angles
xlabel('Flap Angle of Attack, \alpha (deg)', 'FontWeight', 'bold', 'FontSize', 13);
ylabel('Aerodynamic Efficiency, c_l / c_d', 'FontWeight', 'bold', 'FontSize', 13);
title('Aerodynamic Efficiency vs. Flap Angle of Attack', 'FontWeight', 'bold', 'FontSize', 14);

% Configure legend
lgd3 = legend('Location', 'eastoutside', 'FontSize', 11);
hold off;