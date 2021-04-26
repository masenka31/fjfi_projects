function x_first = x1(t, x_first_ini)
% INPUT:
%   t...cas
%   x_first_ini...pocatecni poloha prvniho vozidla
% OUTPUT:
%   x_first...poloha prvniho vozidla

    global A B v_poc
    
    x_first = v_poc*t - A/B*cos(B*t) + x_first_ini + A/B;
end

