function [x_new, v_new] = euler2(x, v, t, x_first_ini)
% INPUT:
%   x...polohy vozidel v danem case (vektor)
%   v...rychlosti vozidel v danem case (vektor)
%   t...cas
%   x_first_ini...pocatecni poloha prvniho vozidla
% OUTPUT:
%   x_new...nove polohy vozidel (vektor)
%   v_new...nove rychlosti vozidel (vektor)

    global h
    
    x_new = x + h * v;
    v_new = v + h * F(x, v, t, x_first_ini);
end