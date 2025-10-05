clc; clear all; close all;
% parameters
mu_m = 0.53; Km = 1.2; Ki = 22; 
Yx = 0.5; Yp = 1; nu = 0.5;     
Sin = 20;                      
u = 0.5; Xmax = 3;   
tf = 8;                         

% Initial conditions
X0 = 1; S0 = 0; P0 = 0; V0 = 2;
initial_conditions = [X0, S0, P0, V0];

%ODE function
ode_func = @(t, y) [
    (mu_m * y(2) / (Km + y(2) + (y(2)^2 / Ki))) * y(1) - (u / y(4)) * y(1); % dX/dt
    -((mu_m * y(2) / (Km + y(2) + (y(2)^2 / Ki))) * y(1)) / Yx - (nu * y(1))/ Yp + (u / y(4)) * (Sin - y(2)); % dS/dt
    nu * y(1) - (u / y(4)) * y(3);                                    % dP/dt
    u                                                                  % dV/dt
];

time_span = [0 tf];

[t, Y] = ode45(ode_func, time_span, initial_conditions);

X = Y(:, 1); S = Y(:, 2); P = Y(:, 3); V = Y(:, 4);

product = P(end);
% Plots
figure;
subplot(2, 2, 1); plot(t, X, 'LineWidth', 2); xlabel('Time (h)'); ylabel('Biomass (X)');
subplot(2, 2, 2); plot(t, S, 'LineWidth', 2); xlabel('Time (h)'); ylabel('Substrate (S)');
subplot(2, 2, 3); plot(t, P, 'LineWidth', 2); xlabel('Time (h)'); ylabel('Product (P)');
subplot(2, 2, 4); plot(t, V, 'LineWidth', 2); xlabel('Time (h)'); ylabel('Volume (V)');

fprintf('The final product concentration P is: %.4f at u = %.4f\n', product, u);

