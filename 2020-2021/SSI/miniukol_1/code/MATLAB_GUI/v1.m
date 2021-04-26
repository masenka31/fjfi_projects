function v_first = v1(t, A, B, v0)
    % INPUT:
    %   t...cas
    % OUTPUT:
    %   v_first...rychlost prvniho vozidla
        v_first = v0 + A.*sin(B.*t);
    end