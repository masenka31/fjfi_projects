[Hx, Hv] = IDM(x_first_ini, x_ini, v_ini)
% INPUT:
%   x_first_ini...pocatecni poloha prvniho vozidla
%   x_ini...pocatecni polohy ostatnich vozidel (vektor)
%   v_ini...pocatecni rychlosti ostatnich vozidel (vektor)
% OUTPUT:
%   Hx...polohy v zavislosti na case vsech vozidel
%   Hv...rychlosti v zavislosti na case vsech vozidel
%   + vizualizace
%   + casoprostorovy diagram

%% globalni promenne, nastaveni jejich hodnot, rozpeti
global h                            % krok
global A B v_poc                    % pro prvni vozidlo
global a b v_0 d_safe T_safe delta  % pro definici IDM

h = 0.1;
v_poc = 5; A = 5; B = 0.2;
a = 0.8; b = 5; v_0 = 50; d_safe = 2; T_safe = 2; delta = 4;

t = 0;                              % startovni cas
tmax = 100; xmax = 800;              % nastaveni mezi

%% osetreni vstupu funkce, pocatecni stav
if nargin < 3
    if nargin < 2
        x_ini = 0:7:50;
        if nargin < 1
            x_first_ini = x_ini(end) + 10; 
        end     
    end   
    v_ini = 0 .* x_ini;
end
x = x_ini; v = v_ini;
Hx = []; Hv = [];

%% simulace
while t <= tmax                % poloprimka, tj. jsme omezeni jen casem
    [x, v] = euler2(x, v, t, x_first_ini);   
    Hx = [Hx; x x1(t, x_first_ini)];
    Hv = [Hv; v v1(t)];
    t = t + h;
    
    % vykresleni simulace
    subplot(2, 1, 1); 
    bar([x, x1(t, x_first_ini)], [v, v1(t)], 0, 'b');
    axis([0 xmax 0 v_poc+A]);
    
    subplot(2, 1, 2);
    p = plot([x, x1(t, x_first_ini)], -1, 'ob');
    set(p(end), 'MarkerFaceColor', 'r'); 
    set(p(1), 'MarkerFaceColor', 'g');
    xlim([0 xmax]);
    pause(0.01);
end

% casoprostorovy diagram
figure(2);
plot(h:h:t, Hx);
axis([0 tmax 0 max(x)]);
xlabel('Simulation time'); 
ylabel('Location');

% rychlosti vozidel
figure(3);
for i = 1 : size(Hv, 2)-1
    plot(h:h:t, Hv(:, i));
    hold on;
end
plot(h:h:t, Hv(:, end), 'k', 'LineWidth', 3);
xlabel('Simulation time');
ylabel('Speed');
end