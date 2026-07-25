% ==========================================
% 1. DATA INITIALIZATION (ALL CONFIGURATIONS)
% ==========================================
configs = struct();

% ------------------------------------------
% Config 1: e420_s1223
% ------------------------------------------
configs(1).name = 'Eppler 420 Main & Selig 1223 Flap';
configs(1).Aoa = [15, 20, 25, 30, 35];
configs(1).aoacl = [3.1438, 3.4063, 3.6143, 3.7378, 3.7818];
configs(1).aoacd = [0.06357, 0.07246, 0.08229, 0.09467, 0.11083];

configs(1).Gap = [2.5, 5, 7.5, 10];
configs(1).gapcl = [3.4661, 3.6143, 3.6706, 3.6898];
configs(1).gapcd = [0.08277, 0.08229, 0.08179, 0.08105];

configs(1).Overlap = [-5, 0, 5, 10, 15];
configs(1).overlapcl = [3.5784, 3.6452, 3.6143, 3.5467, 3.4289];
configs(1).overlapcd = [0.07358, 0.07934, 0.08229, 0.08491, 0.08336];

configs(1).Chord = [20, 25, 30, 35, 40, 45, 50, 60, 70, 80, 90];
configs(1).chordcl = [2.569505185, 2.687781547, 2.780168752, 2.854387358, 2.902282159, 2.952882513, 2.989615407, 3.007088, 3.024151425, 3.023581235, 2.979658854];
configs(1).chordcd = [0.059771259, 0.061280711, 0.063295453, 0.065670848, 0.068030984, 0.070689349, 0.073198933, 0.078120889, 0.083256889, 0.088710321, 0.09417207];

% ------------------------------------------
% Config 2: e420_e423
% ------------------------------------------
configs(2).name = 'Eppler 420 Main & Eppler 423 Flap';
configs(2).Aoa = [25, 30, 35];
configs(2).aoacl = [3.5427, 3.6847, 3.7715];
configs(2).aoacd = [0.07938, 0.09055, 0.10445];

configs(2).Gap = [5, 7.5, 10];
configs(2).gapcl = [3.5427, 3.5967, 3.5966];
configs(2).gapcd = [0.07938, 0.07893, 0.07838];

configs(2).Overlap = [-5, 0, 5];
configs(2).overlapcl = [3.3736, 3.564, 3.5427];
configs(2).overlapcd = [0.07237, 0.0768, 0.07938];

configs(2).Chord = [50, 60, 70];
configs(2).chordcl = [2.92349535, 2.92891022, 2.93342201];
configs(2).chordcd = [0.06995437, 0.07456356, 0.07946708];

% ------------------------------------------
% Config 3: e423_s1223
% ------------------------------------------
configs(3).name = 'Eppler 423 Main & Selig 1223 Flap';
configs(3).Aoa = [25, 30, 35];
configs(3).aoacl = [3.6172, 3.6901, 3.5394];
configs(3).aoacd = [0.08688, 0.10219, 0.13205];

configs(3).Gap = [5, 7.5, 10];
configs(3).gapcl = [3.6172, 3.6917, 3.7161];
configs(3).gapcd = [0.08688, 0.08569, 0.08498];

configs(3).Overlap = [-5, 0, 5];
configs(3).overlapcl = [3.6254, 3.6675, 3.6172];
configs(3).overlapcd = [0.07832, 0.08303, 0.08688];

configs(3).Chord = [50, 60, 70];
configs(3).chordcl = [2.984063, 2.993458, 3.005478];
configs(3).chordcd = [0.077418, 0.08272, 0.088701];

% ------------------------------------------
% Config 4: e423_e423
% ------------------------------------------
configs(4).name = 'Eppler 423 Main & Eppler 423 Flap';
configs(4).Aoa = [25, 30, 35];
configs(4).aoacl = [3.553, 3.6575, 3.6646];
configs(4).aoacd = [0.083, 0.0962, 0.115];

configs(4).Gap = [5, 7.5, 10];
configs(4).gapcl = [3.553, 3.6263, 3.6321];
configs(4).gapcd = [0.083, 0.0823, 0.08179];

configs(4).Overlap = [-5, 0, 5];
configs(4).overlapcl = [3.4309, 3.5943, 3.553];
configs(4).overlapcd = [0.07428, 0.0798, 0.083];

configs(4).Chord = [50, 60, 70];
configs(4).chordcl = [2.929719, 2.928409, 2.930691];
configs(4).chordcd = [0.07365, 0.078638, 0.08405];

% ==========================================
% 2. LOOP THROUGH EACH CONFIG & PLOT
% ==========================================
dataColor = '#0072BD'; 
fitColor  = '#D95319'; 
maxColor  = '#EDB120'; % Yellow for the max points

for i = 1:length(configs)
    c = configs(i);
    
    % DYNAMIC POLYNOMIAL ORDER CALCULATION
    % Automatically sets to 3rd order if enough points exist, otherwise 2nd order.
    n_aoa   = min(3, length(c.Aoa) - 1);
    n_gap   = min(3, length(c.Gap) - 1);
    n_over  = min(3, length(c.Overlap) - 1);
    n_chord = min(3, length(c.Chord) - 1);

    % Compute Polynomial Fits
    p_aoacl = polyfit(c.Aoa, c.aoacl, n_aoa);
    p_aoacd = polyfit(c.Aoa, c.aoacd, n_aoa);
    
    p_gapcl = polyfit(c.Gap, c.gapcl, n_gap);
    p_gapcd = polyfit(c.Gap, c.gapcd, n_gap);
    
    p_overcl = polyfit(c.Overlap, c.overlapcl, n_over);
    p_overcd = polyfit(c.Overlap, c.overlapcd, n_over);
    
    p_chordcl = polyfit(c.Chord, c.chordcl, n_chord);
    p_chordcd = polyfit(c.Chord, c.chordcd, n_chord);

    % Find Maximum cl Points & Corresponding cd
    [opt_aoa, maxcl_aoa, optcd_aoa] = findMaxcl(c.Aoa, p_aoacl, p_aoacd);
    [opt_gap, maxcl_gap, optcd_gap] = findMaxcl(c.Gap, p_gapcl, p_gapcd);
    [opt_over, maxcl_over, optcd_over] = findMaxcl(c.Overlap, p_overcl, p_overcd);
    [opt_chord, maxcl_chord, optcd_chord] = findMaxcl(c.Chord, p_chordcl, p_chordcd);

    % Display the exact coordinates in the command window
    fprintf('\n--- %s OPTIMAL CONFIGURATIONS (MAX c_l) ---\n', upper(c.name));
    fprintf('AoA:     %6.2f deg | cl_max = %6.4f | Resulting cd = %6.4f (Order: %d)\n', opt_aoa, maxcl_aoa, optcd_aoa, n_aoa);
    fprintf('Gap:     %6.2f mm  | cl_max = %6.4f | Resulting cd = %6.4f (Order: %d)\n', opt_gap, maxcl_gap, optcd_gap, n_gap);
    fprintf('Overlap: %6.2f mm  | cl_max = %6.4f | Resulting cd = %6.4f (Order: %d)\n', opt_over, maxcl_over, optcd_over, n_over);
    fprintf('Chord:   %6.2f %%   | cl_max = %6.4f | Resulting cd = %6.4f (Order: %d)\n', opt_chord, maxcl_chord, optcd_chord, n_chord);
    
    % Generate Fit Lines for Plotting
    Aoa_fit = linspace(min(c.Aoa), max(c.Aoa), 100);
    Gap_fit = linspace(min(c.Gap), max(c.Gap), 100);
    Overlap_fit = linspace(min(c.Overlap), max(c.Overlap), 100);
    Chord_fit = linspace(min(c.Chord), max(c.Chord), 100);

    fit_aoacl = polyval(p_aoacl, Aoa_fit); fit_aoacd = polyval(p_aoacd, Aoa_fit);
    fit_gapcl = polyval(p_gapcl, Gap_fit); fit_gapcd = polyval(p_gapcd, Gap_fit);
    fit_overlapcl = polyval(p_overcl, Overlap_fit); fit_overlapcd = polyval(p_overcd, Overlap_fit);
    fit_chordcl = polyval(p_chordcl, Chord_fit); fit_chordcd = polyval(p_chordcd, Chord_fit);
    
    % Create Figure for this Config
    fig_title = sprintf('Config: %s', c.name);
    figure('Name', fig_title, 'Position', [50+(i*30), 50+(i*30), 1200, 600]);

    % --- c_l PLOTS (TOP ROW) ---
    ax1 = subplot(2,4,1); hold on; grid on;
    scatter(c.Aoa, c.aoacl, 40, 'filled', 'MarkerFaceColor', dataColor);
    plot(Aoa_fit, fit_aoacl, 'Color', fitColor, 'LineWidth', 2);
    plot(opt_aoa, maxcl_aoa, 'h', 'MarkerSize', 12, 'MarkerFaceColor', maxColor, 'MarkerEdgeColor', 'k');
    title('AoA vs c_l'); xlabel('AoA (deg)'); ylabel('c_l');

    ax2 = subplot(2,4,2); hold on; grid on;
    scatter(c.Gap, c.gapcl, 40, 'filled', 'MarkerFaceColor', dataColor);
    plot(Gap_fit, fit_gapcl, 'Color', fitColor, 'LineWidth', 2);
    plot(opt_gap, maxcl_gap, 'h', 'MarkerSize', 12, 'MarkerFaceColor', maxColor, 'MarkerEdgeColor', 'k');
    title('Gap vs c_l'); xlabel('Gap (mm)');

    ax3 = subplot(2,4,3); hold on; grid on;
    scatter(c.Overlap, c.overlapcl, 40, 'filled', 'MarkerFaceColor', dataColor);
    plot(Overlap_fit, fit_overlapcl, 'Color', fitColor, 'LineWidth', 2);
    plot(opt_over, maxcl_over, 'h', 'MarkerSize', 12, 'MarkerFaceColor', maxColor, 'MarkerEdgeColor', 'k');
    title('Overlap vs c_l'); xlabel('Overlap (mm)');

    ax4 = subplot(2,4,4); hold on; grid on;
    scatter(c.Chord, c.chordcl, 40, 'filled', 'MarkerFaceColor', dataColor);
    plot(Chord_fit, fit_chordcl, 'Color', fitColor, 'LineWidth', 2);
    plot(opt_chord, maxcl_chord, 'h', 'MarkerSize', 12, 'MarkerFaceColor', maxColor, 'MarkerEdgeColor', 'k');
    title('Chord vs c_l'); xlabel('Chord %');

    % --- c_d PLOTS (BOTTOM ROW) ---
    ax5 = subplot(2,4,5); hold on; grid on;
    scatter(c.Aoa, c.aoacd, 40, 'filled', 'MarkerFaceColor', dataColor);
    plot(Aoa_fit, fit_aoacd, 'Color', fitColor, 'LineWidth', 2);
    plot(opt_aoa, optcd_aoa, 'h', 'MarkerSize', 12, 'MarkerFaceColor', maxColor, 'MarkerEdgeColor', 'k');
    title('AoA vs c_d'); xlabel('AoA (deg)'); ylabel('c_d');

    ax6 = subplot(2,4,6); hold on; grid on;
    scatter(c.Gap, c.gapcd, 40, 'filled', 'MarkerFaceColor', dataColor);
    plot(Gap_fit, fit_gapcd, 'Color', fitColor, 'LineWidth', 2);
    plot(opt_gap, optcd_gap, 'h', 'MarkerSize', 12, 'MarkerFaceColor', maxColor, 'MarkerEdgeColor', 'k');
    title('Gap vs c_d'); xlabel('Gap (mm)');

    ax7 = subplot(2,4,7); hold on; grid on;
    scatter(c.Overlap, c.overlapcd, 40, 'filled', 'MarkerFaceColor', dataColor);
    plot(Overlap_fit, fit_overlapcd, 'Color', fitColor, 'LineWidth', 2);
    plot(opt_over, optcd_over, 'h', 'MarkerSize', 12, 'MarkerFaceColor', maxColor, 'MarkerEdgeColor', 'k');
    title('Overlap vs c_d'); xlabel('Overlap (mm)');

    ax8 = subplot(2,4,8); hold on; grid on;
    scatter(c.Chord, c.chordcd, 40, 'filled', 'MarkerFaceColor', dataColor);
    plot(Chord_fit, fit_chordcd, 'Color', fitColor, 'LineWidth', 2);
    plot(opt_chord, optcd_chord, 'h', 'MarkerSize', 12, 'MarkerFaceColor', maxColor, 'MarkerEdgeColor', 'k');
    title('Chord vs c_d'); xlabel('Chord %');

    % Master legend & Title
    sgtitle(sprintf('Configuration: %s', c.name), 'Interpreter', 'none', 'FontSize', 14);
    legend(ax1, {'Raw Data', 'Polynomial Fit', 'c_l Max Point'}, 'Location', 'best');
end

% ==========================================
% 3. HELPER FUNCTION
% ==========================================
function [x_opt, y_maxcl, y_cd] = findMaxcl(x_data, p_cl, p_cd)
    % 1. Find the roots of the derivative of the cl polynomial
    dp_cl = polyder(p_cl);
    r = roots(dp_cl);
    
    % 2. Keep only real roots that fall within our tested domain
    valid_roots = r(imag(r) == 0 & r >= min(x_data) & r <= max(x_data));
    
    % 3. Check roots AND boundaries (in case max is at the edge of the data)
    candidates = [min(x_data); max(x_data); valid_roots];
    
    % 4. Evaluate cl at all candidates and find the absolute highest value
    cl_vals = polyval(p_cl, candidates);
    [y_maxcl, max_idx] = max(cl_vals);
    
    % 5. Get the optimal X value and calculate the resulting cd
    x_opt = candidates(max_idx);
    y_cd = polyval(p_cd, x_opt);
end

% ==========================================
% 4. OPTIMIZED CONFIGURATIONS: REYNOLDS NUMBER SWEEP
% ==========================================
% Fluid properties and dimensions
L_c = 0.4;          % Characteristic length (m)
rho = 1.125;        % Density (kg/m^3)
mu  = 1.845e-5;     % Dynamic viscosity (kg/(m*s))

% Velocities tested
Velocities = [30, 50, 75]; % m/s

% Calculate Reynolds Numbers
Re = (rho .* Velocities .* L_c) ./ mu;

% --- Extract Data (Equiv cl, Equiv cd, and Raw Forces) ---
% 1: e420_s1223 Optimized
cl_opt1    = [3.2599, 3.37696, 3.44716];
cd_opt1    = [0.11366, 0.10334, 0.097367];
mLift_opt1 = [553.293, 1589.895, 3648.075];
fLift_opt1 = [106.837, 309.616, 714.732];
mDrag_opt1 = [-49.618, -151.028, -358.327];
fDrag_opt1 = [72.634, 209.155, 481.557];

% 2: e420_e423 Optimized
cl_opt2    = [3.1812, 3.295, 3.3605];
cd_opt2    = [0.11001, 0.1003, 0.09449];
mLift_opt2 = [543.405, 1561.047, 3576.978];
fLift_opt2 = [100.78, 293.022, 676.181];
mDrag_opt2 = [-46.877, -143.063, -339.259];
fDrag_opt2 = [69.154, 199.503, 458.852];

% 3: e423_s1223 Optimized
cl_opt3    = [3.1467, 3.2435, 3.3021];
cd_opt3    = [0.10342, 0.09406, 0.08862];
mLift_opt3 = [528.78, 1512.447, 3461.845];
fLift_opt3 = [108.425, 312.003, 717.368];
mDrag_opt3 = [-43.364, -132.069, -313.527];
fDrag_opt3 = [64.306, 184.976, 425.684];

% 4: e423_e423 Optimized
cl_opt4    = [3.1064, 3.2295, 3.3009];
cd_opt4    = [0.11212, 0.10118, 0.09507];
mLift_opt4 = [529.204, 1525.649, 3504.472];
fLift_opt4 = [99.829, 290.892, 673.169];
mDrag_opt4 = [-43.492, -134.567, -321.511];
fDrag_opt4 = [66.196, 191.482, 441.83];

% Group them for easy plotting iteration
opt_names = ["e420_s1223 Optimized", "e420_e423 Optimized", "e423_s1223 Optimized", "e423_e423 Optimized"];
cl_all_opt    = [cl_opt1; cl_opt2; cl_opt3; cl_opt4];
cd_all_opt    = [cd_opt1; cd_opt2; cd_opt3; cd_opt4];
mLift_all_opt = [mLift_opt1; mLift_opt2; mLift_opt3; mLift_opt4];
fLift_all_opt = [fLift_opt1; fLift_opt2; fLift_opt3; fLift_opt4];
mDrag_all_opt = [mDrag_opt1; mDrag_opt2; mDrag_opt3; mDrag_opt4];
fDrag_all_opt = [fDrag_opt1; fDrag_opt2; fDrag_opt3; fDrag_opt4];

% Generate 4 distinct colors using built-in colormap
colors_opt = lines(4); 

% --- Plotting the Reynolds Sweep ---
% Made the figure wider to accommodate a 2x3 grid
fig_opt = figure('Name', 'Optimized Reynolds Number Sweep', 'Position', [100, 100, 1400, 700]);

% Plot 1: Re vs c_l
ax1 = subplot(2, 3, 1); hold on; grid on;
for i = 1:4
    plot(Re, cl_all_opt(i,:), '-o', 'LineWidth', 2, 'MarkerSize', 6, ...
        'MarkerFaceColor', colors_opt(i,:), 'Color', colors_opt(i,:), 'DisplayName', opt_names(i));
end
title('Reynolds No. vs c_l'); xlabel('Re'); ylabel('c_l');
legend('Interpreter', 'none', 'Location', 'best');

% Plot 2: Re vs Main Lift
ax2 = subplot(2, 3, 2); hold on; grid on;
for i = 1:4
    plot(Re, mLift_all_opt(i,:), '-o', 'LineWidth', 2, 'MarkerSize', 6, ...
        'MarkerFaceColor', colors_opt(i,:), 'Color', colors_opt(i,:));
end
title('Reynolds No. vs Main Lift'); xlabel('Re'); ylabel('Lift (N)');

% Plot 3: Re vs Flap Lift
ax3 = subplot(2, 3, 3); hold on; grid on;
for i = 1:4
    plot(Re, fLift_all_opt(i,:), '-o', 'LineWidth', 2, 'MarkerSize', 6, ...
        'MarkerFaceColor', colors_opt(i,:), 'Color', colors_opt(i,:));
end
title('Reynolds No. vs Flap Lift'); xlabel('Re'); ylabel('Lift (N)');

% Plot 4: Re vs c_d
ax4 = subplot(2, 3, 4); hold on; grid on;
for i = 1:4
    plot(Re, cd_all_opt(i,:), '-o', 'LineWidth', 2, 'MarkerSize', 6, ...
        'MarkerFaceColor', colors_opt(i,:), 'Color', colors_opt(i,:));
end
title('Reynolds No. vs c_d'); xlabel('Re'); ylabel('c_d');

% Plot 5: Re vs Main Drag
ax5 = subplot(2, 3, 5); hold on; grid on;
for i = 1:4
    plot(Re, mDrag_all_opt(i,:), '-o', 'LineWidth', 2, 'MarkerSize', 6, ...
        'MarkerFaceColor', colors_opt(i,:), 'Color', colors_opt(i,:));
end
title('Reynolds No. vs Main Drag'); xlabel('Re'); ylabel('Drag (N)');

% Plot 6: Re vs Flap Drag
ax6 = subplot(2, 3, 6); hold on; grid on;
for i = 1:4
    plot(Re, fDrag_all_opt(i,:), '-o', 'LineWidth', 2, 'MarkerSize', 6, ...
        'MarkerFaceColor', colors_opt(i,:), 'Color', colors_opt(i,:));
end
title('Reynolds No. vs Flap Drag'); xlabel('Re'); ylabel('Drag (N)');

% Add a master title to the entire figure
sgtitle('Reynolds Sweep: Full Aero Metrics vs Reynolds Number', 'FontSize', 14);