warning('off','all')

% Parameters
mu_m = 0.53; Km = 1.2; Ki = 22; 
Yx = 0.5; Yp = 1; nu = 0.5; 
u_min = 0; u_max = 1;
Sin = 20;                      
Xmax = 3;   
tf = 8;                         

% Initial conditions
X0 = 1; S0 = 0; P0 = 0; V0 = 2;
initial_conditions = [X0, S0, P0, V0];

PFinal = []; 
stepSize = 0.1;
U = u_min:stepSize:u_max; 
time_span = [0 tf];

figure;

figure(1)
hold on;

for u = U
    % ODE function
    ode_func = @(t, y) [
        (mu_m * y(2) / (Km + y(2) + (y(2)^2 / Ki))) * y(1) - (u / y(4)) * y(1); % dX/dt
        -(mu_m * y(2) / (Km + y(2) + (y(2)^2 / Ki))) * y(1) / Yx - nu * y(1) / Yp + (u / y(4)) * (Sin - y(2)); % dS/dt
        nu * y(1) - (u / y(4)) * y(3);                                    % dP/dt
        u                                                                  % dV/dt
    ];

    [t, Y] = ode45(ode_func, time_span, initial_conditions);
    X = Y(:, 1); S = Y(:, 2); P = Y(:, 3); V = Y(:, 4);

    PFinal(end+1) = P(end);   
    figure(2);
    hold on;
    plot(t, P, 'DisplayName', sprintf('u = %.2f', u), LineWidth=2); % Plot P over time

    fprintf("u= %.2f, P_end = %.3f\n", u, P(end));
end


figure(1);
scatter(U, PFinal,15, filled = 'o', color = 'b');
ylim([1.5,7])
[maxY, idx] = max(PFinal);
maxX = U(idx);

hold on;
plot([maxX, maxX], [0, maxY], 'r--', LineWidth=1.5); % Vertical
plot([0, maxX], [maxY, maxY], 'r--', LineWidth=1.5); % Horizontal

% Annotate maximum point
text(maxX, maxY, sprintf('Max: (%.4f, %.4f)', maxX, maxY), ...
    'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'FontSize', 15, 'Color', 'red');

xlabel('Flow Rate (u)');
ylabel('Final Product (P)');
title('Final Product vs Feed Volumetric Flow Rate');
grid on;

figure(2)
xlabel('Time');
ylabel('Product (P)');
title('Product Variation over Time for Different Flow Rates');
legend show; 
grid on;

fprintf("We got the maximum P = %.4f at u = %.4f\n", max(PFinal), maxX);
