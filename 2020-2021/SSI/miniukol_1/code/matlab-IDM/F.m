function v_tecka = F(x, v, t, x_first_ini)
% INPUT:
%   x...polohy vozidel v danem case (vektor)
%   v...rychlosti vozidel v danem case (vektor)
%   t...cas
%   x_first_ini...pocatecni poloha prvniho vozidla
% OUTPUT:
%   v_tecka...zrychleni vozidel (vektor)

    global a b v_0 d_safe T_safe delta
    
    v_all = [v(2:end), v1(t)];
    delta_v = v_all - v;
    
    x_all = [x(2:end), x1(t, x_first_ini)];
    d = x_all - x;
    
    d_star = max(0 , d_safe + v .* T_safe - (v.*delta_v/(2*sqrt(a*b))));
    
    v_tecka = a * ( 1 - (v./v_0).^delta - (d_star./d).^2 );
end