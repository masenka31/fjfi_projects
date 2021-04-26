function [x_new,v_new] = euler1(x, v, a, h)
        %v_new = v + h .* a
        v_new = max(v + h .* a,0);
        x_new = x + h .* v;
    end