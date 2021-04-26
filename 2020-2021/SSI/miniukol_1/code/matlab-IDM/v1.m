function v_first = v1(t)
% INPUT:
%   t...cas
% OUTPUT:
%   v_first...rychlost prvniho vozidla

    global A B v_poc
    
    v_first = v_poc + A*sin(B*t);
end

