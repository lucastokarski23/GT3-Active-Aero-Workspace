%% ==========================================================
% Reynolds_Number_Trends.m
%
% Calculates Reynolds number from velocity sweeps
% Plots Cl, Cd, and L/D vs Reynolds Number for three wing states
%% ==========================================================
clc;
clear;
close all;

%% ==========================================================
% 1. Constants
%% ==========================================================
rho = 1.125;      % Air density [kg/m^3]
mu  = 1.845e-5;   % Dynamic viscosity [Pa*s]
L   = 0.4;        % Reference length [m]

%% ==========================================================
% 2. Velocity & Reynolds Number Calculation
%% ==========================================================
V = [30, 40, 50, 60, 70, 80]; % Velocity [m/s]
Re = (rho .* V .* L) ./ mu;   % Calculate Reynolds Number

%% ==========================================================
% 3. Aerodynamic Data
%% ==========================================================
% DRS State
Cl_DRS = [1.607, 1.6217, 1.6324, 1.6408, 1.6477, 1.6533];
Cd_DRS = [0.048025, 0.045552, 0.043873, 0.042641, 0.041696, 0.040945];

% Downforce State
Cl_DF = [3.2664, 3.3344, 3.3831, 3.4185, 3.4452, 3.4663];
Cd_DF = [0.114984, 0.108629, 0.104402, 0.10134, 0.099036, 0.097209];

% Aerobrake State
Cl_AB = [1.6553, 1.6593, 1.6847, 1.706, 1.712, 1.7555];
Cd_AB = [0.42073, 0.40457, 0.39536, 0.39024, 0.38, 0.37771];

%% ==========================================================
% 4. Efficiency (L/D) Calculation
%% ==========================================================
LD_DRS = Cl_DRS ./ Cd_DRS;
LD_DF  = Cl_DF ./ Cd_DF;
LD_AB  = Cl_AB ./ Cd_AB;

%% ==========================================================
% 5. Plotting
%% ==========================================================
% Create a wider figure for three side-by-side plots
figure('Name', 'Aero Coefficients vs. Reynolds Number', 'Position', [100, 100, 1400, 450]);

% -----------------------------------------------------------
% Subplot 1: Cl vs Reynolds Number
% -----------------------------------------------------------
subplot(1,3,1);
plot(Re, Cl_DRS, '-o', 'LineWidth', 2, 'MarkerSize', 6, 'DisplayName', 'DRS');
hold on;
plot(Re, Cl_DF, '-s', 'LineWidth', 2, 'MarkerSize', 6, 'DisplayName', 'Downforce');
plot(Re, Cl_AB, '-^', 'LineWidth', 2, 'MarkerSize', 6, 'DisplayName', 'Aerobrake');
grid on;

xlabel('Reynolds Number (Re)', 'FontWeight', 'bold');
ylabel('Sectional Lift Coefficient, c_l', 'FontWeight', 'bold');
title('c_l vs. Reynolds Number', 'FontWeight', 'bold');
legend('Location', 'best');

% -----------------------------------------------------------
% Subplot 2: Cd vs Reynolds Number
% -----------------------------------------------------------
subplot(1,3,2);
plot(Re, Cd_DRS, '-o', 'LineWidth', 2, 'MarkerSize', 6, 'DisplayName', 'DRS');
hold on;
plot(Re, Cd_DF, '-s', 'LineWidth', 2, 'MarkerSize', 6, 'DisplayName', 'Downforce');
plot(Re, Cd_AB, '-^', 'LineWidth', 2, 'MarkerSize', 6, 'DisplayName', 'Aerobrake');
grid on;

xlabel('Reynolds Number (Re)', 'FontWeight', 'bold');
ylabel('Sectional Drag Coefficient, c_d', 'FontWeight', 'bold');
title('c_d vs. Reynolds Number', 'FontWeight', 'bold');
legend('Location', 'best');

% -----------------------------------------------------------
% Subplot 3: L/D vs Reynolds Number
% -----------------------------------------------------------
subplot(1,3,3);
plot(Re, LD_DRS, '-o', 'LineWidth', 2, 'MarkerSize', 6, 'DisplayName', 'DRS');
hold on;
plot(Re, LD_DF, '-s', 'LineWidth', 2, 'MarkerSize', 6, 'DisplayName', 'Downforce');
plot(Re, LD_AB, '-^', 'LineWidth', 2, 'MarkerSize', 6, 'DisplayName', 'Aerobrake');
grid on;

xlabel('Reynolds Number (Re)', 'FontWeight', 'bold');
ylabel('Lift-to-Drag Ratio (L/D)', 'FontWeight', 'bold');
title('L/D vs. Reynolds Number', 'FontWeight', 'bold');
legend('Location', 'best');