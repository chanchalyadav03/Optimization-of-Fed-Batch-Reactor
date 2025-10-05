warning('off','all');
clc;
clear;
close all;

%% Discretization settings
N = 8; % number of time intervals
dt = 1; % step size
tf = N * dt; % final time

%% Initial guesses and bounds
X0 = 1; S0 = 0; V0 = 2;
P0 = 0;
z0 = 0.5 * ones(1, N); % initial guess for u(t)

lb = zeros(1, N);     % lower bound for u(t)
ub = ones(1, N);      % upper bound for u(t)

%% Optimization using fmincon
opts = optimoptions('fmincon', 'Display', 'iter', 'MaxFunctionEvaluations', 1e4);
[zopt, fval] = fmincon(@(u) objFun(u, X0, S0, P0, V0, dt, N), z0, [], [], [], [], lb, ub, ...
                       @(u) nonLinCon(u, X0, S0, P0, V0, dt, N), opts);

%% Simulate with optimized u(t)
[t, Y] = simulateSystem(zopt, X0, S0, P0, V0, dt, N);
X = Y(:,1); S = Y(:,2); P = Y(:,3); V = Y(:,4);

%% Results
fprintf('Final product P(tf) = %.4f\n', P(end));

% Plot results
figure;
subplot(2,2,1); plot(t, X, 'b', 'LineWidth', 2); ylabel('Biomass (X)');
yline(3, '--r', 'X_{max}'); title('Biomass Concentration');

subplot(2,2,2); plot(t, S, 'b', 'LineWidth', 2); ylabel('Substrate (S)');
title('Substrate Concentration');

subplot(2,2,3); plot(t, P, 'b', 'LineWidth', 2); ylabel('Product (P)');
title('Product Concentration');

subplot(2,2,4); plot(t, V, 'b', 'LineWidth', 2); ylabel('Volume (V)');
title('Volume');

figure;
stairs(0:N-1, zopt, 'k', 'LineWidth', 2);
xlabel('Time step'); ylabel('u(t)');
title('Optimized Feed Rate Profile');

%% Objective function
function J = objFun(u, X0, S0, P0, V0, dt, N)
    [~, Y] = simulateSystem(u, X0, S0, P0, V0, dt, N);
    J = -Y(end,3); % maximize final product
end

%% Nonlinear constraint: X(t) <= 3
function [c, ceq] = nonLinCon(u, X0, S0, P0, V0, dt, N)
    [~, Y] = simulateSystem(u, X0, S0, P0, V0, dt, N);
    X = Y(:,1);
    c = max(X) - 3; 
    ceq = [];
end

%% Simulation function with piecewise constant u(t)
function [t, Y] = simulateSystem(u, X0, S0, P0, V0, dt, N)
    Y = zeros(N+1, 4);
    Y(1,:) = [X0, S0, P0, V0];
    t = 0:dt:N;
    for i = 1:N
        u_i = u(i);
        ode = @(t, y) [
            (0.53 * y(2) / (1.2 + y(2) + (y(2)^2 / 22))) * y(1) - (u_i / y(4)) * y(1);
            -(0.53 * y(2) / (1.2 + y(2) + (y(2)^2 / 22))) * y(1) / 0.5 - 0.5 * y(1) / 1 + (u_i / y(4)) * (20 - y(2));
            0.5 * y(1) - (u_i / y(4)) * y(3);
            u_i
        ];
        [~, Yseg] = ode45(ode, [0 dt], Y(i,:));
        Y(i+1,:) = Yseg(end,:);
    end
end
