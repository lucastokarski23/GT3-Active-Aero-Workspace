%% ==========================================================
% GT3 Rear Wing DOE Generator
% Central Composite Design (CCD)
%
% Variables:
%   1) Main Element AoA (deg)
%   2) Flap AoA (deg)
%   3) Slot Gap (mm)
%   4) Overlap (mm)
%
% Author: Lucas Tokarski
%% ==========================================================

clc
clear
close all

%% ==========================================================
% Fixed Random Seed
% (Makes the DOE identical every time you run this script)
%% ==========================================================

rng(1,'twister')

%% ==========================================================
% Design Variable Limits
%% ==========================================================

% Main Element AoA
Main_min = 6;
Main_max = 10;

% Flap AoA
Flap_min = 20;
Flap_max = 40;

% Slot Gap
Gap_min = 7;
Gap_max = 11;

% Overlap
Overlap_min = -2;
Overlap_max = 4;

%% ==========================================================
% Generate Central Composite Design
%% ==========================================================

k = 4;

CCD = ccdesign(k,'type','inscribed');

%% ==========================================================
% Scale CCD from [-1,1] to Engineering Units
%% ==========================================================

MainAOA = ((CCD(:,1)+1)/2)*(Main_max-Main_min)+Main_min;

FlapAOA = ((CCD(:,2)+1)/2)*(Flap_max-Flap_min)+Flap_min;

Gap = ((CCD(:,3)+1)/2)*(Gap_max-Gap_min)+Gap_min;

Overlap = ((CCD(:,4)+1)/2)*(Overlap_max-Overlap_min)+Overlap_min;

%% ==========================================================
% Create Run Numbers
%% ==========================================================

Run = (1:length(MainAOA))';

%% ==========================================================
% CFD Results
%
% Leave these blank initially.
% Fill them in as you complete Fluent simulations.
%% ==========================================================

Cl = nan(length(Run),1);
Cd = nan(length(Run),1);

%% ==========================================================
% Build DOE Table
%% ==========================================================

DOE = table(...
    Run,...
    MainAOA,...
    FlapAOA,...
    Gap,...
    Overlap,...
    Cl,...
    Cd);

%% ==========================================================
% Display Table
%% ==========================================================

disp(DOE)

%% ==========================================================
% Save Files
%% ==========================================================

writetable(DOE,'CCD_GT3_Wing_DOE.xlsx');

save('CCD_GT3_Wing_DOE.mat','DOE');

fprintf('\n');
fprintf('=========================================\n');
fprintf('DOE successfully generated.\n');
fprintf('Number of CFD Cases: %d\n',height(DOE));
fprintf('Excel File : CCD_GT3_Wing_DOE.xlsx\n');
fprintf('MAT File   : CCD_GT3_Wing_DOE.mat\n');
fprintf('=========================================\n');

%% ==========================================================
% HOW TO USE
%
% Run this script ONCE.
%
% Open:
% CCD_GT3_Wing_DOE.xlsx
%
% Perform CFD in the listed order.
%
% Enter Cl and Cd into the spreadsheet OR MATLAB table.
%
% DO NOT rerun this script after starting CFD,
% otherwise you'll overwrite your results.
%% ==========================================================