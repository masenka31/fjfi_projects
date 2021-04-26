function x_first = x1(t, x_first_ini, A, B, v0)
    % INPUT:
    %   t...cas
    %   x_first_ini...pocatecni poloha prvniho vozidla
    % OUTPUT:
    %   x_first...poloha prvniho vozidla
        x_first = v0.*t - A./B.*cos(B.*t) + x_first_ini + A/B;
    end