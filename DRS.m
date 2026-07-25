%%%%%%%%%%%%%%%%%
% DRS System
%%%%%%%%%%%%%%%%%

aeroData = readmatrix("xf-s1223-il-1000000.csv");
AOA = aeroData(:,1);
Cl = aeroData(:,2);
Cd = aeroData(:,3);

telemetry = readmatrix("Logged Data.csv");
speed = 0.277777777 .* telemetry(9:2846,2);
throttlePos = telemetry(9:2846,3);
brakePos = telemetry(9:2846,4);
steeringAngle = telemetry(9:2846,5);
lapTime = telemetry(9:2846,6);

smoothed_steering = movmean(abs(steeringAngle), 20);

sim_speed = [lapTime, speed];
sim_throttle = [lapTime, throttlePos];
sim_brake = [lapTime, brakePos];
sim_steering = [lapTime, smoothed_steering];

AOAConversion = readmatrix("ServoAOAConversionTable.csv");
AOAConv = AOAConversion(19:71,1);
ServoConv = AOAConversion(19:71,2);

