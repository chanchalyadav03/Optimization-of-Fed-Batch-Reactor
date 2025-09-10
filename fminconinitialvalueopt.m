warning('off','all');
clc;
clear;
close all;
% Initial guess [X0, S0, V0, u tf]
z0 = [1, 0, 2, 0.5, 4];

% Bounds [X0, S0, V0, u, tf]
lb = [0.5, 0, 0.1, 0, 2];   
ub = [2, 4, 4, 1, 20];    

% linear constraints
A = []; b = [];
Aeq = []; beq = [];

% define fmincon
[zopt, fval] = fmincon(@(z) objectiveFunction(z), z0, A, b, Aeq, beq, lb, ub, @(z) nonLinearConstraints(z));

X0_opt = zopt(1);
S0_opt = zopt(2);
V0_opt = zopt(3);
u_opt = zopt(4);
tf_opt = zopt(5);

% results
fprintf('X0 = %.4f\n', X0_opt);
fprintf('S0 = %.4f\n', S0_opt);
fprintf('V0 = %.4f\n', V0_opt);
fprintf('u = %.4f\n', u_opt);
fprintf('tf = %.4f\n', tf_opt);
fprintf('Maximum product P(tf) = %.4f\n', -fval);

%% plots at optimal conditions
tspan = linspace(0, tf_opt, 20);
initial_conditions = [X0_opt, S0_opt, 0, V0_opt];

% solving odes for optimal values
ode_func = @(t, y) [
    (0.53 * y(2) / (1.2 + y(2) + (y(2)^2 / 22))) * y(1) - (u_opt / y(4)) * y(1);
    -(0.53 * y(2) / (1.2 + y(2) + (y(2)^2 / 22))) * y(1) / 0.5 - 0.5 * y(1) / 1 + (u_opt / y(4)) * (20 - y(2));
    0.5 * y(1) - (u_opt / y(4)) * y(3);
    u_opt
];

[t, Y] = ode45(ode_func, tspan, initial_conditions);
X = Y(:,1); S = Y(:,2); P = Y(:,3); V = Y(:,4);

% Plot results
figure;
subplot(2,2,1);
plot(t, X, 'b', 'LineWidth', 2);
xlabel('Time'); ylabel('Biomass (X)');
title('Biomass Concentration');
yline(3, '--r', 'X_{max}');

subplot(2,2,2);
plot(t, S, 'b', 'LineWidth', 2);
xlabel('Time'); ylabel('Substrate (S)');
title('Substrate Concentration');

subplot(2,2,3);
plot(t, P, 'b', 'LineWidth', 2);
xlabel('Time'); ylabel('Product (P)');
title('Product Concentration');

subplot(2,2,4);
plot(t, V, 'b', 'LineWidth', 2);
xlabel('Time'); ylabel('Volume (V)');
title('Volume');

%% Obj func max P(tf)
function J = objectiveFunction(z)
    X0 = z(1); S0 = z(2); V0 = z(3); u = z(4); tf = z(5);
    tspan = linspace(0, tf, 20);
    P0 = 0; 

    % ODE system
    ode_func = @(t, y) [
        (0.53 * y(2) / (1.2 + y(2) + (y(2)^2 / 22))) * y(1) - (u / y(4)) * y(1);
        -(0.53 * y(2) / (1.2 + y(2) + (y(2)^2 / 22))) * y(1) / 0.5 - 0.5 * y(1) / 1 + (u / y(4)) * (20 - y(2));
        0.5 * y(1) - (u / y(4)) * y(3);
        u
    ];
    
    [~, Y] = ode45(ode_func, tspan, [X0, S0, P0, V0]);
    J = -Y(end, 3); 
end

%% NonLin constraints:
function [c, ceq] = nonLinearConstraints(z)
    Xmax = 3;
    X0 = z(1); S0 = z(2); V0 = z(3); u = z(4); tf = z(5);
    P0 = 0;
    tspan = linspace(0, tf, 20);
    
    ode_func = @(t, y) [
        (0.53 * y(2) / (1.2 + y(2) + (y(2)^2 / 22))) * y(1) - (u / y(4)) * y(1);
        -(0.53 * y(2) / (1.2 + y(2) + (y(2)^2 / 22))) * y(1) / 0.5 - 0.5 * y(1) / 1 + (u / y(4)) * (20 - y(2));
        0.5 * y(1) - (u / y(4)) * y(3);
        u
    ];
    
    [~, Y] = ode45(ode_func, tspan, [X0, S0, P0, V0]);
    X = Y(:,1);
    c = [
         max(X) - Xmax; 
    ];
    ceq = [];
end

