clc; clear all ; close all;

% initial guess
tf = 8;
tspan = 0:1:tf;

u0 = 0.5;

% bounds
lb = 0;
ub = 1;

% Linear inequality constraints: A*z <= b
A = []; b = [];
% Linear equality constraints: Aeq*z = beq
Aeq = []; beq = [];

% constraints
nonlcon = @(u) nonLinearConstraints(u, tspan);

[uopt, fval] = fmincon(@(u) fun(u, tspan),u0, A, b, Aeq, beq, lb, ub, nonlcon);

fprintf('fmincon optimal solution:\n');
fprintf('u = %.4f', uopt(1));
fprintf(' , Maximum value of the P = %.4f\n', -fval);


%%  For visualising the P,V,S and X change with time at optimal u.
% Simulate the system with the optimal u and plot X(t)
mu_m = 0.53; Km = 1.2; Ki = 22; 
Yx = 0.5; Yp = 1; nu = 0.5;     
Sin = 20; Xmax = 3;   
X0 = 1; S0 = 0; P0 = 0; V0 = 2;
initial_conditions = [X0, S0, P0, V0];



% ODE system with optimal u
u_opt = uopt(1);
ode_func_plot = @(t, y) [
    (mu_m * y(2) / (Km + y(2) + (y(2)^2 / Ki))) * y(1) - (u_opt / y(4)) * y(1); % dX/dt
    -(mu_m * y(2) / (Km + y(2) + (y(2)^2 / Ki))) * y(1) / Yx - nu * y(1) / Yp + (u_opt / y(4)) * (Sin - y(2)); % dS/dt
    nu * y(1) - (u_opt / y(4)) * y(3); % dP/dt
    u_opt % dV/dt
];

% Solve ODE
[t_plot, Y_plot] = ode45(ode_func_plot, tspan, initial_conditions);
X_plot = Y_plot(:, 1); % Biomass concentration
S_plot = Y_plot(:, 2); % Substrate concentration
P_plot = Y_plot(:, 3); % Product concentration
V_plot = Y_plot(:, 4); % Volume

% First figure: X(t) vs t
figure;
plot(t_plot, X_plot, 'b',  'LineWidth', 2);

xlabel('Time (t)');
ylabel('Biomass Concentration (X)');
title('Biomass Concentration vs Time');
grid on;
hold on;
yline(Xmax, '--r', 'X_{max} = 3', 'LineWidth', 2);
legend('X(t)', 'Constraint');


% Third figure: Subplot for all variables
figure;
subplot(2, 2, 1);
plot(t_plot, S_plot, 'b',  'LineWidth', 2);
xlabel('Time (t)');
ylabel('X');
title('Biomass Concentration');
grid on;

  
ylabel('S');
title('Substrate Concentration');
grid on;

subplot(2, 2, 3);
plot(t_plot, P_plot, 'b', 'LineWidth', 2);
xlabel('Time (t)');
ylabel('P');
title('Product Concentration');
grid on;

subplot(2, 2, 4);
plot(t_plot, V_plot, 'b', 'LineWidth', 2);
xlabel('Time (t)');
ylabel('V');
title('Volume');
grid on;
%%

function J=fun(u, tspan)
   
    mu_m = 0.53; Km = 1.2; Ki = 22; 
    Yx = 0.5; Yp = 1; nu = 0.5;     
    Sin = 20;                      
  

    % Initial conditions
    X0 = 1; S0 = 0; P0 = 0; V0 = 2;
    initial_conditions = [X0, S0, P0, V0];
    
    %ODE function
    ode_func = @(t, y) [
        (mu_m * y(2) / (Km + y(2) + (y(2)^2 / Ki))) * y(1) - (u / y(4)) * y(1); % dX/dt
        -(mu_m * y(2) / (Km + y(2) + (y(2)^2 / Ki))) * y(1) / Yx - nu * y(1) / Yp + (u / y(4)) * (Sin - y(2)); % dS/dt
        nu * y(1) - (u / y(4)) * y(3);                                    % dP/dt
        u                                                                  % dV/dt
    ];
    
    [t, Y] = ode45(ode_func, tspan, initial_conditions);
    X = Y(:, 1); S = Y(:, 2); P = Y(:, 3); V = Y(:, 4);

    J = -P(end);

end

function [c, ceq] = nonLinearConstraints(u, tspan)
    % non linear inequality constraints
    
    mu_m = 0.53; Km = 1.2; Ki = 22; 
    Yx = 0.5; Yp = 1; nu = 0.5;     
    Sin = 20;                      
    Xmax = 3;   
    tf = 8;                         
    
    % Initial conditions
    X0 = 1; S0 = 0; P0 = 0; V0 = 2;
    initial_conditions = [X0, S0, P0, V0];
    
    %ODE function
    ode_func = @(t, y) [
        (mu_m * y(2) / (Km + y(2) + (y(2)^2 / Ki))) * y(1) - (u / y(4)) * y(1); % dX/dt
        -(mu_m * y(2) / (Km + y(2) + (y(2)^2 / Ki))) * y(1) / Yx - nu * y(1) / Yp + (u / y(4)) * (Sin - y(2)); % dS/dt
        nu * y(1) - (u / y(4)) * y(3);                                    % dP/dt
        u                                                                  % dV/dt
    ];

    [t, Y] = ode45(ode_func, tspan, initial_conditions);
    
    X = Y(:, 1); S = Y(:, 2); P = Y(:, 3); V = Y(:, 4);    
    c = [
        X-Xmax*ones(9,1); 
        ];
    % non linear equality constraints
    ceq =[];
end 


