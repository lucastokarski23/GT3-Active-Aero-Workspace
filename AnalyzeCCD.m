%% ==========================================================
% Analyze_CCD.m
%
% Loads completed DOE
% Fits quadratic response surfaces
% Maximizes Cl
%
% Lucas Tokarski
%% ==========================================================

clc
clear
close all

%% ==========================================================
% Load Data
%% ==========================================================

DOE = readtable('CCD_GT3_Wing_DOE.xlsx');

DOE = rmmissing(DOE);

fprintf('Completed CFD Runs: %d\n\n',height(DOE));

%% ==========================================================
% Variables
%% ==========================================================

X = DOE{:,{'MainAOA','FlapAOA','Gap','Overlap'}};

Cl = DOE.Cl;
Cd = DOE.Cd;

%% ==========================================================
% Fit Gaussian Process (Kriging) Models
%% ==========================================================
% Standardize data for better Kriging performance
mdlCl = fitrgp(X, Cl, 'KernelFunction', 'matern52', 'Standardize', 1);
mdlCd = fitrgp(X, Cd, 'KernelFunction', 'matern52', 'Standardize', 1);

disp('=======================================')
disp('CL GAUSSIAN PROCESS MODEL FITTED')
disp('=======================================')

%% ==========================================================
% Objective Function (No changes needed)
%% ==========================================================
objective = @(x) -predict(mdlCl, x);

%% ==========================================================
% Variable Bounds
%% ==========================================================

lb = [6 20 7 -2];
ub = [10 40 11 4];

x0 = (lb+ub)/2;

%% ==========================================================
% Optimization (Global Search via MultiStart)
%% ==========================================================
options = optimoptions('fmincon',...
    'Algorithm','sqp',...
    'Display','off'); % Turn off iter display to avoid console spam

% Define the optimization problem structure
problem = createOptimProblem('fmincon',...
    'objective', objective,...
    'x0', x0,...
    'lb', lb, 'ub', ub,...
    'options', options);

% Run fmincon from 20 different random starting points
ms = MultiStart('Display','iter');
[xOpt,~] = run(ms, problem, 20);
%% ==========================================================
% Predicted Optimum
%% ==========================================================

ClOpt = predict(mdlCl,xOpt);
CdOpt = predict(mdlCd,xOpt);

fprintf('\n');
fprintf('=======================================\n');
fprintf('Predicted Optimum\n');
fprintf('=======================================\n');

fprintf('Main AoA   = %.3f deg\n',xOpt(1));
fprintf('Flap AoA   = %.3f deg\n',xOpt(2));
fprintf('Gap        = %.3f mm\n',xOpt(3));
fprintf('Overlap    = %.3f mm\n\n',xOpt(4));

fprintf('Predicted Cl      = %.4f\n',ClOpt);
fprintf('Predicted Cd      = %.5f\n',CdOpt);
fprintf('Predicted Cl/Cd   = %.2f\n',ClOpt/CdOpt);

%% ==========================================================
% Model Predictions
%% ==========================================================

ClPred = predict(mdlCl,X);
CdPred = predict(mdlCd,X);

%% ==========================================================
% Parity Plot - Cl
%% ==========================================================

figure

scatter(Cl,ClPred,70,'filled')
hold on
plot([min(Cl) max(Cl)],...
     [min(Cl) max(Cl)],...
     'k--','LineWidth',2)

xlabel('CFD Cl')
ylabel('Predicted Cl')
title('Parity Plot - Cl')

grid on
axis equal

%% ==========================================================
% Parity Plot - Cd
%% ==========================================================

figure

scatter(Cd,CdPred,70,'filled')
hold on
plot([min(Cd) max(Cd)],...
     [min(Cd) max(Cd)],...
     'k--','LineWidth',2)

xlabel('CFD Cd')
ylabel('Predicted Cd')
title('Parity Plot - Cd')

grid on
axis equal

%% ==========================================================
% Residual Plots
%% ==========================================================
% Calculate predictions and residuals manually for GP models
Cl_fit = predict(mdlCl, X);
Cd_fit = predict(mdlCd, X);

Cl_res = Cl - Cl_fit;
Cd_res = Cd - Cd_fit;

% Residual Plot - Cl
figure
scatter(Cl_fit, Cl_res, 70, 'filled')
hold on
yline(0, 'k--', 'LineWidth', 2)
xlabel('Fitted Cl')
ylabel('Residuals')
title('Residual Plot - Cl')
grid on

% Residual Plot - Cd
figure
scatter(Cd_fit, Cd_res, 70, 'filled')
hold on
yline(0, 'k--', 'LineWidth', 2)
xlabel('Fitted Cd')
ylabel('Residuals')
title('Residual Plot - Cd')
grid on

%% ==========================================================
% Response Surface Example
%
% Main AoA vs Flap AoA
% Gap and Overlap fixed
%% ==========================================================

MainRange = linspace(lb(1),ub(1),50);
FlapRange = linspace(lb(2),ub(2),50);

[M,F] = meshgrid(MainRange,FlapRange);

Gap = 9*ones(size(M));
Overlap = 1*ones(size(M));

Pts = [M(:) F(:) Gap(:) Overlap(:)];

ClSurf = predict(mdlCl,Pts);

ClSurf = reshape(ClSurf,size(M));

figure

surf(M,F,ClSurf)

xlabel('Main AoA (deg)')
ylabel('Flap AoA (deg)')
zlabel('Predicted Cl')

title('Response Surface')

shading interp
colorbar
view(45,30)

%% ==========================================================
% Save Figures
%% ==========================================================

savefig(1,'Parity_c_l.fig')
savefig(2,'Parity_c_d.fig')
savefig(3,'Residual_c_l.fig')
savefig(4,'Residual_c_d.fig')
savefig(5,'Response_Surface.fig')

fprintf('\nAnalysis Complete.\n');