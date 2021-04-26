function [Xn, Vn] = OVM(XX,VV,Sa,v_max,d_safe,da,db,v0,A,B,n,delta,opt,h)
% INPUT:
%   x_first_ini...pocatecni poloha prvniho vozidla
%   x_ini...pocatecni polohy ostatnich vozidel (vektor)
%   v_ini...pocatecni rychlosti ostatnich vozidel (vektor)
% OUTPUT:
%   Hx...polohy v zavislosti na case vsech vozidel
%   Hv...rychlosti v zavislosti na case vsech vozidel

t0 = 0;
x0 = delta * (n - 1);
if delta == 0
    X = zeros(1,n);
else
    X = x0:-delta:0;
end
V = zeros(1,n); % vektor poèáteèních rychlostí - zvoleno 0
V(1) = v1(0, A, B, v0); % pøepoèet pro v1 (závisí na funkci v1)

% rychlost a poloha leadera ------------------------------------------------
% v1(t) = v0 + A .* sin.(B .* t);
% x1(t) = v0 .* t - A ./ B .* cos.(B .* t) + A / B + x0;


% LOOP ----------------------------------------------------------------------
for i = 1:1000
    %scatter(X, ones(10), zcolor=1:10)
    t1 = t0 + h;

    % v t0 to bude vypadat takto
    %delta_x = (X(2:end) - X(1:end - 1));
    delta_x = (X(1:end - 1)-X(2:end));
    
    if opt == 1
        vopt = v_opt1(delta_x, v_max, d_safe);
    elseif opt == 2
        vopt = v_opt2(delta_x,v_max,da,db);
    elseif opt == 3
        vopt = v_opt3(delta_x,v_max,d_safe);
    else 
        vopt = v_opt4(delta_x,v_max,da,db);
    end
    
    a_alpha = zrychleni(vopt, V(2:end), Sa);

    % pøechod k t1
    [Xn, Vn] = euler1(X(2:end), V(2:end), a_alpha, h);
    X(2:end) = Xn;
    V(2:end) = Vn;

    X(1) = x1(t1,x0, A, B, v0);
    V(1) = v1(t1, A, B, v0);


    % posunutí èasu a uložení výsledkù
    t0 = t1;
    XX = cat(1,XX,X);
    VV = cat(1,VV,V);
end


Xn = XX;
Vn = VV;

end