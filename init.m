%% Passenger-car 2-DOF: Passive vs. Semi-Active Setup
clear; clc;

%% 1. Physical Parameters
m   = 1600;        % Sprung mass [kg]
Jy  = 2500;        % Pitch moment of inertia [kg*m^2]
kf  = 35e3;        % Front axle stiffness [N/m]
kr  = 35e3;        % Rear axle stiffness [N/m]
cf  = 3.5e3;       % Nominal front damping [N*s/m]
cr  = 3.5e3;       % Nominal rear damping [N*s/m]
c_min = 500;       % min active damping [N*s/m]
c_max = 4000;      % max active damping [N*s/m]
a   = 1.2;         % CG to front axle [m]
b   = 1.6;         % CG to rear axle [m]
h   = 0.5;         % CG height above pitch axis [m]

%% 2. PASSIVE MODEL SETUP
% States: x = [z; dz; theta; dtheta]
% Inputs for Passive: [ax] (only braking deceleration disturbance)
Ap = [0, 1, 0, 0;
     -(kf+kr)/m, -(cf+cr)/m, -(kf*a-kr*b)/m, -(cf*a-cr*b)/m;
     0, 0, 0, 1;
     -(kf*a-kr*b)/Jy, -(cf*a-cr*b)/Jy, -(kf*a^2+kr*b^2)/Jy, -(cf*a^2+cr*b^2)/Jy];

Bp = [0;
     0;
     0;
     -(m*h)/Jy]; % driven by braking deceleration ax

Cp = eye(4); % Output all states
Dp = zeros(4, 1);

sys_passive = ss(Ap, Bp, Cp, Dp);


%% 3. SEMI-ACTIVE MODEL SETUP
% For semi-active control, inputs u = [udf; udr; ax]
% Where udf and udr are the controlled damping forces acting on front/rear
As = Ap; % Internal dynamics can use baseline or zero damping

Bs = [0, 0, 0;
     -1/m, -1/m, 0;
     0, 0, 0;
     a/Jy, -b/Jy, -(m*h)/Jy];

Cs = Cp;
Ds = zeros(4, 3);

sys_semi_active = ss(As, Bs, Cs, Ds);


%% 4. LQR CONTROLLER DESIGN FOR SEMI-ACTIVE MODEL
% We want to minimize:
% - Pitch angle (theta) -> to stop brake dive
% - Pitch velocity (dtheta) -> to smooth transients
% - Heave (z)
% Weights Q (states) and R (control inputs: [udf, udr])
Q = diag([100, 10, 50000, 1000]); % Heavy penalty on pitch theta and heave
R = diag([1e-6, 1e-6]);          % Control effort penalty

% Extract sub-matrices for the control inputs only (first 2 columns of Bs)
B_control = Bs(:, 1:2);
K = lqr(As, B_control, Q, R);

disp('LQR Gain Matrix K computed successfully for Semi-Active Control:')
disp(K)